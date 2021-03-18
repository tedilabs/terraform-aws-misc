output "name" {
  description = "The name of the bucket."
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

output "policy" {
  description = "The text of the policy."
  value       = aws_s3_bucket_policy.this.policy
}


###################################################
# Resource Group
###################################################

output "resource_group_enabled" {
  description = "Whether Resource Group is enabled."
  value       = var.resource_group_enabled
}

output "resource_group_name" {
  description = "The name of Resource Group."
  value       = try(aws_resourcegroups_group.this.*.name[0], null)
}
