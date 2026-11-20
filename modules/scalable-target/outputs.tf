output "region" {
  description = "The AWS region this module resources resides in."
  value       = aws_appautoscaling_target.this.region
}

output "arn" {
  description = "The ARN of the scalable target."
  value       = aws_appautoscaling_target.this.arn
}

output "id" {
  description = "The ID of the scalable target."
  value       = aws_appautoscaling_target.this.id
}

output "name" {
  description = "The name to identify the scalable target."
  value       = local.metadata.name
}

output "service_namespace" {
  description = "The namespace of the AWS service that provides the resource."
  value       = aws_appautoscaling_target.this.service_namespace
}

output "resource_id" {
  description = "The identifier of the resource associated with the scalable target."
  value       = aws_appautoscaling_target.this.resource_id
}

output "scalable_dimension" {
  description = "The scalable dimension of the scalable target."
  value       = aws_appautoscaling_target.this.scalable_dimension
}

output "min_capacity" {
  description = "The minimum capacity of the scalable target."
  value       = aws_appautoscaling_target.this.min_capacity
}

output "max_capacity" {
  description = "The maximum capacity of the scalable target."
  value       = aws_appautoscaling_target.this.max_capacity
}

output "role_arn" {
  description = "The ARN of the IAM role that allows Application Auto Scaling to modify the scalable target."
  value       = aws_appautoscaling_target.this.role_arn
}

output "suspension" {
  description = "The configuration to suspend the scaling activities of the scalable target."
  value = {
    scale_in          = one(aws_appautoscaling_target.this.suspended_state[*].dynamic_scaling_in_suspended)
    scale_out         = one(aws_appautoscaling_target.this.suspended_state[*].dynamic_scaling_out_suspended)
    scheduled_scaling = one(aws_appautoscaling_target.this.suspended_state[*].scheduled_scaling_suspended)
  }
}

output "target_tracking_policies" {
  description = "A map of the target tracking scaling policies for the scalable target. Each key is the name of the policy."
  value = {
    for name, policy in aws_appautoscaling_policy.target_tracking :
    name => {
      arn          = policy.arn
      name         = policy.name
      alarms       = policy.alarm_arns
      target_value = policy.target_tracking_scaling_policy_configuration[0].target_value
      predefined_metric = (length(policy.target_tracking_scaling_policy_configuration[0].predefined_metric_specification) > 0
        ? {
          type           = policy.target_tracking_scaling_policy_configuration[0].predefined_metric_specification[0].predefined_metric_type
          resource_label = policy.target_tracking_scaling_policy_configuration[0].predefined_metric_specification[0].resource_label
        }
        : null
      )
      custom_metric = (length(policy.target_tracking_scaling_policy_configuration[0].customized_metric_specification) > 0
        ? {
          namespace = policy.target_tracking_scaling_policy_configuration[0].customized_metric_specification[0].namespace
          name      = policy.target_tracking_scaling_policy_configuration[0].customized_metric_specification[0].metric_name
          dimensions = {
            for dimension in policy.target_tracking_scaling_policy_configuration[0].customized_metric_specification[0].dimensions :
            dimension.name => dimension.value
          }
          statistic = policy.target_tracking_scaling_policy_configuration[0].customized_metric_specification[0].statistic
          unit      = policy.target_tracking_scaling_policy_configuration[0].customized_metric_specification[0].unit
        }
        : null
      )
      scale_in_enabled   = !policy.target_tracking_scaling_policy_configuration[0].disable_scale_in
      scale_in_cooldown  = policy.target_tracking_scaling_policy_configuration[0].scale_in_cooldown
      scale_out_cooldown = policy.target_tracking_scaling_policy_configuration[0].scale_out_cooldown
    }
  }
}

output "step_scaling_policies" {
  description = "A map of the step scaling policies for the scalable target. Each key is the name of the policy. Use `arn` as an action of the CloudWatch alarm that invokes the policy."
  value = {
    for name, policy in aws_appautoscaling_policy.step :
    name => {
      arn             = policy.arn
      name            = policy.name
      adjustment_type = policy.step_scaling_policy_configuration[0].adjustment_type
      steps = [
        for step in policy.step_scaling_policy_configuration[0].step_adjustment : {
          lower_bound = try(tonumber(step.metric_interval_lower_bound), null)
          upper_bound = try(tonumber(step.metric_interval_upper_bound), null)
          adjustment  = step.scaling_adjustment
        }
      ]
      cooldown                 = policy.step_scaling_policy_configuration[0].cooldown
      metric_aggregation_type  = policy.step_scaling_policy_configuration[0].metric_aggregation_type
      min_adjustment_magnitude = policy.step_scaling_policy_configuration[0].min_adjustment_magnitude
    }
  }
}

output "predictive_scaling_policies" {
  description = "A map of the predictive scaling policies for the scalable target. Each key is the name of the policy."
  value = {
    for name, policy in aws_appautoscaling_policy.predictive :
    name => {
      arn  = policy.arn
      name = policy.name
      metrics = [
        for metric in policy.predictive_scaling_policy_configuration[0].metric_specification : {
          type           = metric.predefined_metric_pair_specification[0].predefined_metric_type
          target_value   = tonumber(metric.target_value)
          resource_label = metric.predefined_metric_pair_specification[0].resource_label
        }
      ]
      mode                         = policy.predictive_scaling_policy_configuration[0].mode
      scheduling_buffer_time       = policy.predictive_scaling_policy_configuration[0].scheduling_buffer_time
      max_capacity_breach_behavior = policy.predictive_scaling_policy_configuration[0].max_capacity_breach_behavior
      max_capacity_buffer          = policy.predictive_scaling_policy_configuration[0].max_capacity_buffer
    }
  }
}

output "scheduled_actions" {
  description = "A map of the scheduled actions for the scalable target. Each key is the name of the scheduled action."
  value = {
    for name, action in aws_appautoscaling_scheduled_action.this :
    name => {
      arn          = action.arn
      name         = action.name
      schedule     = action.schedule
      timezone     = action.timezone
      start_time   = action.start_time
      end_time     = action.end_time
      min_capacity = try(tonumber(action.scalable_target_action[0].min_capacity), null)
      max_capacity = try(tonumber(action.scalable_target_action[0].max_capacity), null)
    }
  }
}

output "resource_group" {
  description = "The resource group created to manage resources in this module."
  value = merge(
    {
      enabled = var.resource_group.enabled && var.module_tags_enabled
    },
    (var.resource_group.enabled && var.module_tags_enabled
      ? {
        arn  = module.resource_group[0].arn
        name = module.resource_group[0].name
      }
      : {}
    )
  )
}
