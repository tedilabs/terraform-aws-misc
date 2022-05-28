locals {
  mfa_status = {
    "ENABLED"   = "Enabled"
    "DISABLED"  = "Disabled"
    "SUSPENDED" = "Suspended"
  }
}


###################################################
# Versioning for S3 Bucket
###################################################

# TODO: `expected_bucket_owner`
resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id

  mfa = try(var.versioning_mfa_deletion.device, null)

  versioning_configuration {
    status     = local.mfa_status[var.versioning_status]
    mfa_delete = try(var.versioning_mfa_deletion.enabled, false) ? "Enabled" : "Disabled"
  }
}
