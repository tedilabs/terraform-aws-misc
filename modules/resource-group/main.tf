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
# Resource Group
###################################################

locals {
  filters = [
    for key, value in var.query.resource_tags : {
      "Key"    = key
      "Values" = flatten([value])
    }
  ]
  query = <<-JSON
  {
    "ResourceTypeFilters": ${jsonencode(var.query.resource_types)},
    "TagFilters": ${jsonencode(local.filters)}
  }
  JSON
}

resource "aws_resourcegroups_group" "this" {
  region = var.region

  name        = var.name
  description = var.description

  resource_query {
    type  = "TAG_FILTERS_1_0"
    query = local.query
  }

  tags = merge(
    {
      "Name" = var.name
    },
    local.module_tags,
    var.tags,
  )
}
