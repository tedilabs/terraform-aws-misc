data "aws_subnet" "this" {
  id = var.broker_subnets[0]
}

locals {
  vpc_id = data.aws_subnet.this.vpc_id
}


###################################################
# Security Group
###################################################

module "security_group" {
  source  = "tedilabs/network/aws//modules/security-group"
  version = "0.24.0"

  count = length(var.broker_allowed_ingress_cidrs) > 0 ? 1 : 0

  name        = var.name
  description = "Security group for MSK Cluster."
  vpc_id      = local.vpc_id

  ingress_rules = [
    {
      id          = "broker-plaintext/cidrs"
      description = "Allow CIDRs to communicate with Kafka brokers in plaintext."
      protocol    = "tcp"
      from_port   = 9092
      to_port     = 9092

      cidr_blocks = var.broker_allowed_ingress_cidrs
    },
    {
      id          = "broker-tls/cidrs"
      description = "Allow CIDRs to communicate with Kafka brokers in tls."
      protocol    = "tcp"
      from_port   = 9094
      to_port     = 9094

      cidr_blocks = var.broker_allowed_ingress_cidrs
    },
    {
      id          = "broker-sasl-scram/cidrs"
      description = "Allow CIDRs to communicate with Kafka brokers in SASL SCRAM."
      protocol    = "tcp"
      from_port   = 9096
      to_port     = 9096

      cidr_blocks = var.broker_allowed_ingress_cidrs
    },
    {
      id          = "broker-sasl-iam/cidrs"
      description = "Allow CIDRs to communicate with Kafka brokers in SASL IAM."
      protocol    = "tcp"
      from_port   = 9098
      to_port     = 9098

      cidr_blocks = var.broker_allowed_ingress_cidrs
    },
    {
      id          = "zookeeper/cidrs"
      description = "Allow CIDRs to communicate with Kafka zookeepers."
      protocol    = "tcp"
      from_port   = 2181
      to_port     = 2181

      cidr_blocks = var.broker_allowed_ingress_cidrs
    },
    {
      id          = "prometheus-jmx-exporter/cidrs"
      description = "Allow CIDRs to communicate with Prometheus JMX Exporter."
      protocol    = "tcp"
      from_port   = 11001
      to_port     = 11001

      cidr_blocks = var.broker_allowed_ingress_cidrs
    },
    {
      id          = "prometheus-node-exporter/cidrs"
      description = "Allow CIDRs to communicate with Prometheus Node Exporter."
      protocol    = "tcp"
      from_port   = 11002
      to_port     = 11002

      cidr_blocks = var.broker_allowed_ingress_cidrs
    },
  ]

  resource_group_enabled = false
  module_tags_enabled    = false

  tags = merge(
    local.module_tags,
    var.tags,
  )
}
