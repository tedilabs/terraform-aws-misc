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
