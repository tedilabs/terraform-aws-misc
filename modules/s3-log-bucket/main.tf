data "aws_caller_identity" "this" {}
data "aws_canonical_user_id" "this" {}
data "aws_cloudtrail_service_account" "this" {}
data "aws_elb_service_account" "this" {}

locals {
  ## CloudFront
  cloudfront_canonical_user_id = "c4c1ede66af53448b93c283ce9448c4ba468c9432aa01d700d3878632f77d2d0"
  cloudfront_bucket_prefixes = [
    for prefix in var.cloudfront_bucket_prefixes :
    trim(prefix, "/")
  ]
  cloudfront_resources = [
    for prefix in local.cloudfront_bucket_prefixes :
    prefix != ""
    ? format("%s/%s/*", aws_s3_bucket.this.arn, prefix)
    : format("%s/*", aws_s3_bucket.this.arn)
  ]

  ## CloudTrail
  cloudtrail_bucket_prefixes = [
    for prefix in var.cloudtrail_bucket_prefixes :
    trim(prefix, "/")
  ]
  cloudtrail_resources = [
    for prefix in local.cloudtrail_bucket_prefixes :
    prefix != ""
    ? format("%s/%s/*", aws_s3_bucket.this.arn, prefix)
    : format("%s/*", aws_s3_bucket.this.arn)
  ]

  ## ELB
  elb_bucket_prefixes = [
    for prefix in var.elb_bucket_prefixes :
    trim(prefix, "/")
  ]
  elb_resources = [
    for prefix in local.elb_bucket_prefixes :
    prefix != ""
    ? format("%s/%s/*", aws_s3_bucket.this.arn, prefix)
    : format("%s/*", aws_s3_bucket.this.arn)
  ]
}

locals {
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
    var.cloudfront_enabled ? [local.cloudfront_grant] : [],
    var.grants
  )
}


###################################################
# S3 Bucket for AWS Logs
###################################################

resource "aws_s3_bucket" "this" {
  bucket        = var.name
  force_destroy = var.force_destroy

  dynamic "grant" {
    for_each = length(local.grants) > 1 ? local.grants : []

    content {
      type        = lookup(grant.value, "type", "")
      id          = lookup(grant.value, "id", "")
      uri         = lookup(grant.value, "uri", "")
      permissions = lookup(grant.value, "permissions", [])
    }
  }

  lifecycle_rule {
    id      = "default-lifecycle"
    enabled = true

    expiration {
      date                         = var.default_expiration_enabled ? var.default_expiration_date : null
      days                         = var.default_expiration_enabled ? var.default_expiration_days : 0
      expired_object_delete_marker = false
    }
  }

  dynamic "lifecycle_rule" {
    for_each = local.cloudfront_bucket_prefixes

    content {
      id      = "cloudfront-lifecycle-${lifecycle_rule.key}"
      prefix  = lifecycle_rule.value
      enabled = true

      expiration {
        date                         = var.cloudfront_expiration_enabled ? var.cloudfront_expiration_date : null
        days                         = var.cloudfront_expiration_enabled ? var.cloudfront_expiration_days : 0
        expired_object_delete_marker = false
      }
    }
  }

  dynamic "lifecycle_rule" {
    for_each = local.cloudtrail_bucket_prefixes

    content {
      id      = "cloudtrail-lifecycle-${lifecycle_rule.key}"
      prefix  = lifecycle_rule.value
      enabled = true

      expiration {
        date                         = var.cloudtrail_expiration_enabled ? var.cloudtrail_expiration_date : null
        days                         = var.cloudtrail_expiration_enabled ? var.cloudtrail_expiration_days : 0
        expired_object_delete_marker = false
      }
    }
  }

  dynamic "lifecycle_rule" {
    for_each = local.elb_bucket_prefixes

    content {
      id      = "elb-lifecycle-${lifecycle_rule.key}"
      prefix  = lifecycle_rule.value
      enabled = true

      expiration {
        date                         = var.elb_expiration_enabled ? var.elb_expiration_date : null
        days                         = var.elb_expiration_enabled ? var.elb_expiration_days : 0
        expired_object_delete_marker = false
      }
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
      "Name" = var.name
    },
    var.tags,
  )
}


###################################################
# IAM Policy for S3 Bucket
###################################################

data "aws_iam_policy_document" "this" {
  ## CloudTrail
  dynamic "statement" {
    for_each = var.cloudtrail_enabled ? ["go"] : []

    content {
      sid    = "cloudtrail-get-bucket-acl"
      effect = "Allow"
      principals {
        type        = "AWS"
        identifiers = [data.aws_cloudtrail_service_account.this.arn]
      }
      actions   = ["s3:GetBucketAcl"]
      resources = [aws_s3_bucket.this.arn]
    }
  }

  dynamic "statement" {
    for_each = var.cloudtrail_enabled ? ["go"] : []

    content {
      sid    = "cloudtrail-put-object"
      effect = "Allow"
      principals {
        type        = "AWS"
        identifiers = [data.aws_cloudtrail_service_account.this.arn]
      }
      actions   = ["s3:PutObject"]
      resources = local.cloudtrail_resources
      condition {
        test     = "StringEquals"
        variable = "s3:x-amz-acl"
        values   = ["bucket-owner-full-control"]
      }
    }
  }

  ## ELB
  dynamic "statement" {
    for_each = var.elb_enabled ? ["go"] : []

    content {
      sid    = "elb-get-bucket-acl"
      effect = "Allow"
      principals {
        type        = "Service"
        identifiers = ["delivery.logs.amazonaws.com"]
      }
      actions   = ["s3:GetBucketAcl"]
      resources = [aws_s3_bucket.this.arn]
    }
  }

  dynamic "statement" {
    for_each = var.elb_enabled ? ["go"] : []

    content {
      sid    = "elb-put-object"
      effect = "Allow"
      principals {
        type        = "AWS"
        identifiers = [data.aws_elb_service_account.this.arn]
      }
      actions   = ["s3:PutObject"]
      resources = local.elb_resources
    }
  }

  dynamic "statement" {
    for_each = var.elb_enabled ? ["go"] : []

    content {
      sid    = "elb-put-object-log-delivery"
      effect = "Allow"
      principals {
        type        = "Service"
        identifiers = ["delivery.logs.amazonaws.com"]
      }
      actions   = ["s3:PutObject"]
      resources = local.elb_resources
      condition {
        test     = "StringEquals"
        variable = "s3:x-amz-acl"
        values   = ["bucket-owner-full-control"]
      }
    }
  }

  ## Enforce TLS (HTTPS Only)
  dynamic "statement" {
    for_each = var.enforce_tls ? ["go"] : []

    content {
      sid    = "enforce-tls-requests-only"
      effect = "Deny"
      principals {
        type        = "AWS"
        identifiers = ["*"]
      }
      actions = ["s3:*"]
      resources = [
        aws_s3_bucket.this.arn,
        "${aws_s3_bucket.this.arn}/*"
      ]
      condition {
        test     = "Bool"
        variable = "aws:SecureTransport"
        values   = ["false"]
      }
    }
  }
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.this.json
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
