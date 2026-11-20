output "table" {
  description = "The DynamoDB table."
  value = {
    name           = aws_dynamodb_table.this.name
    arn            = aws_dynamodb_table.this.arn
    read_capacity  = aws_dynamodb_table.this.read_capacity
    write_capacity = aws_dynamodb_table.this.write_capacity
  }
}

output "scalable_targets" {
  description = "The scalable targets for the read and write capacity of the DynamoDB table."
  value       = module.scalable_target
}
