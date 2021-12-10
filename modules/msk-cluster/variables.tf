variable "name" {
  description = "Name of the MSK cluster."
  type        = string
}

variable "kafka_version" {
  description = "Kafka version to use for the MSK cluster."
  type        = string
  default     = "2.8.0"
}

variable "kafka_config" {
  description = "Contents of the server.properties file for configuration of Kafka."
  type        = string
  default     = ""
}

variable "broker_size" {
  description = "The desired total number of broker nodes in the kafka cluster. It must be a multiple of the number of specified client subnets."
  type        = number
}

variable "broker_instance_type" {
  description = "The instance type to use for the kafka brokers."
  type        = string
  default     = "kafka.m5.large"
}

variable "broker_volume_size" {
  description = "The size in GiB of the EBS volume for the data drive on each broker node."
  type        = number
  default     = 1000
}

variable "broker_subnets" {
  description = "A list of subnet IDs to place ENIs of the MSK cluster broker nodes within."
  type        = list(string)
}

variable "broker_allowed_ingress_cidrs" {
  description = "A list of CIDR for MSK ingress access."
  type        = list(string)
  default     = []
}

variable "broker_additional_security_groups" {
  description = "A list of security group IDs to associate with ENIs to control who can communicate with the cluster."
  type        = list(string)
  default     = []
}

variable "logging_cloudwatch_enabled" {
  description = "Indicates whether you want to enable or disable streaming broker logs to Cloudwatch Logs."
  type        = bool
  default     = false
}

variable "logging_cloudwatch_log_group" {
  description = "Name of the Cloudwatch Log Group to deliver logs to."
  type        = string
  default     = null
}

variable "logging_firehose_enabled" {
  description = "Indicates whether you want to enable or disable streaming broker logs to Kinesis Data Firehose."
  type        = bool
  default     = false
}

variable "logging_firehose_delivery_stream" {
  description = "Name of the Kinesis Data Firehose delivery stream to deliver logs to."
  type        = string
  default     = null
}

variable "logging_s3_enabled" {
  description = "Indicates whether you want to enable or disable streaming broker logs to S3."
  type        = bool
  default     = false
}

variable "logging_s3_bucket" {
  description = "Name of the S3 bucket to deliver logs to."
  type        = string
  default     = null
}

variable "logging_s3_prefix" {
  description = "Prefix to append to the folder name."
  type        = string
  default     = null
}

variable "monitoring_cloudwatch_level" {
  description = "The desired enhanced MSK CloudWatch monitoring level. `DEFAULT`, `PER_BROKER`, `PER_TOPIC_PER_BROKER`, `PER_TOPIC_PER_PARTITION` are available."
  type        = string
  default     = "DEFAULT"
}

variable "monitoring_prometheus_jmx_exporter_enabled" {
  description = "Indicates whether you want to enable or disable the JMX Exporter."
  type        = bool
  default     = false
}

variable "monitoring_prometheus_node_exporter_enabled" {
  description = "Indicates whether you want to enable or disable the Node Exporter."
  type        = bool
  default     = false
}

variable "encryption_at_rest_kms_key_arn" {
  description = "Specify a KMS key short ID or ARN (it will always output an ARN) to use for encrypting your data at rest. If no key is specified, an AWS managed KMS ('aws/msk' managed service) key will be used for encrypting the data at rest."
  type        = string
  default     = ""
}

variable "encryption_in_transit_in_cluster_enabled" {
  description = "Whether data communication among broker nodes is encrypted."
  type        = bool
  default     = true
}

variable "encryption_in_transit_client_mode" {
  description = "Encryption setting for data in transit between clients and brokers. `TLS`, `TLS_PLAINTEXT`, `PLAINTEXT` are available."
  type        = string
  default     = "TLS_PLAINTEXT"
}

variable "auth_sasl_iam_enabled" {
  description = "Enables IAM client authentication."
  type        = bool
  default     = false
}

variable "auth_sasl_scram_enabled" {
  description = "Enables SCRAM client authentication via AWS Secrets Manager."
  type        = bool
  default     = false
}

variable "auth_tls_acm_ca_arns" {
  description = "List of ACM Certificate Authority Amazon Resource Names (ARNs)."
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}

variable "module_tags_enabled" {
  description = "Whether to create AWS Resource Tags for the module informations."
  type        = bool
  default     = true
}


###################################################
# Resource Group
###################################################

variable "resource_group_enabled" {
  description = "Whether to create Resource Group to find and group AWS resources which are created by this module."
  type        = bool
  default     = true
}

variable "resource_group_name" {
  description = "The name of Resource Group. A Resource Group name can have a maximum of 127 characters, including letters, numbers, hyphens, dots, and underscores. The name cannot start with `AWS` or `aws`."
  type        = string
  default     = ""
}

variable "resource_group_description" {
  description = "The description of Resource Group."
  type        = string
  default     = "Managed by Terraform."
}
