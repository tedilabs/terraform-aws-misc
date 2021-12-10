# s3-archive-bucket

This module creates following resources.

- `aws_s3_bucket`
- `aws_s3_bucket_policy`
- `aws_s3_bucket_ownership_controls`
- `aws_s3_bucket_public_access_block` (optional)

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.15 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.45 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.69.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_resourcegroups_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/resourcegroups_group) | resource |
| [aws_s3_bucket.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_ownership_controls.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_ownership_controls) | resource |
| [aws_s3_bucket_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_caller_identity.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_canonical_user_id.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/canonical_user_id) | data source |
| [aws_elb_service_account.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/elb_service_account) | data source |
| [aws_iam_policy_document.cloudtrail](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.config](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.elb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.tls_required](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | Desired name for the S3 bucket. | `string` | n/a | yes |
| <a name="input_delivery_cloudfront_enabled"></a> [delivery\_cloudfront\_enabled](#input\_delivery\_cloudfront\_enabled) | Allow CloudFront service to export logs to bucket. | `bool` | `false` | no |
| <a name="input_delivery_cloudtrail_enabled"></a> [delivery\_cloudtrail\_enabled](#input\_delivery\_cloudtrail\_enabled) | Allow CloudTrail service to export logs to bucket. | `bool` | `false` | no |
| <a name="input_delivery_cloudtrail_key_prefixes"></a> [delivery\_cloudtrail\_key\_prefixes](#input\_delivery\_cloudtrail\_key\_prefixes) | List of the S3 key prefixes that follows the name of the bucket you have allowed for CloudTrail log file delivery. | `list(string)` | `[]` | no |
| <a name="input_delivery_config_enabled"></a> [delivery\_config\_enabled](#input\_delivery\_config\_enabled) | Allow Config service to delivery to bucket. | `bool` | `false` | no |
| <a name="input_delivery_config_key_prefixes"></a> [delivery\_config\_key\_prefixes](#input\_delivery\_config\_key\_prefixes) | List of the S3 key prefixes that follows the name of the bucket you have allowed for Config. | `list(string)` | `[]` | no |
| <a name="input_delivery_elb_enabled"></a> [delivery\_elb\_enabled](#input\_delivery\_elb\_enabled) | Allow ELB(Elastic Load Balancer) service to export logs to bucket. | `bool` | `false` | no |
| <a name="input_delivery_elb_key_prefixes"></a> [delivery\_elb\_key\_prefixes](#input\_delivery\_elb\_key\_prefixes) | List of the S3 key prefixes that follows the name of the bucket you have allowed for ELB(Elastic Load Balancer) log file delivery. | `list(string)` | `[]` | no |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | A bool that indicates all objects (including any locked objects) should be deleted from the bucket so the bucket can be destroyed without error. | `bool` | `false` | no |
| <a name="input_grants"></a> [grants](#input\_grants) | A list of the ACL policy grant. Conflicts with acl. Valid values for `grant.type` are `CanonicalUser` and `Group`. `AmazonCustomerByEmail` is not supported. Valid values for `grant.permissions` are `READ`, `WRITE`, `READ_ACP`, `WRITE_ACP`, `FULL_CONTROL`. | `list(any)` | `[]` | no |
| <a name="input_lifecycle_rules"></a> [lifecycle\_rules](#input\_lifecycle\_rules) | Use lifecycle rules to define actions you want Amazon S3 to take during an object's lifetime such as transitioning objects to another storage class, archiving them, or deleting them after a specified period of time. | `list(map(any))` | `[]` | no |
| <a name="input_logging_s3_bucket"></a> [logging\_s3\_bucket](#input\_logging\_s3\_bucket) | The name of the bucket that will receive the log objects. | `string` | `null` | no |
| <a name="input_logging_s3_key_prefix"></a> [logging\_s3\_key\_prefix](#input\_logging\_s3\_key\_prefix) | To specify a key prefix of log objects. | `string` | `null` | no |
| <a name="input_mfa_delete_enabled"></a> [mfa\_delete\_enabled](#input\_mfa\_delete\_enabled) | Enable MFA delete for either `Change the versioning state of your bucket` or `Permanently delete an object version`. Default is `false`. | `bool` | `false` | no |
| <a name="input_module_tags_enabled"></a> [module\_tags\_enabled](#input\_module\_tags\_enabled) | Whether to create AWS Resource Tags for the module informations. | `bool` | `true` | no |
| <a name="input_object_ownership"></a> [object\_ownership](#input\_object\_ownership) | Control ownership of objects written to this bucket from other AWS accounts and granted using access control lists (ACLs). Object ownership determines who can specify access to objects. Valid values: `BucketOwnerPreferred` or `ObjectWriter`. | `string` | `"BucketOwnerPreferred"` | no |
| <a name="input_public_access_block_enabled"></a> [public\_access\_block\_enabled](#input\_public\_access\_block\_enabled) | Enable S3 bucket-level Public Access Block configuration. | `bool` | `false` | no |
| <a name="input_resource_group_description"></a> [resource\_group\_description](#input\_resource\_group\_description) | The description of Resource Group. | `string` | `"Managed by Terraform."` | no |
| <a name="input_resource_group_enabled"></a> [resource\_group\_enabled](#input\_resource\_group\_enabled) | Whether to create Resource Group to find and group AWS resources which are created by this module. | `bool` | `true` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of Resource Group. A Resource Group name can have a maximum of 127 characters, including letters, numbers, hyphens, dots, and underscores. The name cannot start with `AWS` or `aws`. | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources. | `map(string)` | `{}` | no |
| <a name="input_tls_required"></a> [tls\_required](#input\_tls\_required) | Deny any access to the S3 bucket that is not encrypted in-transit if true. | `bool` | `true` | no |
| <a name="input_transfer_acceleration_enabled"></a> [transfer\_acceleration\_enabled](#input\_transfer\_acceleration\_enabled) | Use an accelerated endpoint for faster data transfers. | `bool` | `false` | no |
| <a name="input_versioning_enabled"></a> [versioning\_enabled](#input\_versioning\_enabled) | Enable versioning. Once you version-enable a bucket, it can never return to an unversioned state. You can, however, suspend versioning on that bucket. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | The ARN of the bucket. |
| <a name="output_domain_name"></a> [domain\_name](#output\_domain\_name) | The bucket domain name. Will be of format `bucketname.s3.amazonaws.com`. |
| <a name="output_hosted_zone_id"></a> [hosted\_zone\_id](#output\_hosted\_zone\_id) | The Route 53 Hosted Zone ID for this bucket's region. |
| <a name="output_id"></a> [id](#output\_id) | The ID of the bucket. |
| <a name="output_logging"></a> [logging](#output\_logging) | The logging configuration for access to the bucket. |
| <a name="output_name"></a> [name](#output\_name) | The name of the bucket. |
| <a name="output_object_ownership"></a> [object\_ownership](#output\_object\_ownership) | The ownership of objects written to the bucket from other AWS accounts and granted using access control lists(ACLs). |
| <a name="output_public_access_block_enabled"></a> [public\_access\_block\_enabled](#output\_public\_access\_block\_enabled) | Whether S3 bucket-level Public Access Block is enabled. |
| <a name="output_region"></a> [region](#output\_region) | The AWS region this bucket resides in. |
| <a name="output_regional_domain_name"></a> [regional\_domain\_name](#output\_regional\_domain\_name) | The bucket region-specific domain name. The bucket domain name including the region name. |
| <a name="output_transfer_acceleration_enabled"></a> [transfer\_acceleration\_enabled](#output\_transfer\_acceleration\_enabled) | Whether S3 Transfer Acceleration is enabled. |
| <a name="output_versioning"></a> [versioning](#output\_versioning) | The versioning configuration for the bucket. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->