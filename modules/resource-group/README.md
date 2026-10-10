# resource-group

This module creates following resources.

- `aws_resourcegroups_group`

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.12 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.12 |
| <a name="requirement_telemetry"></a> [telemetry](#requirement\_telemetry) | >= 0.2.0 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 6.12 |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [aws_resourcegroups_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/resourcegroups_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_name"></a> [name](#input\_name) | (Required) A name to identify the resource group. A resource group name can have a maximum of 127 characters, including letters, numbers, hyphens, dots, and underscores. The name cannot start with `AWS` or `aws`. | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | (Optional) The description of the resource group. | `string` | `"Managed by Terraform."` | no |
| <a name="input_module_tags_enabled"></a> [module\_tags\_enabled](#input\_module\_tags\_enabled) | (Optional) Whether to create AWS Resource Tags for the module informations. | `bool` | `true` | no |
| <a name="input_query"></a> [query](#input\_query) | (Optional) A configuration for the actual query used to match against resources. It supports `resource_types` and `resource_tags`. `query` block as defined below.<br/>    (Optional) `resource_tags` - A map of key/value pairs that are compared to the tags attached to resources.<br/>    (Optional) `resource_types` - A list of resource-type specification strings with `AWS::service-id::resource-type` format. Limit the results to only those resource types that match the filter. Specify `AWS::AllSupported` to include resources of any resources that are currently supported by Resource Group. | <pre>object({<br/>    resource_tags  = optional(map(string), {})<br/>    resource_types = optional(list(string), ["AWS::AllSupported"])<br/>  })</pre> | `{}` | no |
| <a name="input_region"></a> [region](#input\_region) | (Optional) The region in which to create the resource group. If not provided, the resource group will be created in the provider's configured region. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A map of tags to add to all resources. | `map(string)` | `{}` | no |
| <a name="input_telemetry"></a> [telemetry](#input\_telemetry) | (Optional) A configuration to collect telemetry data for the module. This is used to improve the module and its features. To send pseudonyms instead of identifying values such as the hostname and the Git remote, set `pseudonymization_enabled` to `true`. Pseudonyms are not anonymous; to keep data from being sent, disable its collector. The default configuration enables telemetry collection for machine, network, git, github, github actions, HCP Terraform, terraform, and toolchain. You can disable telemetry collection by setting `enabled` to `false`. `telemetry` block as defined below.<br/>    (Optional) `enabled` - Whether to enable telemetry collection. Default is `true`.<br/>    (Optional) `capture_machine` - Whether to capture machine information. Default is `true`.<br/>    (Optional) `capture_network` - Whether to capture network information. Default is `true`.<br/>    (Optional) `capture_git` - Whether to capture git information. Default is `true`.<br/>    (Optional) `capture_github` - Whether to capture GitHub information. Default is `true`.<br/>    (Optional) `capture_github_actions` - Whether to capture GitHub Actions information. Default is `true`.<br/>    (Optional) `capture_hcp_terraform` - Whether to capture HCP Terraform information. Default is `true`.<br/>    (Optional) `capture_terraform` - Whether to capture Terraform information. Default is `true`.<br/>    (Optional) `capture_toolchain` - Whether to capture toolchain information. Default is `true`.<br/>    (Optional) `pseudonymization_enabled` - Whether to enable pseudonymization of the captured data. Default is `false`. | <pre>object({<br/>    enabled = optional(bool, true)<br/><br/>    capture_machine        = optional(bool, true)<br/>    capture_network        = optional(bool, true)<br/>    capture_git            = optional(bool, true)<br/>    capture_github         = optional(bool, true)<br/>    capture_github_actions = optional(bool, true)<br/>    capture_hcp_terraform  = optional(bool, true)<br/>    capture_terraform      = optional(bool, true)<br/>    capture_toolchain      = optional(bool, true)<br/><br/>    pseudonymization_enabled = optional(bool, false)<br/>  })</pre> | `{}` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_arn"></a> [arn](#output\_arn) | The ARN of the resource group. |
| <a name="output_description"></a> [description](#output\_description) | The description of the resource group. |
| <a name="output_id"></a> [id](#output\_id) | The ID of the resource group. |
| <a name="output_name"></a> [name](#output\_name) | The name of the resource group. |
| <a name="output_region"></a> [region](#output\_region) | The region in which the resource group is created. |
| <a name="output_resource_tags"></a> [resource\_tags](#output\_resource\_tags) | The resource tags used by the resource group to query resources. |
| <a name="output_resource_types"></a> [resource\_types](#output\_resource\_types) | The resource types used by the resource group to query resources. |
<!-- END_TF_DOCS -->
