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

output "resource_group" {
  description = "The resource group created to manage resources in this module."
  value = merge(
    {
      enabled = var.resource_group.enabled && var.module_tags_enabled
    },
    (var.resource_group.enabled && var.module_tags_enabled
      ? {
        arn  = module.resource_group[0].arn
        name = module.resource_group[0].name
      }
      : {}
    )
  )
}
