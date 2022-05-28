# resource-group

This module creates following resources.

- `aws_resourcegroups_group`

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.14 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.16.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_resourcegroups_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/resourcegroups_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | (Required) A name to identify the resource group. A resource group name can have a maximum of 127 characters, including letters, numbers, hyphens, dots, and underscores. The name cannot start with `AWS` or `aws`. | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | (Optional) The description of the resource group. | `string` | `"Managed by Terraform."` | no |
| <a name="input_module_tags_enabled"></a> [module\_tags\_enabled](#input\_module\_tags\_enabled) | (Optional) Whether to create AWS Resource Tags for the module informations. | `bool` | `true` | no |
| <a name="input_query"></a> [query](#input\_query) | (Optional) A configuration for the actual query used to match against resources. It supports `resource_types` and `resource_tags`. `query` block as defined below.<br>    (Required) `resource_tags` - A map of key/value pairs that are compared to the tags attached to resources.<br>    (Optional) `resource_types` - A list of resource-type specification strings with `AWS::service-id::resource-type` format. Limit the results to only those resource types that match the filter. Specify `AWS::AllSupported` to include resources of any resources that are currently supported by Resource Group. | `any` | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A map of tags to add to all resources. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | The ARN of the resource group. |
| <a name="output_description"></a> [description](#output\_description) | The description of the resource group. |
| <a name="output_name"></a> [name](#output\_name) | The name of the resource group. |
| <a name="output_resource_tags"></a> [resource\_tags](#output\_resource\_tags) | The resource tags used by the resource group to query resources. |
| <a name="output_resource_types"></a> [resource\_types](#output\_resource\_types) | The resource types used by the resource group to query resources. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
