resource "random_password" "this" {
  for_each = var.auth_sasl_scram_users

  length = 16

  min_lower   = 2
  min_upper   = 1
  min_numeric = 2
  min_special = 1

  override_special = "!#$%&*()-=<>:"
}


###################################################
# SASL/SCRAM User & Password for MSK Cluster
###################################################

# TODO: Create an independant module for msk-scram-users
module "secret" {
  source  = "tedilabs/secret/aws//modules/secrets-manager-secret"
  version = "~> 0.2.0"

  for_each = var.auth_sasl_scram_users

  name        = "AmazonMSK_SCRAM/${var.name}/${each.key}"
  description = "The SASL/SCRAM secret to provide username and password for MSK cluster authenticaiton."

  type = "KEY_VALUE"
  value = {
    username = each.key
    password = random_password.this[each.key].result
  }

  kms_key             = var.auth_sasl_scram_kms_key
  policy              = null
  block_public_policy = true

  deletion_window_in_days = 7

  resource_group_enabled = false
  module_tags_enabled    = false

  tags = merge(
    local.module_tags,
    var.tags,
  )
}

resource "aws_msk_scram_secret_association" "this" {
  count = length(module.secret) > 0 ? 1 : 0

  cluster_arn     = aws_msk_cluster.this.arn
  secret_arn_list = values(module.secret).*.arn
}
