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
# Configuration for MSK Cluster
###################################################

locals {
  server_properties = <<EOT
%{for k, v in var.kafka_server_properties~}
${k} = ${v}
%{endfor~}
EOT
}

resource "aws_msk_configuration" "this" {
  name           = var.name
  description    = "Configuration for ${var.name} Kafka Cluster."
  kafka_versions = [var.kafka_version]

  server_properties = local.server_properties

  lifecycle {
    create_before_destroy = true
  }
}


###################################################
# MSK Cluster
###################################################

# TODO: public access cidrs
resource "aws_msk_cluster" "this" {
  cluster_name           = var.name
  kafka_version          = var.kafka_version
  number_of_broker_nodes = var.broker_size

  broker_node_group_info {
    instance_type   = var.broker_instance_type
    az_distribution = "DEFAULT"
    client_subnets  = var.broker_subnets
    security_groups = concat(
      module.security_group.*.id,
      var.broker_additional_security_groups
    )

    connectivity_info {
      public_access {
        type = var.broker_public_access_enabled ? "SERVICE_PROVIDED_EIPS" : "DISABLED"
      }
    }

    storage_info {
      ebs_storage_info {
        volume_size = var.broker_volume_size

        dynamic "provisioned_throughput" {
          for_each = var.broker_volume_provisioned_throughput_enabled ? ["go"] : []

          content {
            enabled           = true
            volume_throughput = var.broker_volume_provisioned_throughput
          }
        }
      }
    }
  }

  configuration_info {
    arn      = aws_msk_configuration.this.arn
    revision = aws_msk_configuration.this.latest_revision
  }


  ## Auth
  client_authentication {
    unauthenticated = var.auth_unauthenticated_access_enabled

    sasl {
      iam   = var.auth_sasl_iam_enabled
      scram = var.auth_sasl_scram_enabled
    }

    dynamic "tls" {
      for_each = var.auth_tls_enabled ? ["go"] : []

      content {
        certificate_authority_arns = var.auth_tls_acm_ca_arns
      }
    }
  }


  ## Encryption
  encryption_info {
    encryption_at_rest_kms_key_arn = var.encryption_at_rest_kms_key

    encryption_in_transit {
      in_cluster    = var.encryption_in_transit_in_cluster_enabled
      client_broker = var.encryption_in_transit_client_mode
    }
  }


  ## Logging
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


  ## Monitoring
  enhanced_monitoring = var.monitoring_cloudwatch_level

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

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
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
