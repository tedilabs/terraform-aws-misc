output "name" {
  description = "The name of the bucket."
  value       = aws_s3_bucket.this.bucket
}

output "id" {
  description = "The ID of the bucket."
  value       = aws_s3_bucket.this.id
}

output "arn" {
  description = "The ARN of the bucket."
  value       = aws_s3_bucket.this.arn
}

output "region" {
  description = "The AWS region this bucket resides in."
  value       = aws_s3_bucket.this.region
}

output "hosted_zone_id" {
  description = "The Route 53 Hosted Zone ID for this bucket's region."
  value       = aws_s3_bucket.this.hosted_zone_id
}
output "domain_name" {
  description = "The bucket domain name. Will be of format `bucketname.s3.amazonaws.com`."
  value       = aws_s3_bucket.this.bucket_domain_name
}

output "regional_domain_name" {
  description = "The bucket region-specific domain name. The bucket domain name including the region name."
  value       = aws_s3_bucket.this.bucket_regional_domain_name
}

output "transfer_acceleration_enabled" {
  description = "Whether S3 Transfer Acceleration is enabled."
  value       = var.transfer_acceleration_enabled
}

output "versioning" {
  description = "The versioning configuration for the bucket."
  value = {
    enabled            = var.versioning_enabled
    mfa_delete_enabled = var.mfa_delete_enabled
  }
}

output "object_ownership" {
  description = "The ownership of objects written to the bucket from other AWS accounts and granted using access control lists(ACLs)."
  value       = aws_s3_bucket_ownership_controls.this.rule[0].object_ownership
}

output "public_access_block_enabled" {
  description = "Whether S3 bucket-level Public Access Block is enabled."
  value       = var.public_access_block_enabled
}

output "logging" {
  description = "The logging configuration for access to the bucket."
  value = {
    s3 = {
      bucket     = var.logging_s3_bucket
      key_prefix = var.logging_s3_key_prefix
    }
  }
}