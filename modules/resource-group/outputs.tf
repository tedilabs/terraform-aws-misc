output "region" {
  description = "The region in which the resource group is created."
  value       = aws_resourcegroups_group.this.region
}

output "arn" {
  description = "The ARN of the resource group."
  value       = aws_resourcegroups_group.this.arn
}

output "id" {
  description = "The ID of the resource group."
  value       = aws_resourcegroups_group.this.id
}

output "name" {
  description = "The name of the resource group."
  value       = aws_resourcegroups_group.this.name
}

output "description" {
  description = "The description of the resource group."
  value       = aws_resourcegroups_group.this.description
}

output "resource_types" {
  description = "The resource types used by the resource group to query resources."
  value       = var.query.resource_types
}

output "resource_tags" {
  description = "The resource tags used by the resource group to query resources."
  value       = var.query.resource_tags
}

# output "debug" {
#   value = {
#     for k, v in aws_resourcegroups_group.this :
#     k => v
#     if !contains(["tags_all", "tags", "region", "arn", "id", "name", "description", "resource_query", "timeouts"], k)
#   }
# }
