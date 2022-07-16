output "arn" {
  description = "The ARN of the MSK cluster."
  value       = aws_msk_cluster.this.arn
}

output "name" {
  description = "The MSK cluster name."
  value       = var.name
}

output "version" {
  description = "Current version of the MSK Cluster used for updates."
  value       = aws_msk_cluster.this.current_version
}

output "kafka_version" {
  description = "The MSK cluster version."
  value       = var.kafka_version
}

output "kafka_config" {
  description = "The MSK configuration."
  value = {
    arn             = aws_msk_configuration.this.arn
    name            = aws_msk_configuration.this.name
    latest_revision = aws_msk_configuration.this.latest_revision
    properties      = aws_msk_configuration.this.server_properties
  }
}

output "broker_security_group_id" {
  description = "The id of security group that were created for the MSK cluster."
  value       = try(module.security_group.*.id[0], null)
}

output "broker_nodes" {
  description = "The information of broker nodes in the kafka cluster."
  value       = data.aws_msk_broker_nodes.this.node_info_list
}

output "broker" {
  description = <<EOF
  A configuration for brokers of the Kafka cluster.
    `size` - The number of broker nodes in the kafka cluster.
    `instance_type` - The instance type used by the kafka brokers.

    `public_access_enabled` - Whether public access to MSK brokers is enabled.
    `security_groups` - A list of the security groups associated with the MSK cluster.

    `volume` - A EBS volume information for MSK brokers.
  EOF
  value = {
    size          = aws_msk_cluster.this.number_of_broker_nodes
    instance_type = aws_msk_cluster.this.broker_node_group_info.0.instance_type

    subnets                   = aws_msk_cluster.this.broker_node_group_info.0.client_subnets
    public_access_enabled     = var.broker_public_access_enabled
    security_groups           = aws_msk_cluster.this.broker_node_group_info.0.security_groups
    default_security_group_id = try(module.security_group.*.id[0], null)

    volume = {
      size = aws_msk_cluster.this.broker_node_group_info.0.storage_info.0.ebs_storage_info.0.volume_size
      provisioned_throughput = {
        enabled    = aws_msk_cluster.this.broker_node_group_info.0.storage_info.0.ebs_storage_info.0.provisioned_throughput.0.enabled
        throughput = aws_msk_cluster.this.broker_node_group_info.0.storage_info.0.ebs_storage_info.0.provisioned_throughput.0.volume_throughput
      }
    }
  }
}

output "auth" {
  description = "A configuration for authentication of the Kafka cluster."
  value = {
    unauthenticated_access = {
      enabled = aws_msk_cluster.this.client_authentication.0.unauthenticated
    }
    sasl = {
      iam = {
        enabled = aws_msk_cluster.this.client_authentication.0.sasl.0.iam
      }
      scram = {
        enabled = aws_msk_cluster.this.client_authentication.0.sasl.0.scram
        kms_key = var.auth_sasl_scram_kms_key
        users   = var.auth_sasl_scram_users
      }
    }
    tls = {
      enabled     = var.auth_tls_enabled
      acm_ca_arns = try(aws_msk_cluster.this.client_authentication.0.tls.0.certificate_authority_arns, [])
    }
  }
}

output "encryption" {
  description = <<EOF
  A configuration for encryption of the Kafka cluster.
    `at_rest` - The configuration for encryption at rest.
    `in_transit` - The configuration for encryption in transit.
  EOF
  value = {
    at_rest = {
      kms_key = aws_msk_cluster.this.encryption_info.0.encryption_at_rest_kms_key_arn
    }
    in_transit = {
      in_cluster_enabled = aws_msk_cluster.this.encryption_info.0.encryption_in_transit.0.in_cluster
      client_mode        = aws_msk_cluster.this.encryption_info.0.encryption_in_transit.0.client_broker
    }
  }
}

output "logging" {
  description = <<EOF
  A configuration for logging of the Kafka cluster.
    `cloudwatch` - The configuration for MSK broker logs to CloudWatch Logs.
    `firehose` - The configuration for MSK broker logs to Kinesis Firehose.
    `s3` - The configuration for MSK broker logs to S3 Bucket.
  EOF
  value = {
    cloudwatch = {
      enabled   = aws_msk_cluster.this.logging_info.0.broker_logs.0.cloudwatch_logs.0.enabled
      log_group = aws_msk_cluster.this.logging_info.0.broker_logs.0.cloudwatch_logs.0.log_group
    }
    firehose = {
      enabled         = aws_msk_cluster.this.logging_info.0.broker_logs.0.firehose.0.enabled
      delivery_stream = aws_msk_cluster.this.logging_info.0.broker_logs.0.firehose.0.delivery_stream
    }
    s3 = {
      enabled = aws_msk_cluster.this.logging_info.0.broker_logs.0.s3.0.enabled
      bucket  = aws_msk_cluster.this.logging_info.0.broker_logs.0.s3.0.bucket
      prefix  = aws_msk_cluster.this.logging_info.0.broker_logs.0.s3.0.prefix
    }
  }
}

