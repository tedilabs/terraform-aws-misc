data "aws_caller_identity" "this" {}
data "aws_canonical_user_id" "this" {}

locals {
  cloudfront_canonical_user_id = "c4c1ede66af53448b93c283ce9448c4ba468c9432aa01d700d3878632f77d2d0"

  default_grants = [
    {
      type       = "CanonicalUser"
      id         = data.aws_canonical_user_id.this.id
      permission = "FULL_CONTROL"
    }
  ]
  cloudfront_grant = {
    type       = "CanonicalUser"
    id         = local.cloudfront_canonical_user_id
    permission = "FULL_CONTROL"
  }

  grants = concat(
    local.default_grants,
    var.delivery_cloudfront_enabled ? [local.cloudfront_grant] : [],
    var.grants
  )
}


###################################################
# Policy for S3 Bucket
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
  bucket = aws_s3_bucket.this.bucket

  rule {
    object_ownership = var.object_ownership
  }
}


###################################################
# ACL for S3 Bucket
###################################################

# TODO: `expected_bucket_owner`
# INFO: Not supported attributes
# - `acl`
# - `access_control_policy.owner.display_name`
resource "aws_s3_bucket_acl" "this" {
  bucket = aws_s3_bucket.this.bucket

  access_control_policy {
    dynamic "grant" {
      for_each = local.grants

      content {
        grantee {
          type          = grant.value.type
          id            = try(grant.value.id, null)
          uri           = try(grant.value.uri, null)
          email_address = try(grant.value.email, null)
        }
        permission = grant.value.permission
      }
    }

    owner {
      id = data.aws_canonical_user_id.this.id
    }
  }
}


###################################################
# Public Access Block for S3 Bucket
###################################################

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.bucket

  # Block new public ACLs and uploading public objects
  block_public_acls = !var.public_access_enabled
  # Retroactively remove public access granted through public ACLs
  ignore_public_acls = !var.public_access_enabled
  # Block new public bucket policies
  block_public_policy = !var.public_access_enabled
  # Retroactivley block public and cross-account access if bucket has public policies
  restrict_public_buckets = !var.public_access_enabled

  # To avoid OperationAborted: A conflicting conditional operation is currently in progress
  depends_on = [
    aws_s3_bucket_policy.this,
  ]
}
