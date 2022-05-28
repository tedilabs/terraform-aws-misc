###################################################
# Request Payment for S3 Bucket
###################################################

# TODO: `expected_bucket_owner`
resource "aws_s3_bucket_request_payment_configuration" "this" {
  bucket = aws_s3_bucket.this.bucket
  payer  = "BucketOwner"
}
