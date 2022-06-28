data "aws_elb_service_account" "this" {}

locals {
  default_prefixes = ["/"]

  ## CloudTrail
  cloudtrail_key_prefixes = [
    for prefix in coalescelist(var.delivery_cloudtrail_key_prefixes, local.default_prefixes) :
    trim(prefix, "/")
  ]
  cloudtrail_resources = [
    for prefix in local.cloudtrail_key_prefixes :
    prefix != ""
    ? "${aws_s3_bucket.this.arn}/${prefix}/AWSLogs/*/CloudTrail*"
    : "${aws_s3_bucket.this.arn}/AWSLogs/*/CloudTrail*"
  ]

  ## Config
  config_key_prefixes = [
    for prefix in coalescelist(var.delivery_config_key_prefixes, local.default_prefixes) :
    trim(prefix, "/")
  ]
  config_resources = [
    for prefix in local.config_key_prefixes :
    prefix != ""
    ? "${aws_s3_bucket.this.arn}/${prefix}/AWSLogs/*/Config/*"
    : "${aws_s3_bucket.this.arn}/AWSLogs/*/Config/*"
  ]

  ## ELB
  elb_key_prefixes = [
    for prefix in coalescelist(var.delivery_elb_key_prefixes, local.default_prefixes) :
    trim(prefix, "/")
  ]
  elb_resources = [
    for prefix in local.elb_key_prefixes :
    prefix != ""
    ? "${aws_s3_bucket.this.arn}/${prefix}/AWSLogs/*"
    : "${aws_s3_bucket.this.arn}/AWSLogs/*"
  ]
}

## Enforce TLS (HTTPS Only)
data "aws_iam_policy_document" "tls_required" {
  statement {
    sid = "RequireTlsForRequest"

    effect  = "Deny"
    actions = ["s3:*"]
    resources = [
      aws_s3_bucket.this.arn,
      "${aws_s3_bucket.this.arn}/*"
    ]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}

data "aws_iam_policy_document" "cloudtrail" {
  statement {
    sid = "AWSCloudTrailBucketPermissionsCheck"

    effect = "Allow"
    actions = [
      "s3:GetBucketAcl",
    ]
    resources = [
      aws_s3_bucket.this.arn,
    ]

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
  }
  statement {
    sid = "AWSCloudTrailBucketDelivery"

    effect = "Allow"
    actions = [
      "s3:PutObject",
    ]
    resources = local.cloudtrail_resources

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }
}

data "aws_iam_policy_document" "config" {
  statement {
    sid = "AWSConfigBucketExistenceAndPermissionsCheck"

    effect = "Allow"
    actions = [
      "s3:GetBucketAcl",
      "s3:ListBucket",
    ]
    resources = [
      aws_s3_bucket.this.arn,
    ]

    principals {
      type        = "Service"
      identifiers = ["config.amazonaws.com"]
    }
  }
  statement {
    sid = "AWSConfigBucketDelivery"

    effect = "Allow"
    actions = [
      "s3:PutObject",
    ]
    resources = local.config_resources

    principals {
      type        = "Service"
      identifiers = ["config.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }
}

data "aws_iam_policy_document" "elb" {
  statement {
    sid = "AWSLoadBalancerBucketPermissionsCheck"

    effect = "Allow"
    actions = [
      "s3:GetBucketAcl",
    ]
    resources = [
      aws_s3_bucket.this.arn,
    ]

    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
  }
  statement {
    sid = "AWSLoadBalancerBucketDelivery"

    effect = "Allow"
    actions = [
      "s3:PutObject",
    ]
    resources = local.elb_resources

    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }
  statement {
    sid = "AWSLoadBalancerBucketDeliveryByServiceAccount"

    effect = "Allow"
    actions = [
      "s3:PutObject",
    ]
    resources = local.elb_resources

    principals {
      type        = "AWS"
      identifiers = [data.aws_elb_service_account.this.arn]
    }
  }
}
