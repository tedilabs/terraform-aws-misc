###################################################
# SQS Standard Queue
###################################################

resource "aws_sqs_queue" "this" {
  name = var.name

  fifo_queue = false

  visibility_timeout_seconds = var.visibility_timeout_seconds
  message_retention_seconds  = var.message_retention_seconds
  max_message_size           = var.max_message_size
  delay_seconds              = var.delay_seconds
  receive_wait_time_seconds  = var.receive_wait_time_seconds

  tags = merge(
    {
      "Name" = var.name
    },
    var.tags,
  )
}


###################################################
# IAM Policy for SQS Queue
###################################################

data "aws_iam_policy_document" "this" {
  statement {
    sid    = "send-message-source"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions   = ["sqs:SendMessage"]
    resources = [aws_sqs_queue.this.arn]
    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"
      values   = [var.source_arn]
    }
  }

  dynamic "statement" {
    for_each = length(var.consumer_accounts) > 0 ? ["go"] : []

    content {
      sid    = "consumers"
      effect = "Allow"
      principals {
        type        = "AWS"
        identifiers = var.consumer_accounts
      }
      actions   = [
        "sqs:ChangeMessageVisibility",
        "sqs:DeleteMessage",
        "sqs:PurgeQueue",
        "sqs:ReceiveMessage"
      ]
      resources = [aws_sqs_queue.this.arn]
    }
  }
}

resource "aws_sqs_queue_policy" "this" {
  queue_url = aws_sqs_queue.this.id
  policy    = data.aws_iam_policy_document.this.json
}
