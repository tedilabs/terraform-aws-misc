variable "name" {
  description = "(Required) Name of the MSK cluster."
  type        = string
}

variable "kafka_version" {
  description = "(Optional) Kafka version to use for the MSK cluster."
  type        = string
  default     = "2.8.0"
  nullable    = false
}

variable "kafka_server_properties" {
  description = "(Optional) Contents of the `server.properties` file for configuration of Kafka."
  type        = map(string)
  default     = {}
  nullable    = false
}

variable "broker_size" {
  description = "(Required) The desired total number of broker nodes in the kafka cluster. It must be a multiple of the number of specified client subnets."
  type        = number
}

variable "broker_instance_type" {
  description = "(Optional) The instance type to use for the kafka brokers."
  type        = string
  default     = "kafka.m5.large"
  nullable    = false
}

variable "broker_volume_size" {
  description = "(Optional) The size in GiB of the EBS volume for the data drive on each broker node. Minimum value of `1` and maximum value of `16384`. Defaults to `1000`."
  type        = number
  default     = 1000
  nullable    = false

  validation {
    condition = alltrue([
      var.broker_volume_size >= 1,
      var.broker_volume_size <= 16384,
    ])
    error_message = "Valid value for `broker_volume_size` is between `1` and `16384`."
  }
}

variable "broker_volume_provisioned_throughput_enabled" {
  description = "(Optional) Whether provisioned throughput is enabled or not. You can specify the provisioned throughput rate in MiB per second for clusters whose brokers are of type `kafka.m5.4xlarge` or larger and if the storage volume is 10 GiB or greater. Defaults to `false`."
  type        = bool
  default     = false
  nullable    = false
}

variable "broker_volume_provisioned_throughput" {
  description = "(Optional) Throughput value of the EBS volumes for the data drive on each kafka broker node in MiB per second. The minimum value is `250`. The maximum value varies between broker type."
  type        = number
  default     = null
}

variable "broker_subnets" {
  description = "(Required) A list of subnet IDs to place ENIs of the MSK cluster broker nodes within."
  type        = list(string)
}

variable "broker_public_access_enabled" {
  description = "(Optional) Whether to allow public access to MSK brokers."
  type        = bool
  default     = false
  nullable    = false
}

variable "broker_allowed_ingress_cidrs" {
  description = "(Optional) A list of CIDR for MSK ingress access."
  type        = list(string)
  default     = []
}

variable "broker_additional_security_groups" {
  description = "(Optional) A list of security group IDs to associate with ENIs to control who can communicate with the cluster."
  type        = list(string)
  default     = []
}

variable "auth_unauthenticated_access_enabled" {
  description = "(Optional) Enables unauthenticated access. Defaults to `true`."
  type        = bool
  default     = true
  nullable    = false
}

variable "auth_sasl_iam_enabled" {
  description = "(Optional) Enables IAM client authentication."
  type        = bool
  default     = false
  nullable    = false
}

variable "auth_sasl_scram_enabled" {
  description = "(Optional) Enables SCRAM client authentication via AWS Secrets Manager."
  type        = bool
  default     = false
  nullable    = false
}

variable "auth_sasl_scram_kms_key" {
  description = "(Optional) The ARN of a KMS key to encrypt AWS SeecretsManager Secret resources for storing SASL/SCRAM authentication data. Only required when the MSK cluster has SASL/SCRAM authentication enabled. The Username/Password Authentication based on SASL/SCRAM needs to create a Secret resource in AWS SecretsManager with a custom AWS KMS Key. A secret created with the default AWS KMS key cannot be used with an Amazon MSK cluster."
  type        = string
  default     = null
}

variable "auth_sasl_scram_users" {
  description = "(Optional) A list of usernames to be allowed for SASL/SCRAM authentication to the MSK cluster. The password for each username is randomly generated and stored in AWS SecretsManager secret."
  type        = set(string)
  default     = []
  nullable    = false
}

variable "auth_tls_enabled" {
  description = "(Optional) Enables TLS client authentication."
  type        = bool
  default     = false
  nullable    = false
}

variable "auth_tls_acm_ca_arns" {
  description = "(Optional) List of ACM Certificate Authority Amazon Resource Names (ARNs)."
  type        = list(string)
  default     = []
  nullable    = false
}

variable "encryption_at_rest_kms_key" {
  description = "(Optional) Specify a KMS key short ID or ARN (it will always output an ARN) to use for encrypting your data at rest. If no key is specified, an AWS managed KMS ('aws/msk' managed service) key will be used for encrypting the data at rest."
  type        = string
  default     = ""
}

