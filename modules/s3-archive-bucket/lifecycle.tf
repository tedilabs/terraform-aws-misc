locals {
  versioning_mfa_status = {
    "ENABLED"   = "Enabled"
    "DISABLED"  = "Disabled"
    "SUSPENDED" = "Suspended"
  }

  lifecycle_rules = {
    for rule in var.lifecycle_rules :
    rule.id => rule
  }
}


###################################################
# Versioning for S3 Bucket
###################################################

# TODO: `expected_bucket_owner`
resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.bucket

  mfa = try(var.versioning_mfa_deletion.device, null)

  versioning_configuration {
    status     = local.versioning_mfa_status[var.versioning_status]
    mfa_delete = try(var.versioning_mfa_deletion.enabled, false) ? "Enabled" : "Disabled"
  }
}


###################################################
# Lifecycle Rules for S3 Bucket
###################################################

# TODO: `expected_bucket_owner`
resource "aws_s3_bucket_lifecycle_configuration" "this" {
  bucket = aws_s3_bucket.this.bucket

  dynamic "rule" {
    for_each = var.lifecycle_rules

    content {
      id     = rule.value.id
      status = try(rule.value.enabled, true) ? "Enabled" : "Disabled"

      dynamic "abort_incomplete_multipart_upload" {
        for_each = try([rule.value.days_to_abort_incomplete_multipart_upload], [])

        content {
          days_after_initiation = abort_incomplete_multipart_upload.value
        }
      }

      ## Single Filter
      dynamic "filter" {
        for_each = sum([
          try(rule.value.prefix != null ? 1 : 0, 0),
          try(rule.value.min_object_size != null ? 1 : 0, 0),
          try(rule.value.max_object_size != null ? 1 : 0, 0),
        ]) == 1 ? ["go"] : []

        content {
          prefix = try(rule.value.prefix, null)

          object_size_greater_than = try(rule.value.min_object_size, null)
          object_size_less_than    = try(rule.value.max_object_size, null)
        }
      }

      ## Multi Filter
      dynamic "filter" {
        for_each = sum([
          try(rule.value.prefix != null ? 1 : 0, 0),
          try(rule.value.tags != null ? 2 : 0, 0),
          try(rule.value.min_object_size != null ? 1 : 0, 0),
          try(rule.value.max_object_size != null ? 1 : 0, 0),
        ]) > 1 ? ["go"] : []

        content {
          and {
            prefix = try(rule.value.prefix, null)
            tags   = try(rule.value.tags, null)

            object_size_greater_than = try(rule.value.min_object_size, null)
            object_size_less_than    = try(rule.value.max_object_size, null)
          }
        }
      }

      dynamic "expiration" {
        for_each = try([rule.value.expiration], [])

        content {
          date = try(expiration.value.date, null)
          days = try(expiration.value.days, 0)

          expired_object_delete_marker = try(expiration.value.expired_object_delete_marker, false)
        }
      }

      dynamic "noncurrent_version_expiration" {
        for_each = try([rule.value.noncurrent_version_expiration], [])

        content {
          noncurrent_days           = try(noncurrent_version_expiration.value.days, null)
          newer_noncurrent_versions = try(noncurrent_version_expiration.value.count, null)
        }
      }

      dynamic "transition" {
        for_each = try(rule.value.transitions, [])

        content {
          date = try(transition.value.date, null)
          days = try(transition.value.days, null)

          storage_class = transition.value.storage_class
        }
      }

      dynamic "noncurrent_version_transition" {
        for_each = try(rule.value.noncurrent_version_transitions, [])

        content {
          noncurrent_days           = try(noncurrent_version_transition.value.days, null)
          newer_noncurrent_versions = try(noncurrent_version_transition.value.count, null)

          storage_class = noncurrent_version_transition.value.storage_class
        }
      }
    }
  }

  depends_on = [
    aws_s3_bucket_versioning.this,
  ]
}
