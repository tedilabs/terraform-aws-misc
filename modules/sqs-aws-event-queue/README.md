# sqs-aws-event-queue

This module creates following resources.

- `aws_sqs_queue`
- `aws_sqs_queue_policy`

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13 |
| aws | >= 3.34 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 3.34 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | This is the human-readable name of the queue. | `string` | n/a | yes |
| source\_arn | The ARN of the source for the SQS queue. | `string` | n/a | yes |
| consumer\_accounts | A List of the the AWS account ARN or a shortened form with the account ID. | `list(any)` | `[]` | no |
| delay\_seconds | The time in seconds that the delivery of all messages in the queue will be delayed. An integer from 0 to 900 (15 minutes). | `number` | `0` | no |
| max\_message\_size | The limit of how many bytes a message can contain before Amazon SQS rejects it. An integer from 1024 bytes (1 KiB) up to 262144 bytes (256 KiB). | `number` | `262144` | no |
| message\_retention\_seconds | The number of seconds Amazon SQS retains a message. Integer representing seconds, from 60 (1 minute) to 1209600 (14 days). | `number` | `345600` | no |
| module\_tags\_enabled | Whether to create AWS Resource Tags for the module informations. | `bool` | `true` | no |
| receive\_wait\_time\_seconds | The time for which a ReceiveMessage call will wait for a message to arrive (long polling) before returning. An integer from 0 to 20 (seconds). The default for this attribute is 0, meaning that the call will return immediately. | `number` | `0` | no |
| resource\_group\_description | The description of Resource Group. | `string` | `"Managed by Terraform."` | no |
| resource\_group\_enabled | Whether to create Resource Group to find and group AWS resources which are created by this module. | `bool` | `true` | no |
| resource\_group\_name | The name of Resource Group. A Resource Group name can have a maximum of 127 characters, including letters, numbers, hyphens, dots, and underscores. The name cannot start with `AWS` or `aws`. | `string` | `""` | no |
| tags | A map of tags to add to all resources. | `map(string)` | `{}` | no |
| visibility\_timeout\_seconds | The visibility timeout for the queue. An integer from 0 to 43200 (12 hours). | `number` | `30` | no |

## Outputs

| Name | Description |
|------|-------------|
| arn | The ARN of the SQS queue. |
| id | The URL for the created Amazon SQS queue. |
| name | The name of the SQS queue. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
