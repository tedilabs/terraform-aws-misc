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
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.22 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.22.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_security_group"></a> [security\_group](#module\_security\_group) | tedilabs/network/aws//modules/security-group | 0.26.0 |

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
| <a name="input_broker_size"></a> [broker\_size](#input\_broker\_size) | (Required) The desired total number of broker nodes in the kafka cluster. It must be a multiple of the number of specified client subnets. | `number` | n/a | yes |
| <a name="input_broker_subnets"></a> [broker\_subnets](#input\_broker\_subnets) | (Required) A list of subnet IDs to place ENIs of the MSK cluster broker nodes within. | `list(string)` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | (Required) Name of the MSK cluster. | `string` | n/a | yes |
| <a name="input_auth_sasl_iam_enabled"></a> [auth\_sasl\_iam\_enabled](#input\_auth\_sasl\_iam\_enabled) | (Optional) Enables IAM client authentication. | `bool` | `false` | no |
| <a name="input_auth_sasl_scram_enabled"></a> [auth\_sasl\_scram\_enabled](#input\_auth\_sasl\_scram\_enabled) | (Optional) Enables SCRAM client authentication via AWS Secrets Manager. | `bool` | `false` | no |
| <a name="input_auth_tls_acm_ca_arns"></a> [auth\_tls\_acm\_ca\_arns](#input\_auth\_tls\_acm\_ca\_arns) | (Optional) List of ACM Certificate Authority Amazon Resource Names (ARNs). | `list(string)` | `[]` | no |
| <a name="input_auth_tls_enabled"></a> [auth\_tls\_enabled](#input\_auth\_tls\_enabled) | (Optional) Enables TLS client authentication. | `bool` | `false` | no |
| <a name="input_auth_unauthenticated_access_enabled"></a> [auth\_unauthenticated\_access\_enabled](#input\_auth\_unauthenticated\_access\_enabled) | (Optional) Enables unauthenticated access. Defaults to `true`. | `bool` | `true` | no |
| <a name="input_broker_additional_security_groups"></a> [broker\_additional\_security\_groups](#input\_broker\_additional\_security\_groups) | (Optional) A list of security group IDs to associate with ENIs to control who can communicate with the cluster. | `list(string)` | `[]` | no |
| <a name="input_broker_allowed_ingress_cidrs"></a> [broker\_allowed\_ingress\_cidrs](#input\_broker\_allowed\_ingress\_cidrs) | (Optional) A list of CIDR for MSK ingress access. | `list(string)` | `[]` | no |
| <a name="input_broker_instance_type"></a> [broker\_instance\_type](#input\_broker\_instance\_type) | (Optional) The instance type to use for the kafka brokers. | `string` | `"kafka.m5.large"` | no |
| <a name="input_broker_public_access_enabled"></a> [broker\_public\_access\_enabled](#input\_broker\_public\_access\_enabled) | (Optional) Whether to allow public access to MSK brokers. | `bool` | `false` | no |
| <a name="input_broker_volume_provisioned_throughput"></a> [broker\_volume\_provisioned\_throughput](#input\_broker\_volume\_provisioned\_throughput) | (Optional) Throughput value of the EBS volumes for the data drive on each kafka broker node in MiB per second. The minimum value is `250`. The maximum value varies between broker type. | `number` | `null` | no |
| <a name="input_broker_volume_provisioned_throughput_enabled"></a> [broker\_volume\_provisioned\_throughput\_enabled](#input\_broker\_volume\_provisioned\_throughput\_enabled) | (Optional) Whether provisioned throughput is enabled or not. You can specify the provisioned throughput rate in MiB per second for clusters whose brokers are of type `kafka.m5.4xlarge` or larger and if the storage volume is 10 GiB or greater. Defaults to `false`. | `bool` | `false` | no |
| <a name="input_broker_volume_size"></a> [broker\_volume\_size](#input\_broker\_volume\_size) | (Optional) The size in GiB of the EBS volume for the data drive on each broker node. Minimum value of `1` and maximum value of `16384`. Defaults to `1000`. | `number` | `1000` | no |
| <a name="input_encryption_at_rest_kms_key"></a> [encryption\_at\_rest\_kms\_key](#input\_encryption\_at\_rest\_kms\_key) | (Optional) Specify a KMS key short ID or ARN (it will always output an ARN) to use for encrypting your data at rest. If no key is specified, an AWS managed KMS ('aws/msk' managed service) key will be used for encrypting the data at rest. | `string` | `""` | no |
| <a name="input_encryption_in_transit_client_mode"></a> [encryption\_in\_transit\_client\_mode](#input\_encryption\_in\_transit\_client\_mode) | (Optional) Encryption setting for data in transit between clients and brokers. `TLS`, `TLS_PLAINTEXT`, `PLAINTEXT` are available. | `string` | `"TLS_PLAINTEXT"` | no |
| <a name="input_encryption_in_transit_in_cluster_enabled"></a> [encryption\_in\_transit\_in\_cluster\_enabled](#input\_encryption\_in\_transit\_in\_cluster\_enabled) | (Optional) Whether data communication among broker nodes is encrypted. | `bool` | `true` | no |
| <a name="input_kafka_server_properties"></a> [kafka\_server\_properties](#input\_kafka\_server\_properties) | (Optional) Contents of the `server.properties` file for configuration of Kafka. | `string` | `""` | no |
| <a name="input_kafka_version"></a> [kafka\_version](#input\_kafka\_version) | (Optional) Kafka version to use for the MSK cluster. | `string` | `"2.8.0"` | no |
| <a name="input_logging_cloudwatch_enabled"></a> [logging\_cloudwatch\_enabled](#input\_logging\_cloudwatch\_enabled) | (Optional) Indicates whether you want to enable or disable streaming broker logs to Cloudwatch Logs. | `bool` | `false` | no |
| <a name="input_logging_cloudwatch_log_group"></a> [logging\_cloudwatch\_log\_group](#input\_logging\_cloudwatch\_log\_group) | (Optional) The name of log group on CloudWatch Logs to deliver logs to. | `string` | `""` | no |
| <a name="input_logging_firehose_delivery_stream"></a> [logging\_firehose\_delivery\_stream](#input\_logging\_firehose\_delivery\_stream) | (Optional) Name of the Kinesis Data Firehose delivery stream to deliver logs to. | `string` | `""` | no |
| <a name="input_logging_firehose_enabled"></a> [logging\_firehose\_enabled](#input\_logging\_firehose\_enabled) | (Optional) Indicates whether you want to enable or disable streaming broker logs to Kinesis Data Firehose. | `bool` | `false` | no |
| <a name="input_logging_s3_bucket"></a> [logging\_s3\_bucket](#input\_logging\_s3\_bucket) | (Optional) The name of the S3 bucket to deliver logs to. | `string` | `""` | no |
| <a name="input_logging_s3_enabled"></a> [logging\_s3\_enabled](#input\_logging\_s3\_enabled) | (Optional) Indicates whether you want to enable or disable streaming broker logs to S3. | `bool` | `false` | no |
| <a name="input_logging_s3_prefix"></a> [logging\_s3\_prefix](#input\_logging\_s3\_prefix) | (Optional) The prefix to append to the folder name. | `string` | `""` | no |
| <a name="input_module_tags_enabled"></a> [module\_tags\_enabled](#input\_module\_tags\_enabled) | (Optional) Whether to create AWS Resource Tags for the module informations. | `bool` | `true` | no |
| <a name="input_monitoring_cloudwatch_level"></a> [monitoring\_cloudwatch\_level](#input\_monitoring\_cloudwatch\_level) | (Optional) The desired enhanced MSK CloudWatch monitoring level. `DEFAULT`, `PER_BROKER`, `PER_TOPIC_PER_BROKER`, `PER_TOPIC_PER_PARTITION` are available. | `string` | `"DEFAULT"` | no |
| <a name="input_monitoring_prometheus_jmx_exporter_enabled"></a> [monitoring\_prometheus\_jmx\_exporter\_enabled](#input\_monitoring\_prometheus\_jmx\_exporter\_enabled) | (Optional) Indicates whether you want to enable or disable the JMX Exporter. | `bool` | `false` | no |
| <a name="input_monitoring_prometheus_node_exporter_enabled"></a> [monitoring\_prometheus\_node\_exporter\_enabled](#input\_monitoring\_prometheus\_node\_exporter\_enabled) | (Optional) Indicates whether you want to enable or disable the Node Exporter. | `bool` | `false` | no |
| <a name="input_resource_group_description"></a> [resource\_group\_description](#input\_resource\_group\_description) | (Optional) The description of Resource Group. | `string` | `"Managed by Terraform."` | no |
| <a name="input_resource_group_enabled"></a> [resource\_group\_enabled](#input\_resource\_group\_enabled) | (Optional) Whether to create Resource Group to find and group AWS resources which are created by this module. | `bool` | `true` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Optional) The name of Resource Group. A Resource Group name can have a maximum of 127 characters, including letters, numbers, hyphens, dots, and underscores. The name cannot start with `AWS` or `aws`. | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A map of tags to add to all resources. | `map(string)` | `{}` | no |
| <a name="input_timeouts"></a> [timeouts](#input\_timeouts) | (Optional) How long to wait for the MSK cluster to be created/updated/deleted. | `map(string)` | <pre>{<br>  "create": "120m",<br>  "delete": "120m",<br>  "update": "120m"<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | The ARN of the MSK cluster. |
| <a name="output_auth"></a> [auth](#output\_auth) | A configuration for authentication of the Kafka cluster. |
| <a name="output_bootstrap_brokers"></a> [bootstrap\_brokers](#output\_bootstrap\_brokers) | A configuration for connecting to the Kafka cluster.<br>    `plaintext` - A comma separated list of one or more hostname:port pairs of kafka brokers suitable to boostrap connectivity to the kafka cluster. Only contains value if `client_encryption_in_transit_mode` is set to PLAINTEXT or TLS\_PLAINTEXT. AWS may not always return all endpoints so the values may not be stable across applies.<br>    `sasl_iam` - A comma separated list of one or more DNS names (or IPs) and SASL IAM port pairs. Only contains value if `client_encryption_in_transit_mode` is set to TLS\_PLAINTEXT or TLS. AWS may not always return all endpoints so the values may not be stable across applies.<br>    `sasl_scram` - A comma separated list of one or more DNS names (or IPs) and SASL SCRAM port pairs. Only contains value if `client_encryption_in_transit_mode` is set to TLS\_PLAINTEXT or TLS. AWS may not always return all endpoints so the values may not be stable across applies.<br>    `tls` - A comma separated list of one or more DNS names (or IPs) and TLS port pairs kafka brokers suitable to boostrap connectivity to the kafka cluster. Only contains value if `client_encryption_in_transit_mode is set to TLS_PLAINTEXT or TLS. AWS may not always return all endpoints so the values may not be stable across applies.<br>    `public\_sasl\_iam` - A comma separated list of one or more DNS names (or IPs) and SASL IAM port pairs. Only contains value if `client\_encryption\_in\_transit\_mode` is set to TLS_PLAINTEXT or TLS and `auth\_sasl\_iam\_enabled` is `true` and `broker\_public\_access\_enabled` is `true`. AWS may not always return all endpoints so the values may not be stable across applies.<br>    `public\_sasl\_scram` - A comma separated list of one or more DNS names (or IPs) and SASL SCRAM port pairs. Only contains value if `client\_encryption\_in\_transit\_mode` is set to TLS_PLAINTEXT or TLS and `auth\_sasl\_scram\_enabled` is `true` and `broker\_public\_access\_enabled` is `true`. AWS may not always return all endpoints so the values may not be stable across applies.<br>    `public\_tls` - A comma separated list of one or more DNS names (or IPs) and TLS port pairs. Only contains value if `client\_encryption\_in\_transit\_mode` is set to TLS_PLAINTEXT or TLS and `broker\_public\_access\_enabled` is `true`. AWS may not always return all endpoints so the values may not be stable across applies.<br>` |
| <a name="output_broker"></a> [broker](#output\_broker) | A configuration for brokers of the Kafka cluster.<br>    `size` - The number of broker nodes in the kafka cluster.<br>    `instance_type` - The instance type used by the kafka brokers.<br><br>    `public_access_enabled` - Whether public access to MSK brokers is enabled.<br>    `security_groups` - A list of the security groups associated with the MSK cluster.<br><br>    `volume` - A EBS volume information for MSK brokers. |
| <a name="output_broker_nodes"></a> [broker\_nodes](#output\_broker\_nodes) | The information of broker nodes in the kafka cluster. |
| <a name="output_broker_security_group_id"></a> [broker\_security\_group\_id](#output\_broker\_security\_group\_id) | The id of security group that were created for the MSK cluster. |
| <a name="output_encryption"></a> [encryption](#output\_encryption) | A configuration for encryption of the Kafka cluster.<br>    `at_rest` - The configuration for encryption at rest.<br>    `in_transit` - The configuration for encryption in transit. |
| <a name="output_kafka_config"></a> [kafka\_config](#output\_kafka\_config) | The MSK configuration. |
| <a name="output_kafka_version"></a> [kafka\_version](#output\_kafka\_version) | The MSK cluster version. |
| <a name="output_logging"></a> [logging](#output\_logging) | A configuration for logging of the Kafka cluster.<br>    `cloudwatch` - The configuration for MSK broker logs to CloudWatch Logs.<br>    `firehose` - The configuration for MSK broker logs to Kinesis Firehose.<br>    `s3` - The configuration for MSK broker logs to S3 Bucket. |
| <a name="output_monitoring"></a> [monitoring](#output\_monitoring) | A configuration for monitoring of the Kafka cluster.<br>    `cloudwatch` - The configuration for MSK CloudWatch Metrics.<br>    `prometheus` - The configuration for Prometheus open monitoring. |
| <a name="output_name"></a> [name](#output\_name) | The MSK cluster name. |
| <a name="output_version"></a> [version](#output\_version) | Current version of the MSK Cluster used for updates. |
| <a name="output_zookeeper_connections"></a> [zookeeper\_connections](#output\_zookeeper\_connections) | A configuration for connecting to the Apache Zookeeper cluster.<br>    `tcp` - A comma separated list of one or more IP:port pairs to use to connect to the Apache Zookeeper cluster.<br>    `tls` - A comma separated list of one or more IP:port pairs to use to connect to the Apache Zookeeper cluster via TLS. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
