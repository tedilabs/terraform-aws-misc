locals {
  metadata = {
    package = "terraform-aws-misc"
    version = trimspace(file("${path.module}/../../VERSION"))
    module  = basename(path.module)
    name    = var.name
  }
  module_tags = var.module_tags_enabled ? {
    "module.terraform.io/package"   = local.metadata.package
    "module.terraform.io/version"   = local.metadata.version
    "module.terraform.io/name"      = local.metadata.module
    "module.terraform.io/full-name" = "${local.metadata.package}/${local.metadata.module}"
    "module.terraform.io/instance"  = local.metadata.name
  } : {}
}


###################################################
# MSK Resources
###################################################

resource "aws_msk_configuration" "this" {
  name           = "${var.name}-${md5(var.kafka_config)}"
  description    = "Configuration for ${var.name} Kafka Cluster."
  kafka_versions = [var.kafka_version]

  server_properties = var.kafka_config
}

resource "aws_msk_cluster" "this" {
  cluster_name           = var.name
  kafka_version          = var.kafka_version
  number_of_broker_nodes = var.broker_size

  enhanced_monitoring = var.monitoring_cloudwatch_level

  broker_node_group_info {
    instance_type   = var.broker_instance_type
    ebs_volume_size = var.broker_volume_size
    az_distribution = "DEFAULT"
    client_subnets  = var.broker_subnets
    security_groups = concat(
      module.security_group.*.id,
      var.broker_additional_security_groups
    )
  }

  configuration_info {
    arn      = aws_msk_configuration.this.arn
    revision = aws_msk_configuration.this.latest_revision
  }

  encryption_info {
    encryption_at_rest_kms_key_arn = var.encryption_at_rest_kms_key_arn

    encryption_in_transit {
      in_cluster    = var.encryption_in_transit_in_cluster_enabled
      client_broker = var.encryption_in_transit_client_mode
    }
  }

  dynamic "client_authentication" {
    for_each = try(var.auth_sasl_iam_enabled || var.auth_sasl_scram_enabled, false) ? ["go"] : []

    content {
      sasl {
        iam   = var.auth_sasl_iam_enabled
        scram = var.auth_sasl_scram_enabled
      }
    }
  }

  dynamic "client_authentication" {
    for_each = try(length(var.auth_tls_acm_ca_arns) > 0, false) ? ["go"] : []

    content {
      tls {
        certificate_authority_arns = var.auth_tls_acm_ca_arns
      }
    }
  }

  logging_info {
    broker_logs {
      cloudwatch_logs {
        enabled   = var.logging_cloudwatch_enabled
        log_group = var.logging_cloudwatch_log_group
      }
      firehose {
        enabled         = var.logging_firehose_enabled
        delivery_stream = var.logging_firehose_delivery_stream
      }
      s3 {
        enabled = var.logging_s3_enabled
        bucket  = var.logging_s3_bucket
        prefix  = var.logging_s3_prefix
      }
    }
  }

  open_monitoring {
    prometheus {
      jmx_exporter {
        enabled_in_broker = var.monitoring_prometheus_jmx_exporter_enabled
      }

      node_exporter {
        enabled_in_broker = var.monitoring_prometheus_node_exporter_enabled
      }
    }
  }

  tags = merge(
    {
      "Name" = local.metadata.name
    },
    local.module_tags,
    var.tags,
  )
}

data "aws_msk_broker_nodes" "this" {
  cluster_arn = aws_msk_cluster.this.arn
}
