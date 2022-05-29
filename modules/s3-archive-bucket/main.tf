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


###################################################
# S3 Bucket for archive
###################################################

# TODO: object_lock_configuration
resource "aws_s3_bucket" "this" {
  bucket        = var.name
  force_destroy = var.force_destroy

  tags = merge(
    {
      "Name" = local.metadata.name
    },
    local.module_tags,
    var.tags,
  )

  lifecycle {
    ignore_changes = [
      lifecycle_rule,
    ]
  }
}


###################################################
# Server Side Encryption for S3 Bucket
###################################################

locals {
  sse_algorithm = {
    "AES256"  = "AES256"
    "AWS_KMS" = "aws:kms"
  }
}

# TODO: `expected_bucket_owner`
# TODO: `bucket_key_enabled`
# TODO: `rule.apply_server_side_encryption_by_default.kms_master_key_id`
resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = local.sse_algorithm["AES256"]
    }
  }
}
