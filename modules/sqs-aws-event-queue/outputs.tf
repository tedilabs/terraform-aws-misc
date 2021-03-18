output "name" {
  description = "The name of the SQS queue."
  value       = aws_sqs_queue.this.name
}

output "id" {
  description = "The URL for the created Amazon SQS queue."
  value       = aws_sqs_queue.this.id
}

output "arn" {
  description = "The ARN of the SQS queue."
  value       = aws_sqs_queue.this.arn
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
