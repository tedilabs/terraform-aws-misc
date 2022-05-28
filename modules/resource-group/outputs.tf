output "arn" {
  description = "The ARN of the resource group."
  value       = aws_resourcegroups_group.this.arn
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
  value       = try(var.query.resource_types, ["AWS::AllSupported"])
}

output "resource_tags" {
  description = "The resource tags used by the resource group to query resources."
  value       = try(var.query.resource_tags, {})
}
