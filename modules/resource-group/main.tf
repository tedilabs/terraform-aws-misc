locals {
  metadata = {
    package = "terraform-aws-misc"
    version = trimspace(file("${path.module}/../../VERSION"))
    module  = basename(path.module)
    name    = var.name
  }
  module_tags = {
    "module.terraform.io/package"   = local.metadata.package
    "module.terraform.io/version"   = local.metadata.version
    "module.terraform.io/name"      = local.metadata.module
    "module.terraform.io/full-name" = "${local.metadata.package}/${local.metadata.module}"
    "module.terraform.io/instance"  = local.metadata.name
  }
}


###################################################
# Resource Group
###################################################

locals {
  filters = [
    for key, value in try(var.query.resource_tags, {}) : {
      "Key"    = key
      "Values" = flatten([value])
    }
  ]
  query = <<-JSON
  {
    "ResourceTypeFilters": ${jsonencode(try(var.query.resource_types, ["AWS::AllSupported"]))},
    "TagFilters": ${jsonencode(local.filters)}
  }
  JSON
}

resource "aws_resourcegroups_group" "this" {
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
    var.module_tags_enabled ? local.module_tags : {},
    var.tags,
  )
}
