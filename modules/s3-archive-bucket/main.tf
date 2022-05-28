locals {
  metadata = {
    package = "terraform-aws-misc"
    version = trimspace(file("${path.module}/../../VERSION"))
    module  = basename(path.module)
    name    = var.name
  }
  module_tags = var.module_tags_enabled ? {
    "module.terraform.io/package"   = local.metadata.package
    "module.terraform.io/version"   = local.metadata.version
    "module.terraform.io/name"      = local.metadata.module
    "module.terraform.io/full-name" = "${local.metadata.package}/${local.metadata.module}"
    "module.terraform.io/instance"  = local.metadata.name
  } : {}
}

data "aws_caller_identity" "this" {}
data "aws_canonical_user_id" "this" {}

locals {
  cloudfront_canonical_user_id = "c4c1ede66af53448b93c283ce9448c4ba468c9432aa01d700d3878632f77d2d0"

  default_grants = [
    {
      type        = "CanonicalUser"
      id          = data.aws_canonical_user_id.this.id
      permissions = ["FULL_CONTROL"]
    }
  ]
  cloudfront_grant = {
    type        = "CanonicalUser"
    id          = local.cloudfront_canonical_user_id
    permissions = ["FULL_CONTROL"]
  }

  grants = concat(
    local.default_grants,
    var.delivery_cloudfront_enabled ? [local.cloudfront_grant] : [],
    var.grants
  )
}


###################################################
# S3 Bucket for archive
###################################################

# TODO: object_lock_configuration
resource "aws_s3_bucket" "this" {
  bucket        = var.name
  force_destroy = var.force_destroy

  acceleration_status = var.transfer_acceleration_enabled ? "Enabled" : "Suspended"

  dynamic "grant" {
    for_each = length(local.grants) > 1 ? local.grants : []

    content {
      type        = try(grant.value.type, null)
      id          = try(grant.value.id, null)
      uri         = try(grant.value.uri, null)
      permissions = try(grant.value.permissions, [])
    }
  }

  dynamic "lifecycle_rule" {
    for_each = var.lifecycle_rules

    content {
      id      = try(lifecycle_rule.value.id, null)
      enabled = try(lifecycle_rule.value.enabled, true)
      prefix  = try(lifecycle_rule.value.prefix, null)
      tags    = try(lifecycle_rule.value.tags, null)

      abort_incomplete_multipart_upload_days = try(lifecycle_rule.value.abort_incomplete_multipart_upload_days, null)

      expiration {
        date = try(lifecycle_rule.value.expiration.date, null)
        days = try(lifecycle_rule.value.expiration.days, 0)

        expired_object_delete_marker = try(lifecycle_rule.value.expiration.expired_object_delete_marker, false)
      }

      dynamic "transition" {
        for_each = try(lifecycle_rule.value.transitions, [])

        content {
          date = try(transition.value.date, null)
          days = try(transition.value.days, null)

          storage_class = transition.value.storage_class
        }
      }

      noncurrent_version_expiration {
        days = try(lifecycle_rule.value.noncurrent_version_expiration.days, null)
      }

      dynamic "noncurrent_version_transition" {
        for_each = try(lifecycle_rule.value.noncurrent_version_transitions, [])

        content {
          days = try(noncurrent_version_transition.value.days, null)

          storage_class = noncurrent_version_transition.value.storage_class
        }
      }
    }
  }

  dynamic "logging" {
    for_each = var.logging_s3_bucket != null ? ["go"] : []

    content {
      target_bucket = var.logging_s3_bucket
      target_prefix = try(var.logging_s3_key_prefix, null)
    }
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = merge(
    {
      "Name" = local.metadata.name
    },
    local.module_tags,
    var.tags,
  )
}


###################################################
# IAM Policy for S3 Bucket
###################################################

data "aws_iam_policy_document" "this" {
  source_policy_documents = concat(
    var.tls_required ? [data.aws_iam_policy_document.tls_required.json] : [],
    var.delivery_cloudtrail_enabled ? [data.aws_iam_policy_document.cloudtrail.json] : [],
    var.delivery_config_enabled ? [data.aws_iam_policy_document.config.json] : [],
    var.delivery_elb_enabled ? [data.aws_iam_policy_document.elb.json] : [],
  )
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.this.json
}


###################################################
# Object Ownership for S3 Bucket
###################################################

resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    object_ownership = var.object_ownership
  }
}


###################################################
# Public Access Block for S3 Bucket
###################################################

resource "aws_s3_bucket_public_access_block" "this" {
  count = var.public_access_block_enabled ? 1 : 0

  bucket = aws_s3_bucket.this.id

  # Block new public ACLs and uploading public objects
  block_public_acls = true
  # Retroactively remove public access granted through public ACLs
  ignore_public_acls = true
  # Block new public bucket policies
  block_public_policy = true
  # Retroactivley block public and cross-account access if bucket has public policies
  restrict_public_buckets = true

  # To avoid OperationAborted: A conflicting conditional operation is currently in progress
  depends_on = [
    aws_s3_bucket.this,
    aws_s3_bucket_policy.this,
  ]
}
