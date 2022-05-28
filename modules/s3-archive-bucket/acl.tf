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
