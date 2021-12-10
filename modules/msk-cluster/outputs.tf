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

output "kafka_config_arn" {
  description = "The ARN of the MSK configuration."
  value       = aws_msk_configuration.this.arn
}

output "kafka_config" {
  description = "Contents of the MSK configuration."
  value       = aws_msk_configuration.this.server_properties
}

output "broker_size" {
  description = "The number of broker nodes in the kafka cluster."
  value       = aws_msk_cluster.this.number_of_broker_nodes
}

output "broker_instance_type" {
  description = "The instance type used by the kafka brokers."
  value       = aws_msk_cluster.this.broker_node_group_info.0.instance_type
}

output "broker_volume_size" {
  description = "The EBS volume size in GiB on each broker node."
  value       = aws_msk_cluster.this.broker_node_group_info.0.ebs_volume_size
}

output "broker_security_group_id" {
  description = "The id of security group that were created for the MSK cluster."
  value       = try(module.security_group.*.id[0], null)
}

output "broker_nodes" {
  description = "The information of broker nodes in the kafka cluster."
  value       = data.aws_msk_broker_nodes.this.node_info_list
}

output "bootstrap_brokers" {
  description = "A comma separated list of one or more hostname:port pairs of kafka brokers suitable to boostrap connectivity to the kafka cluster. Only contains value if `client_encryption_in_transit_mode` is set to PLAINTEXT or TLS_PLAINTEXT. AWS may not always return all endpoints so the values may not be stable across applies."
  value       = aws_msk_cluster.this.bootstrap_brokers
}

output "bootstrap_brokers_tls" {
  description = "A comma separated list of one or more DNS names (or IPs) and TLS port pairs kafka brokers suitable to boostrap connectivity to the kafka cluster. Only contains value if `client_encryption_in_transit_mode is set to TLS_PLAINTEXT or TLS. AWS may not always return all endpoints so the values may not be stable across applies."
  value       = aws_msk_cluster.this.bootstrap_brokers_tls
}

output "bootstrap_brokers_sasl_iam" {
  description = "A comma separated list of one or more DNS names (or IPs) and SASL IAM port pairs. Only contains value if `client_encryption_in_transit_mode` is set to TLS_PLAINTEXT or TLS. AWS may not always return all endpoints so the values may not be stable across applies."
  value       = aws_msk_cluster.this.bootstrap_brokers_sasl_iam
}

output "bootstrap_brokers_sasl_scram" {
  description = "A comma separated list of one or more DNS names (or IPs) and SASL SCRAM port pairs. Only contains value if `client_encryption_in_transit_mode` is set to TLS_PLAINTEXT or TLS. AWS may not always return all endpoints so the values may not be stable across applies."
  value       = aws_msk_cluster.this.bootstrap_brokers_sasl_scram
}

output "encryption_at_rest_kms_key_arn" {
  description = "The ARN of the KMS key used for encryption at rest of the broker data volumes."
  value       = aws_msk_cluster.this.encryption_info.0.encryption_at_rest_kms_key_arn
}

output "zookeeper_connections" {
  description = "A comma separated list of one or more IP:port pairs to use to connect to the Apache Zookeeper cluster."
  value       = aws_msk_cluster.this.zookeeper_connect_string
}

output "zookeeper_connections_tls" {
  description = "A comma separated list of one or more IP:port pairs to use to connect to the Apache Zookeeper cluster via TLS."
  value       = aws_msk_cluster.this.zookeeper_connect_string_tls
}
