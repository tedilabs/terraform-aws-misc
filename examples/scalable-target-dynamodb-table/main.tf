provider "aws" {
  region = "us-east-1"
}

locals {
  dimensions = {
    "read" = {
      scalable_dimension = "dynamodb:table:ReadCapacityUnits"
      metric             = "DynamoDBReadCapacityUtilization"
      min_capacity       = 5
      max_capacity       = 100
    }
    "write" = {
      scalable_dimension = "dynamodb:table:WriteCapacityUnits"
      metric             = "DynamoDBWriteCapacityUtilization"
      min_capacity       = 5
      max_capacity       = 50
    }
  }
}


###################################################
# DynamoDB Table
###################################################

resource "aws_dynamodb_table" "this" {
  name         = "scalable-target-example"
  billing_mode = "PROVISIONED"
  hash_key     = "id"

  read_capacity  = 5
  write_capacity = 5

  attribute {
    name = "id"
    type = "S"
  }

  tags = {
    "project" = "terraform-aws-misc-examples"
  }

  lifecycle {
    # Application Auto Scaling changes the capacity outside Terraform.
    ignore_changes = [read_capacity, write_capacity]
  }
}


###################################################
# Scalable Targets
###################################################

module "scalable_target" {
  source = "../../modules/scalable-target"
  # source  = "tedilabs/misc/aws//modules/scalable-target"
  # version = "~> 0.14.0"

  for_each = local.dimensions

  name = "${aws_dynamodb_table.this.name}-${each.key}"

  service_namespace  = "dynamodb"
  resource_id        = "table/${aws_dynamodb_table.this.name}"
  scalable_dimension = each.value.scalable_dimension

  min_capacity = each.value.min_capacity
  max_capacity = each.value.max_capacity

  target_tracking_policies = [
    {
      name         = "${aws_dynamodb_table.this.name}-${each.key}-utilization"
      target_value = 70
      predefined_metric = {
        type = each.value.metric
      }
    },
  ]

  scheduled_actions = [
    {
      name         = "${aws_dynamodb_table.this.name}-${each.key}-business-hours"
      schedule     = "cron(0 9 ? * MON-FRI *)"
      timezone     = "Asia/Seoul"
      min_capacity = each.value.min_capacity * 4
    },
    {
      name         = "${aws_dynamodb_table.this.name}-${each.key}-off-hours"
      schedule     = "cron(0 20 ? * MON-FRI *)"
      timezone     = "Asia/Seoul"
      min_capacity = each.value.min_capacity
    },
  ]

  tags = {
    "project" = "terraform-aws-misc-examples"
  }
}
