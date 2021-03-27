# s3-log-bucket

This module creates following resources.

- `aws_s3_bucket`
- `aws_s3_bucket_policy`
- `aws_s3_bucket_public_access_block` (optional)

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13 |
| aws | >= 3.34 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 3.34 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | Desired name for the S3 bucket. | `string` | n/a | yes |
| cloudfront\_bucket\_prefixes | List of the S3 key prefixes that follows the name of the bucket you have allowed for CloudFront log file delivery. | `list(string)` | `[]` | no |
| cloudfront\_enabled | Allow CloudFront service to export logs to bucket. | `bool` | `false` | no |
| cloudfront\_expiration\_date | Specifies the date after which you want the expiration action takes effect for CloudFront prefixes. | `string` | `null` | no |
| cloudfront\_expiration\_days | Specifies the number of days after object creation when the expiration action takes effect for CloudFront prefixes. | `number` | `365` | no |
| cloudfront\_expiration\_enabled | A bool that to enable the expiration lifecycle rule for CloudFront prefixes. | `bool` | `false` | no |
| cloudtrail\_bucket\_prefixes | List of the S3 key prefixes that follows the name of the bucket you have allowed for CloudTrail log file delivery. | `list(string)` | `[]` | no |
| cloudtrail\_enabled | Allow CloudTrail service to export logs to bucket. | `bool` | `false` | no |
| cloudtrail\_expiration\_date | Specifies the date after which you want the expiration action takes effect for CloudTrail prefixes. | `string` | `null` | no |
| cloudtrail\_expiration\_days | Specifies the number of days after object creation when the expiration action takes effect for CloudTrail prefixes. | `number` | `365` | no |
| cloudtrail\_expiration\_enabled | A bool that to enable the expiration lifecycle rule for CloudTrail prefixes. | `bool` | `false` | no |
| default\_expiration\_date | Specifies the date after which you want the expiration action takes effect for this bucket. | `string` | `null` | no |
| default\_expiration\_days | Specifies the number of days after object creation when the expiration action takes effect for this bucket. | `number` | `365` | no |
| default\_expiration\_enabled | A bool that to enable the expiration lifecycle rule for this bucket. | `bool` | `false` | no |
| elb\_bucket\_prefixes | List of the S3 key prefixes that follows the name of the bucket you have allowed for ELB(Elastic Load Balancer) log file delivery. | `list(string)` | `[]` | no |
| elb\_enabled | Allow ELB(Elastic Load Balancer) service to export logs to bucket. | `bool` | `false` | no |
| elb\_expiration\_date | Specifies the date after which you want the expiration action takes effect for ELB(Elastic Load Balancer) prefixes. | `string` | `null` | no |
| elb\_expiration\_days | Specifies the number of days after object creation when the expiration action takes effect for ELB(Elastic Load Balancer) prefixes. | `number` | `365` | no |
| elb\_expiration\_enabled | A bool that to enable the expiration lifecycle rule for ELB(Elastic Load Balancer) prefixes. | `bool` | `false` | no |
| enforce\_tls | Deny any access to the S3 bucket that is not encrypted in-transit if true. | `bool` | `true` | no |
| force\_destroy | A bool that indicates all objects (including any locked objects) should be deleted from the bucket so the bucket can be destroyed without error. | `bool` | `false` | no |
| grants | A list of the ACL policy grant. Conflicts with acl. Valid values for `grant.type` are `CanonicalUser` and `Group`. `AmazonCustomerByEmail` is not supported. Valid values for `grant.permissions` are `READ`, `WRITE`, `READ_ACP`, `WRITE_ACP`, `FULL_CONTROL`. | `list(any)` | `[]` | no |
| module\_tags\_enabled | Whether to create AWS Resource Tags for the module informations. | `bool` | `true` | no |
| public\_access\_block\_enabled | Enable S3 bucket-level Public Access Block configuration. | `bool` | `false` | no |
| resource\_group\_description | The description of Resource Group. | `string` | `"Managed by Terraform."` | no |
| resource\_group\_enabled | Whether to create Resource Group to find and group AWS resources which are created by this module. | `bool` | `true` | no |
| resource\_group\_name | The name of Resource Group. A Resource Group name can have a maximum of 127 characters, including letters, numbers, hyphens, dots, and underscores. The name cannot start with `AWS` or `aws`. | `string` | `""` | no |
| tags | A map of tags to add to all resources. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| arn | The ARN of the bucket. |
| domain\_name | The bucket domain name. Will be of format `bucketname.s3.amazonaws.com`. |
| hosted\_zone\_id | The Route 53 Hosted Zone ID for this bucket's region. |
| name | The name of the bucket. |
| policy | The text of the policy. |
| region | The AWS region this bucket resides in. |
| regional\_domain\_name | The bucket region-specific domain name. The bucket domain name including the region name. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
