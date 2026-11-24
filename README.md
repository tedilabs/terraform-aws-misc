# terraform-aws-misc

![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/tedilabs/terraform-aws-misc?color=blue&sort=semver&style=flat-square)
![GitHub](https://img.shields.io/github/license/tedilabs/terraform-aws-misc?color=blue&style=flat-square)
[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white&style=flat-square)](https://github.com/pre-commit/pre-commit)

Terraform module which creates resources for misc services on AWS.

- [resource-group](./modules/resource-group)
- [s3-archive-bucket](./modules/s3-archive-bucket)
- [scalable-target](./modules/scalable-target)
- [sqs-aws-event-queue](./modules/sqs-aws-event-queue)


## Target AWS Services

Terraform Modules from [this package](https://github.com/tedilabs/terraform-aws-misc) were written to manage the following AWS Services with Terraform.

- **AWS Application Auto Scaling**
  - Scalable Target
  - Scaling Policy
  - Scheduled Action
- **AWS Resource Groups**
  - Resource Group
- **AWS S3 (Simple Storage Service)**
  - Archive Bucket
- **AWS SQS (Simple Queue Service)**
  - AWS Event Queue


## Examples

### Application Auto Scaling

- [scalable-target-dynamodb-table](./examples/scalable-target-dynamodb-table)


## Self Promotion

Like this project? Follow the repository on [GitHub](https://github.com/tedilabs/terraform-aws-misc). And if you're feeling especially charitable, follow **[posquit0](https://github.com/posquit0)** on GitHub.


## License

Provided under the terms of the [Apache License](LICENSE).

Copyright © 2021-2026, [Byungjin Park](https://www.posquit0.com).