variable "encryption_in_transit_in_cluster_enabled" {
  description = "(Optional) Whether data communication among broker nodes is encrypted."
  type        = bool
  default     = true
  nullable    = false
}

variable "encryption_in_transit_client_mode" {
  description = "(Optional) Encryption setting for data in transit between clients and brokers. `TLS`, `TLS_PLAINTEXT`, `PLAINTEXT` are available."
  type        = string
  default     = "TLS_PLAINTEXT"
  nullable    = false

  validation {
    condition     = contains(["TLS", "TLS_PLAINTEXT", "PLAINTEXT"], var.encryption_in_transit_client_mode)
    error_message = "Valid values are `TLS`, `TLS_PLAINTEXT`, `PLAINTEXT`."
  }
}

variable "logging_cloudwatch_enabled" {
  description = "(Optional) Indicates whether you want to enable or disable streaming broker logs to Cloudwatch Logs."
  type        = bool
  default     = false
  nullable    = false
}

variable "logging_cloudwatch_log_group" {
  description = "(Optional) The name of log group on CloudWatch Logs to deliver logs to."
  type        = string
  default     = ""
  nullable    = false
}

variable "logging_firehose_enabled" {
  description = "(Optional) Indicates whether you want to enable or disable streaming broker logs to Kinesis Data Firehose."
  type        = bool
  default     = false
  nullable    = false
}

variable "logging_firehose_delivery_stream" {
  description = "(Optional) Name of the Kinesis Data Firehose delivery stream to deliver logs to."
  type        = string
  default     = ""
  nullable    = false
}

variable "logging_s3_enabled" {
  description = "(Optional) Indicates whether you want to enable or disable streaming broker logs to S3."
  type        = bool
  default     = false
  nullable    = false
}

variable "logging_s3_bucket" {
  description = "(Optional) The name of the S3 bucket to deliver logs to."
  type        = string
  default     = ""
  nullable    = false
}

variable "logging_s3_prefix" {
  description = "(Optional) The prefix to append to the folder name."
  type        = string
  default     = ""
  nullable    = false
}

variable "monitoring_cloudwatch_level" {
  description = "(Optional) The desired enhanced MSK CloudWatch monitoring level. `DEFAULT`, `PER_BROKER`, `PER_TOPIC_PER_BROKER`, `PER_TOPIC_PER_PARTITION` are available."
  type        = string
  default     = "DEFAULT"
  nullable    = false

  validation {
    condition     = contains(["DEFAULT", "PER_BROKER", "PER_TOPIC_PER_BROKER", "PER_TOPIC_PER_PARTITION"], var.monitoring_cloudwatch_level)
    error_message = "Valid values are `DEFAULT`, `PER_BROKER`, `PER_TOPIC_PER_BROKER`, `PER_TOPIC_PER_PARTITION`."
  }
}

variable "monitoring_prometheus_jmx_exporter_enabled" {
  description = "(Optional) Indicates whether you want to enable or disable the JMX Exporter."
  type        = bool
  default     = false
  nullable    = false
}

variable "monitoring_prometheus_node_exporter_enabled" {
  description = "(Optional) Indicates whether you want to enable or disable the Node Exporter."
  type        = bool
  default     = false
  nullable    = false
}

variable "timeouts" {
  description = "(Optional) How long to wait for the MSK cluster to be created/updated/deleted."
  type        = map(string)
  default = {
    create = "120m"
    update = "120m"
    delete = "120m"
  }
  nullable = false
}

variable "tags" {
  description = "(Optional) A map of tags to add to all resources."
  type        = map(string)
  default     = {}
  nullable    = false
}

variable "module_tags_enabled" {
  description = "(Optional) Whether to create AWS Resource Tags for the module informations."
  type        = bool
  default     = true
  nullable    = false
}


###################################################
# Resource Group
###################################################

variable "resource_group_enabled" {
  description = "(Optional) Whether to create Resource Group to find and group AWS resources which are created by this module."
  type        = bool
  default     = true
}

variable "resource_group_name" {
  description = "(Optional) The name of Resource Group. A Resource Group name can have a maximum of 127 characters, including letters, numbers, hyphens, dots, and underscores. The name cannot start with `AWS` or `aws`."
  type        = string
  default     = ""
}

variable "resource_group_description" {
  description = "(Optional) The description of Resource Group."
  type        = string
  default     = "Managed by Terraform."
}
