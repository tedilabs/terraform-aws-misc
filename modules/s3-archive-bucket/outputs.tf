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

output "transfer_acceleration" {
  description = "The configuration for the S3 Transfer Acceleration of the bucket."
  value = {
    enabled = var.transfer_acceleration_enabled
  }
}

output "versioning" {
  description = "The versioning configuration for the bucket."
  value = {
    status       = var.versioning_status
    mfa_deletion = var.versioning_mfa_deletion
  }
}

output "lifecycle_rules" {
  description = "The lifecycle configuration for the bucket."
  value = {
    for rule in try(aws_s3_bucket_lifecycle_configuration.this[0].rule, []) :
    rule.id => {
      id      = rule.id
      enabled = rule.status == "Enabled"

      filter = {
        prefix          = try(local.lifecycle_rules[rule.id].prefix, null)
        tags            = try(local.lifecycle_rules[rule.id].tags, {})
        min_object_size = try(local.lifecycle_rules[rule.id].min_object_size, null)
        max_object_size = try(local.lifecycle_rules[rule.id].max_object_size, null)
      }
    }
  }
}

output "server_side_encryption" {
  description = "The configuration for the S3 bucket server-side encryption."
  value = {
    enabled   = true
    algorithm = "AES256"
  }
}

output "request_payment" {
  description = "The configuration for the S3 bucket request payment."
  value = {
    payer = aws_s3_bucket_request_payment_configuration.this.payer
  }
}

output "access_control" {
  description = "The configuration for the S3 bucket access control."
  value = {
    object_ownership = aws_s3_bucket_ownership_controls.this.rule[0].object_ownership
    acl = {
      enabled = aws_s3_bucket_ownership_controls.this.rule[0].object_ownership != "BucketOwnerEnforced"
      grants  = local.grants
    }
    public_access = {
      enabled = var.public_access_enabled
    }
  }
}

output "logging" {
  description = "The logging configuration for the bucket."
  value = {
    enabled = var.logging_enabled
    s3 = {
      bucket     = var.logging_s3_bucket
      key_prefix = var.logging_s3_key_prefix
    }
  }
}
