variable "region" {
  description = "(Optional) The region in which to create the resource group. If not provided, the resource group will be created in the provider's configured region."
  type        = string
  default     = null
  nullable    = true
}

variable "name" {
  description = "(Required) A name to identify the resource group. A resource group name can have a maximum of 127 characters, including letters, numbers, hyphens, dots, and underscores. The name cannot start with `AWS` or `aws`."
  type        = string
  nullable    = false
}

variable "description" {
  description = "(Optional) The description of the resource group."
  type        = string
  default     = "Managed by Terraform."
  nullable    = false
}

variable "query" {
  description = <<EOF
  (Optional) A configuration for the actual query used to match against resources. It supports `resource_types` and `resource_tags`. `query` block as defined below.
    (Optional) `resource_tags` - A map of key/value pairs that are compared to the tags attached to resources.
    (Optional) `resource_types` - A list of resource-type specification strings with `AWS::service-id::resource-type` format. Limit the results to only those resource types that match the filter. Specify `AWS::AllSupported` to include resources of any resources that are currently supported by Resource Group.
  EOF
  type = object({
    resource_tags  = optional(map(string), {})
    resource_types = optional(list(string), ["AWS::AllSupported"])
  })
  default  = {}
  nullable = false
}

variable "tags" {
  description = "(Optional) A map of tags to add to all resources."
  type        = map(string)
  default     = {}
  nullable    = false
}

variable "module_tags_enabled" {
  description = "(Optional) Whether to create AWS Resource Tags for the module informations."
  type        = bool
  default     = true
  nullable    = false
}
