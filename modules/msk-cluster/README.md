# msk-cluster

This module creates following resources.

- `aws_msk_cluster`
- `aws_msk_configuration`
- `aws_security_group` (optional)
- `aws_security_group_rule` (optional)

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.15 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.62 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.69.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_security_group"></a> [security\_group](#module\_security\_group) | tedilabs/network/aws//modules/security-group | 0.24.0 |

## Resources

| Name | Type |
|------|------|
| [aws_msk_cluster.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/msk_cluster) | resource |
| [aws_msk_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/msk_configuration) | resource |
| [aws_resourcegroups_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/resourcegroups_group) | resource |
| [aws_msk_broker_nodes.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/msk_broker_nodes) | data source |
| [aws_subnet.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_broker_size"></a> [broker\_size](#input\_broker\_size) | The desired total number of broker nodes in the kafka cluster. It must be a multiple of the number of specified client subnets. | `number` | n/a | yes |
| <a name="input_broker_subnets"></a> [broker\_subnets](#input\_broker\_subnets) | A list of subnet IDs to place ENIs of the MSK cluster broker nodes within. | `list(string)` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the MSK cluster. | `string` | n/a | yes |
| <a name="input_auth_sasl_iam_enabled"></a> [auth\_sasl\_iam\_enabled](#input\_auth\_sasl\_iam\_enabled) | Enables IAM client authentication. | `bool` | `false` | no |
| <a name="input_auth_sasl_scram_enabled"></a> [auth\_sasl\_scram\_enabled](#input\_auth\_sasl\_scram\_enabled) | Enables SCRAM client authentication via AWS Secrets Manager. | `bool` | `false` | no |
| <a name="input_auth_tls_acm_ca_arns"></a> [auth\_tls\_acm\_ca\_arns](#input\_auth\_tls\_acm\_ca\_arns) | List of ACM Certificate Authority Amazon Resource Names (ARNs). | `list(string)` | `[]` | no |
| <a name="input_broker_additional_security_groups"></a> [broker\_additional\_security\_groups](#input\_broker\_additional\_security\_groups) | A list of security group IDs to associate with ENIs to control who can communicate with the cluster. | `list(string)` | `[]` | no |
| <a name="input_broker_allowed_ingress_cidrs"></a> [broker\_allowed\_ingress\_cidrs](#input\_broker\_allowed\_ingress\_cidrs) | A list of CIDR for MSK ingress access. | `list(string)` | `[]` | no |
| <a name="input_broker_instance_type"></a> [broker\_instance\_type](#input\_broker\_instance\_type) | The instance type to use for the kafka brokers. | `string` | `"kafka.m5.large"` | no |
| <a name="input_broker_volume_size"></a> [broker\_volume\_size](#input\_broker\_volume\_size) | The size in GiB of the EBS volume for the data drive on each broker node. | `number` | `1000` | no |
| <a name="input_encryption_at_rest_kms_key_arn"></a> [encryption\_at\_rest\_kms\_key\_arn](#input\_encryption\_at\_rest\_kms\_key\_arn) | Specify a KMS key short ID or ARN (it will always output an ARN) to use for encrypting your data at rest. If no key is specified, an AWS managed KMS ('aws/msk' managed service) key will be used for encrypting the data at rest. | `string` | `""` | no |
| <a name="input_encryption_in_transit_client_mode"></a> [encryption\_in\_transit\_client\_mode](#input\_encryption\_in\_transit\_client\_mode) | Encryption setting for data in transit between clients and brokers. `TLS`, `TLS_PLAINTEXT`, `PLAINTEXT` are available. | `string` | `"TLS_PLAINTEXT"` | no |
| <a name="input_encryption_in_transit_in_cluster_enabled"></a> [encryption\_in\_transit\_in\_cluster\_enabled](#input\_encryption\_in\_transit\_in\_cluster\_enabled) | Whether data communication among broker nodes is encrypted. | `bool` | `true` | no |
| <a name="input_kafka_config"></a> [kafka\_config](#input\_kafka\_config) | Contents of the server.properties file for configuration of Kafka. | `string` | `""` | no |
| <a name="input_kafka_version"></a> [kafka\_version](#input\_kafka\_version) | Kafka version to use for the MSK cluster. | `string` | `"2.8.0"` | no |
| <a name="input_logging_cloudwatch_enabled"></a> [logging\_cloudwatch\_enabled](#input\_logging\_cloudwatch\_enabled) | Indicates whether you want to enable or disable streaming broker logs to Cloudwatch Logs. | `bool` | `false` | no |
| <a name="input_logging_cloudwatch_log_group"></a> [logging\_cloudwatch\_log\_group](#input\_logging\_cloudwatch\_log\_group) | Name of the Cloudwatch Log Group to deliver logs to. | `string` | `null` | no |
| <a name="input_logging_firehose_delivery_stream"></a> [logging\_firehose\_delivery\_stream](#input\_logging\_firehose\_delivery\_stream) | Name of the Kinesis Data Firehose delivery stream to deliver logs to. | `string` | `null` | no |
| <a name="input_logging_firehose_enabled"></a> [logging\_firehose\_enabled](#input\_logging\_firehose\_enabled) | Indicates whether you want to enable or disable streaming broker logs to Kinesis Data Firehose. | `bool` | `false` | no |
| <a name="input_logging_s3_bucket"></a> [logging\_s3\_bucket](#input\_logging\_s3\_bucket) | Name of the S3 bucket to deliver logs to. | `string` | `null` | no |
| <a name="input_logging_s3_enabled"></a> [logging\_s3\_enabled](#input\_logging\_s3\_enabled) | Indicates whether you want to enable or disable streaming broker logs to S3. | `bool` | `false` | no |
| <a name="input_logging_s3_prefix"></a> [logging\_s3\_prefix](#input\_logging\_s3\_prefix) | Prefix to append to the folder name. | `string` | `null` | no |
| <a name="input_module_tags_enabled"></a> [module\_tags\_enabled](#input\_module\_tags\_enabled) | Whether to create AWS Resource Tags for the module informations. | `bool` | `true` | no |
| <a name="input_monitoring_cloudwatch_level"></a> [monitoring\_cloudwatch\_level](#input\_monitoring\_cloudwatch\_level) | The desired enhanced MSK CloudWatch monitoring level. `DEFAULT`, `PER_BROKER`, `PER_TOPIC_PER_BROKER`, `PER_TOPIC_PER_PARTITION` are available. | `string` | `"DEFAULT"` | no |
| <a name="input_monitoring_prometheus_jmx_exporter_enabled"></a> [monitoring\_prometheus\_jmx\_exporter\_enabled](#input\_monitoring\_prometheus\_jmx\_exporter\_enabled) | Indicates whether you want to enable or disable the JMX Exporter. | `bool` | `false` | no |
| <a name="input_monitoring_prometheus_node_exporter_enabled"></a> [monitoring\_prometheus\_node\_exporter\_enabled](#input\_monitoring\_prometheus\_node\_exporter\_enabled) | Indicates whether you want to enable or disable the Node Exporter. | `bool` | `false` | no |
| <a name="input_resource_group_description"></a> [resource\_group\_description](#input\_resource\_group\_description) | The description of Resource Group. | `string` | `"Managed by Terraform."` | no |
| <a name="input_resource_group_enabled"></a> [resource\_group\_enabled](#input\_resource\_group\_enabled) | Whether to create Resource Group to find and group AWS resources which are created by this module. | `bool` | `true` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of Resource Group. A Resource Group name can have a maximum of 127 characters, including letters, numbers, hyphens, dots, and underscores. The name cannot start with `AWS` or `aws`. | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | The ARN of the MSK cluster. |
| <a name="output_bootstrap_brokers"></a> [bootstrap\_brokers](#output\_bootstrap\_brokers) | A comma separated list of one or more hostname:port pairs of kafka brokers suitable to boostrap connectivity to the kafka cluster. Only contains value if `client_encryption_in_transit_mode` is set to PLAINTEXT or TLS\_PLAINTEXT. AWS may not always return all endpoints so the values may not be stable across applies. |
| <a name="output_bootstrap_brokers_sasl_iam"></a> [bootstrap\_brokers\_sasl\_iam](#output\_bootstrap\_brokers\_sasl\_iam) | A comma separated list of one or more DNS names (or IPs) and SASL IAM port pairs. Only contains value if `client_encryption_in_transit_mode` is set to TLS\_PLAINTEXT or TLS. AWS may not always return all endpoints so the values may not be stable across applies. |
| <a name="output_bootstrap_brokers_sasl_scram"></a> [bootstrap\_brokers\_sasl\_scram](#output\_bootstrap\_brokers\_sasl\_scram) | A comma separated list of one or more DNS names (or IPs) and SASL SCRAM port pairs. Only contains value if `client_encryption_in_transit_mode` is set to TLS\_PLAINTEXT or TLS. AWS may not always return all endpoints so the values may not be stable across applies. |
| <a name="output_bootstrap_brokers_tls"></a> [bootstrap\_brokers\_tls](#output\_bootstrap\_brokers\_tls) | A comma separated list of one or more DNS names (or IPs) and TLS port pairs kafka brokers suitable to boostrap connectivity to the kafka cluster. Only contains value if `client_encryption_in_transit_mode is set to TLS_PLAINTEXT or TLS. AWS may not always return all endpoints so the values may not be stable across applies.` |
| <a name="output_broker_instance_type"></a> [broker\_instance\_type](#output\_broker\_instance\_type) | The instance type used by the kafka brokers. |
| <a name="output_broker_nodes"></a> [broker\_nodes](#output\_broker\_nodes) | The information of broker nodes in the kafka cluster. |
| <a name="output_broker_security_group_id"></a> [broker\_security\_group\_id](#output\_broker\_security\_group\_id) | The id of security group that were created for the MSK cluster. |
| <a name="output_broker_size"></a> [broker\_size](#output\_broker\_size) | The number of broker nodes in the kafka cluster. |
| <a name="output_broker_volume_size"></a> [broker\_volume\_size](#output\_broker\_volume\_size) | The EBS volume size in GiB on each broker node. |
| <a name="output_encryption_at_rest_kms_key_arn"></a> [encryption\_at\_rest\_kms\_key\_arn](#output\_encryption\_at\_rest\_kms\_key\_arn) | The ARN of the KMS key used for encryption at rest of the broker data volumes. |
| <a name="output_kafka_config"></a> [kafka\_config](#output\_kafka\_config) | Contents of the MSK configuration. |
| <a name="output_kafka_config_arn"></a> [kafka\_config\_arn](#output\_kafka\_config\_arn) | The ARN of the MSK configuration. |
| <a name="output_kafka_version"></a> [kafka\_version](#output\_kafka\_version) | The MSK cluster version. |
| <a name="output_name"></a> [name](#output\_name) | The MSK cluster name. |
| <a name="output_version"></a> [version](#output\_version) | Current version of the MSK Cluster used for updates. |
| <a name="output_zookeeper_connections"></a> [zookeeper\_connections](#output\_zookeeper\_connections) | A comma separated list of one or more IP:port pairs to use to connect to the Apache Zookeeper cluster. |
| <a name="output_zookeeper_connections_tls"></a> [zookeeper\_connections\_tls](#output\_zookeeper\_connections\_tls) | A comma separated list of one or more IP:port pairs to use to connect to the Apache Zookeeper cluster via TLS. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
