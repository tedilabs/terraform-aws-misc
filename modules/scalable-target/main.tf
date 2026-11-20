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

locals {
  policy_names = concat(
    var.target_tracking_policies[*].name,
    var.step_scaling_policies[*].name,
    var.predictive_scaling_policies[*].name,
  )
}


###################################################
# Scalable Target
###################################################

resource "aws_appautoscaling_target" "this" {
  region = var.region

  service_namespace  = var.service_namespace
  resource_id        = var.resource_id
  scalable_dimension = var.scalable_dimension

  min_capacity = var.min_capacity
  max_capacity = var.max_capacity

  role_arn = var.role_arn

  suspended_state {
    dynamic_scaling_in_suspended  = var.suspension.scale_in
    dynamic_scaling_out_suspended = var.suspension.scale_out
    scheduled_scaling_suspended   = var.suspension.scheduled_scaling
  }

  tags = merge(
    {
      "Name" = local.metadata.name
    },
    local.module_tags,
    var.tags,
  )

  lifecycle {
    precondition {
      condition     = length(local.policy_names) == length(distinct(local.policy_names))
      error_message = "The names of `target_tracking_policies`, `step_scaling_policies` and `predictive_scaling_policies` must be unique across all of them."
    }
  }
}


###################################################
# Target Tracking Scaling Policies
###################################################

resource "aws_appautoscaling_policy" "target_tracking" {
  for_each = {
    for policy in var.target_tracking_policies :
    policy.name => policy
  }

  region = aws_appautoscaling_target.this.region

  name               = each.key
  policy_type        = "TargetTrackingScaling"
  service_namespace  = aws_appautoscaling_target.this.service_namespace
  resource_id        = aws_appautoscaling_target.this.resource_id
  scalable_dimension = aws_appautoscaling_target.this.scalable_dimension

  target_tracking_scaling_policy_configuration {
    target_value       = each.value.target_value
    disable_scale_in   = !each.value.scale_in_enabled
    scale_in_cooldown  = each.value.scale_in_cooldown
    scale_out_cooldown = each.value.scale_out_cooldown

    dynamic "predefined_metric_specification" {
      for_each = each.value.predefined_metric != null ? [each.value.predefined_metric] : []
      iterator = metric

      content {
        predefined_metric_type = metric.value.type
        resource_label         = metric.value.resource_label
      }
    }

    dynamic "customized_metric_specification" {
      for_each = each.value.custom_metric != null ? [each.value.custom_metric] : []
      iterator = metric

      content {
        namespace   = metric.value.namespace
        metric_name = metric.value.name
        statistic   = metric.value.statistic
        unit        = metric.value.unit

        dynamic "dimensions" {
          for_each = metric.value.dimensions

          content {
            name  = dimensions.key
            value = dimensions.value
          }
        }
      }
    }
  }
}


###################################################
# Step Scaling Policies
###################################################

resource "aws_appautoscaling_policy" "step" {
  for_each = {
    for policy in var.step_scaling_policies :
    policy.name => policy
  }

  region = aws_appautoscaling_target.this.region

  name               = each.key
  policy_type        = "StepScaling"
  service_namespace  = aws_appautoscaling_target.this.service_namespace
  resource_id        = aws_appautoscaling_target.this.resource_id
  scalable_dimension = aws_appautoscaling_target.this.scalable_dimension

  step_scaling_policy_configuration {
    adjustment_type          = each.value.adjustment_type
    cooldown                 = each.value.cooldown
    metric_aggregation_type  = each.value.metric_aggregation_type
    min_adjustment_magnitude = each.value.min_adjustment_magnitude

    dynamic "step_adjustment" {
      for_each = each.value.steps
      iterator = step

      content {
        metric_interval_lower_bound = step.value.lower_bound
        metric_interval_upper_bound = step.value.upper_bound
        scaling_adjustment          = step.value.adjustment
      }
    }
  }
}


###################################################
# Predictive Scaling Policies
###################################################

resource "aws_appautoscaling_policy" "predictive" {
  for_each = {
    for policy in var.predictive_scaling_policies :
    policy.name => policy
  }

  region = aws_appautoscaling_target.this.region

  name               = each.key
  policy_type        = "PredictiveScaling"
  service_namespace  = aws_appautoscaling_target.this.service_namespace
  resource_id        = aws_appautoscaling_target.this.resource_id
  scalable_dimension = aws_appautoscaling_target.this.scalable_dimension

  predictive_scaling_policy_configuration {
    mode                         = each.value.mode
    scheduling_buffer_time       = each.value.scheduling_buffer_time
    max_capacity_breach_behavior = each.value.max_capacity_breach_behavior
    max_capacity_buffer          = each.value.max_capacity_buffer

    dynamic "metric_specification" {
      for_each = each.value.metrics
      iterator = metric

      content {
        target_value = metric.value.target_value

        predefined_metric_pair_specification {
          predefined_metric_type = metric.value.type
          resource_label         = metric.value.resource_label
        }
      }
    }
  }
}


###################################################
# Scheduled Actions
###################################################

resource "aws_appautoscaling_scheduled_action" "this" {
  for_each = {
    for action in var.scheduled_actions :
    action.name => action
  }

  region = aws_appautoscaling_target.this.region

  name               = each.key
  service_namespace  = aws_appautoscaling_target.this.service_namespace
  resource_id        = aws_appautoscaling_target.this.resource_id
  scalable_dimension = aws_appautoscaling_target.this.scalable_dimension

  schedule   = each.value.schedule
  timezone   = each.value.timezone
  start_time = each.value.start_time
  end_time   = each.value.end_time

  scalable_target_action {
    min_capacity = each.value.min_capacity
    max_capacity = each.value.max_capacity
  }
}
