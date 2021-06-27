# s3-log-bucket

This module creates following resources.

- `aws_s3_bucket`
- `aws_s3_bucket_policy`
- `aws_s3_bucket_public_access_block` (optional)

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.34 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.34.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_resourcegroups_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/resourcegroups_group) | resource |
| [aws_s3_bucket.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_caller_identity.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_canonical_user_id.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/canonical_user_id) | data source |
| [aws_cloudtrail_service_account.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/cloudtrail_service_account) | data source |
| [aws_elb_service_account.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/elb_service_account) | data source |
| [aws_iam_policy_document.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | Desired name for the S3 bucket. | `string` | n/a | yes |
| <a name="input_cloudfront_bucket_prefixes"></a> [cloudfront\_bucket\_prefixes](#input\_cloudfront\_bucket\_prefixes) | List of the S3 key prefixes that follows the name of the bucket you have allowed for CloudFront log file delivery. | `list(string)` | `[]` | no |
| <a name="input_cloudfront_enabled"></a> [cloudfront\_enabled](#input\_cloudfront\_enabled) | Allow CloudFront service to export logs to bucket. | `bool` | `false` | no |
| <a name="input_cloudfront_expiration_date"></a> [cloudfront\_expiration\_date](#input\_cloudfront\_expiration\_date) | Specifies the date after which you want the expiration action takes effect for CloudFront prefixes. | `string` | `null` | no |
| <a name="input_cloudfront_expiration_days"></a> [cloudfront\_expiration\_days](#input\_cloudfront\_expiration\_days) | Specifies the number of days after object creation when the expiration action takes effect for CloudFront prefixes. | `number` | `365` | no |
| <a name="input_cloudfront_expiration_enabled"></a> [cloudfront\_expiration\_enabled](#input\_cloudfront\_expiration\_enabled) | A bool that to enable the expiration lifecycle rule for CloudFront prefixes. | `bool` | `false` | no |
| <a name="input_cloudtrail_bucket_prefixes"></a> [cloudtrail\_bucket\_prefixes](#input\_cloudtrail\_bucket\_prefixes) | List of the S3 key prefixes that follows the name of the bucket you have allowed for CloudTrail log file delivery. | `list(string)` | `[]` | no |
| <a name="input_cloudtrail_enabled"></a> [cloudtrail\_enabled](#input\_cloudtrail\_enabled) | Allow CloudTrail service to export logs to bucket. | `bool` | `false` | no |
| <a name="input_cloudtrail_expiration_date"></a> [cloudtrail\_expiration\_date](#input\_cloudtrail\_expiration\_date) | Specifies the date after which you want the expiration action takes effect for CloudTrail prefixes. | `string` | `null` | no |
| <a name="input_cloudtrail_expiration_days"></a> [cloudtrail\_expiration\_days](#input\_cloudtrail\_expiration\_days) | Specifies the number of days after object creation when the expiration action takes effect for CloudTrail prefixes. | `number` | `365` | no |
| <a name="input_cloudtrail_expiration_enabled"></a> [cloudtrail\_expiration\_enabled](#input\_cloudtrail\_expiration\_enabled) | A bool that to enable the expiration lifecycle rule for CloudTrail prefixes. | `bool` | `false` | no |
| <a name="input_default_expiration_date"></a> [default\_expiration\_date](#input\_default\_expiration\_date) | Specifies the date after which you want the expiration action takes effect for this bucket. | `string` | `null` | no |
| <a name="input_default_expiration_days"></a> [default\_expiration\_days](#input\_default\_expiration\_days) | Specifies the number of days after object creation when the expiration action takes effect for this bucket. | `number` | `365` | no |
| <a name="input_default_expiration_enabled"></a> [default\_expiration\_enabled](#input\_default\_expiration\_enabled) | A bool that to enable the expiration lifecycle rule for this bucket. | `bool` | `false` | no |
| <a name="input_elb_bucket_prefixes"></a> [elb\_bucket\_prefixes](#input\_elb\_bucket\_prefixes) | List of the S3 key prefixes that follows the name of the bucket you have allowed for ELB(Elastic Load Balancer) log file delivery. | `list(string)` | `[]` | no |
| <a name="input_elb_enabled"></a> [elb\_enabled](#input\_elb\_enabled) | Allow ELB(Elastic Load Balancer) service to export logs to bucket. | `bool` | `false` | no |
| <a name="input_elb_expiration_date"></a> [elb\_expiration\_date](#input\_elb\_expiration\_date) | Specifies the date after which you want the expiration action takes effect for ELB(Elastic Load Balancer) prefixes. | `string` | `null` | no |
| <a name="input_elb_expiration_days"></a> [elb\_expiration\_days](#input\_elb\_expiration\_days) | Specifies the number of days after object creation when the expiration action takes effect for ELB(Elastic Load Balancer) prefixes. | `number` | `365` | no |
| <a name="input_elb_expiration_enabled"></a> [elb\_expiration\_enabled](#input\_elb\_expiration\_enabled) | A bool that to enable the expiration lifecycle rule for ELB(Elastic Load Balancer) prefixes. | `bool` | `false` | no |
| <a name="input_enforce_tls"></a> [enforce\_tls](#input\_enforce\_tls) | Deny any access to the S3 bucket that is not encrypted in-transit if true. | `bool` | `true` | no |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | A bool that indicates all objects (including any locked objects) should be deleted from the bucket so the bucket can be destroyed without error. | `bool` | `false` | no |
| <a name="input_grants"></a> [grants](#input\_grants) | A list of the ACL policy grant. Conflicts with acl. Valid values for `grant.type` are `CanonicalUser` and `Group`. `AmazonCustomerByEmail` is not supported. Valid values for `grant.permissions` are `READ`, `WRITE`, `READ_ACP`, `WRITE_ACP`, `FULL_CONTROL`. | `list(any)` | `[]` | no |
| <a name="input_module_tags_enabled"></a> [module\_tags\_enabled](#input\_module\_tags\_enabled) | Whether to create AWS Resource Tags for the module informations. | `bool` | `true` | no |
| <a name="input_public_access_block_enabled"></a> [public\_access\_block\_enabled](#input\_public\_access\_block\_enabled) | Enable S3 bucket-level Public Access Block configuration. | `bool` | `false` | no |
| <a name="input_resource_group_description"></a> [resource\_group\_description](#input\_resource\_group\_description) | The description of Resource Group. | `string` | `"Managed by Terraform."` | no |
| <a name="input_resource_group_enabled"></a> [resource\_group\_enabled](#input\_resource\_group\_enabled) | Whether to create Resource Group to find and group AWS resources which are created by this module. | `bool` | `true` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of Resource Group. A Resource Group name can have a maximum of 127 characters, including letters, numbers, hyphens, dots, and underscores. The name cannot start with `AWS` or `aws`. | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | The ARN of the bucket. |
| <a name="output_domain_name"></a> [domain\_name](#output\_domain\_name) | The bucket domain name. Will be of format `bucketname.s3.amazonaws.com`. |
| <a name="output_hosted_zone_id"></a> [hosted\_zone\_id](#output\_hosted\_zone\_id) | The Route 53 Hosted Zone ID for this bucket's region. |
| <a name="output_name"></a> [name](#output\_name) | The name of the bucket. |
| <a name="output_policy"></a> [policy](#output\_policy) | The text of the policy. |
| <a name="output_region"></a> [region](#output\_region) | The AWS region this bucket resides in. |
| <a name="output_regional_domain_name"></a> [regional\_domain\_name](#output\_regional\_domain\_name) | The bucket region-specific domain name. The bucket domain name including the region name. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