output "monitoring" {
  description = <<EOF
  A configuration for monitoring of the Kafka cluster.
    `cloudwatch` - The configuration for MSK CloudWatch Metrics.
    `prometheus` - The configuration for Prometheus open monitoring.
  EOF
  value = {
    cloudwatch = {
      level = aws_msk_cluster.this.enhanced_monitoring
    }
    prometheus = {
      jmx_exporter_enabled  = aws_msk_cluster.this.open_monitoring.0.prometheus.0.jmx_exporter.0.enabled_in_broker
      node_exporter_enabled = aws_msk_cluster.this.open_monitoring.0.prometheus.0.node_exporter.0.enabled_in_broker
    }
  }
}

output "bootstrap_brokers" {
  description = <<EOF
  A configuration for connecting to the Kafka cluster.
    `plaintext` - A comma separated list of one or more hostname:port pairs of kafka brokers suitable to boostrap connectivity to the kafka cluster. Only contains value if `client_encryption_in_transit_mode` is set to PLAINTEXT or TLS_PLAINTEXT. AWS may not always return all endpoints so the values may not be stable across applies.
    `sasl_iam` - A comma separated list of one or more DNS names (or IPs) and SASL IAM port pairs. Only contains value if `client_encryption_in_transit_mode` is set to TLS_PLAINTEXT or TLS. AWS may not always return all endpoints so the values may not be stable across applies.
    `sasl_scram` - A comma separated list of one or more DNS names (or IPs) and SASL SCRAM port pairs. Only contains value if `client_encryption_in_transit_mode` is set to TLS_PLAINTEXT or TLS. AWS may not always return all endpoints so the values may not be stable across applies.
    `tls` - A comma separated list of one or more DNS names (or IPs) and TLS port pairs kafka brokers suitable to boostrap connectivity to the kafka cluster. Only contains value if `client_encryption_in_transit_mode is set to TLS_PLAINTEXT or TLS. AWS may not always return all endpoints so the values may not be stable across applies.
    `public_sasl_iam` - A comma separated list of one or more DNS names (or IPs) and SASL IAM port pairs. Only contains value if `client_encryption_in_transit_mode` is set to TLS_PLAINTEXT or TLS and `auth_sasl_iam_enabled` is `true` and `broker_public_access_enabled` is `true`. AWS may not always return all endpoints so the values may not be stable across applies.
    `public_sasl_scram` - A comma separated list of one or more DNS names (or IPs) and SASL SCRAM port pairs. Only contains value if `client_encryption_in_transit_mode` is set to TLS_PLAINTEXT or TLS and `auth_sasl_scram_enabled` is `true` and `broker_public_access_enabled` is `true`. AWS may not always return all endpoints so the values may not be stable across applies.
    `public_tls` - A comma separated list of one or more DNS names (or IPs) and TLS port pairs. Only contains value if `client_encryption_in_transit_mode` is set to TLS_PLAINTEXT or TLS and `broker_public_access_enabled` is `true`. AWS may not always return all endpoints so the values may not be stable across applies.
  EOF
  value = {
    plaintext  = aws_msk_cluster.this.bootstrap_brokers
    sasl_iam   = aws_msk_cluster.this.bootstrap_brokers_sasl_iam
    sasl_scram = aws_msk_cluster.this.bootstrap_brokers_sasl_scram
    tls        = aws_msk_cluster.this.bootstrap_brokers_tls

    public_sasl_iam   = aws_msk_cluster.this.bootstrap_brokers_public_sasl_iam
    public_sasl_scram = aws_msk_cluster.this.bootstrap_brokers_public_sasl_scram
    public_tls        = aws_msk_cluster.this.bootstrap_brokers_public_tls
  }
}

output "zookeeper_connections" {
  description = <<EOF
  A configuration for connecting to the Apache Zookeeper cluster.
    `tcp` - A comma separated list of one or more IP:port pairs to use to connect to the Apache Zookeeper cluster.
    `tls` - A comma separated list of one or more IP:port pairs to use to connect to the Apache Zookeeper cluster via TLS.
  EOF
  value = {
    tcp = aws_msk_cluster.this.zookeeper_connect_string
    tls = aws_msk_cluster.this.zookeeper_connect_string_tls
  }
}
