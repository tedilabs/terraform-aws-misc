variable "region" {
  description = "(Optional) The region in which to create the module resources. If not provided, the module resources will be created in the provider's configured region."
  type        = string
  default     = null
  nullable    = true
}

variable "name" {
  description = "(Required) A name to identify the scalable target. Used for the `Name` tag of the scalable target and the name of the resource group. It does not need to be unique and is not sent to Application Auto Scaling."
  type        = string
  nullable    = false
}

variable "service_namespace" {
  description = "(Required) The namespace of the AWS service that provides the resource. Valid values are `appstream`, `cassandra`, `comprehend`, `custom-resource`, `dynamodb`, `ec2`, `ecs`, `elasticache`, `elasticmapreduce`, `kafka`, `lambda`, `neptune`, `rds`, `sagemaker`, `workspaces`."
  type        = string
  nullable    = false

  validation {
    condition = contains([
      "appstream",
      "cassandra",
      "comprehend",
      "custom-resource",
      "dynamodb",
      "ec2",
      "ecs",
      "elasticache",
      "elasticmapreduce",
      "kafka",
      "lambda",
      "neptune",
      "rds",
      "sagemaker",
      "workspaces",
    ], var.service_namespace)
    error_message = "Valid values for `service_namespace` are `appstream`, `cassandra`, `comprehend`, `custom-resource`, `dynamodb`, `ec2`, `ecs`, `elasticache`, `elasticmapreduce`, `kafka`, `lambda`, `neptune`, `rds`, `sagemaker`, `workspaces`."
  }
}

variable "resource_id" {
  description = "(Required) The identifier of the resource associated with the scalable target. The format depends on the service. For example, `service/{cluster-name}/{service-name}` for an ECS service, `table/{table-name}` for a DynamoDB table, `cluster:{cluster-name}` for an Aurora DB cluster, `function:{function-name}:{alias}` for a Lambda alias, and the cluster ARN for an MSK cluster."
  type        = string
  nullable    = false
}

variable "scalable_dimension" {
  description = "(Required) The scalable dimension of the scalable target, in the format `{service-namespace}:{resource-type}:{property}`. For example, `ecs:service:DesiredCount`, `dynamodb:table:ReadCapacityUnits`, `rds:cluster:ReadReplicaCount`, `lambda:function:ProvisionedConcurrency` and `kafka:broker-storage:VolumeSize`."
  type        = string
  nullable    = false

  validation {
    condition     = startswith(var.scalable_dimension, "${var.service_namespace}:")
    error_message = "`scalable_dimension` must start with `service_namespace` followed by `:`."
  }
}

variable "min_capacity" {
  description = "(Required) The minimum capacity of the scalable target. Scaling policies do not scale in below this value. When the scalable target is registered or updated, Application Auto Scaling raises the current capacity to this value if it is lower."
  type        = number
  nullable    = false

  validation {
    condition     = var.min_capacity >= 0
    error_message = "`min_capacity` must be greater than or equal to `0`."
  }
}

variable "max_capacity" {
  description = "(Required) The maximum capacity of the scalable target. Scaling policies do not scale out above this value. When the scalable target is registered or updated, Application Auto Scaling lowers the current capacity to this value if it is higher."
  type        = number
  nullable    = false

  validation {
    condition     = var.max_capacity >= var.min_capacity
    error_message = "`max_capacity` must be greater than or equal to `min_capacity`."
  }
}

variable "role_arn" {
  description = "(Optional) The ARN of the IAM role that allows Application Auto Scaling to modify the scalable target on your behalf. Required only for services that do not support service-linked roles, such as Amazon EMR. If not provided, Application Auto Scaling uses the service-linked role for the service and creates it if it does not exist."
  type        = string
  default     = null
  nullable    = true
}

variable "suspension" {
  description = <<EOF
  (Optional) The configuration to suspend the scaling activities of the scalable target. Use it to stop scaling temporarily, for example during a deployment or an incident. `suspension` as defined below.
    (Optional) `scale_in` - Whether to suspend the scale-in activities triggered by scaling policies. Defaults to `false`.
    (Optional) `scale_out` - Whether to suspend the scale-out activities triggered by scaling policies. Defaults to `false`.
    (Optional) `scheduled_scaling` - Whether to suspend the scaling activities of scheduled actions. Defaults to `false`.
  EOF
  type = object({
    scale_in          = optional(bool, false)
    scale_out         = optional(bool, false)
    scheduled_scaling = optional(bool, false)
  })
  default  = {}
  nullable = false
}

variable "target_tracking_policies" {
  description = <<EOF
  (Optional) A list of target tracking scaling policies for the scalable target. A target tracking policy adjusts the capacity in proportion to keep a metric at the target value. Application Auto Scaling creates and manages the CloudWatch alarms of the policy. Each item of `target_tracking_policies` as defined below.
    (Required) `name` - The name of the scaling policy. Must be unique across `target_tracking_policies`, `step_scaling_policies` and `predictive_scaling_policies`.
    (Required) `target_value` - The target value for the metric.
    (Optional) `predefined_metric` - The predefined metric to track. Exactly one of `predefined_metric` or `custom_metric` is required. `predefined_metric` as defined below.
      (Required) `type` - The type of the predefined metric, such as `ECSServiceAverageCPUUtilization`, `ALBRequestCountPerTarget`, `DynamoDBReadCapacityUtilization`, `RDSReaderAverageCPUUtilization` and `KafkaBrokerStorageUtilization`.
      (Optional) `resource_label` - The resource label to identify the target group for `ALBRequestCountPerTarget`, in the format `{load-balancer-arn-suffix}/{target-group-arn-suffix}`.
    (Optional) `custom_metric` - The CloudWatch metric to track. Exactly one of `predefined_metric` or `custom_metric` is required. The metric must change in inverse proportion to the capacity. `custom_metric` as defined below.
      (Required) `namespace` - The namespace of the metric.
      (Required) `name` - The name of the metric.
      (Optional) `dimensions` - A map of the dimensions of the metric. Defaults to `{}`.
      (Optional) `statistic` - The statistic of the metric. Valid values are `Average`, `Minimum`, `Maximum`, `SampleCount` and `Sum`. Defaults to `Average`.
      (Optional) `unit` - The unit of the metric.
    (Optional) `scale_in_enabled` - Whether the policy can scale in. If `false`, the policy only scales out and does not create the alarm for scale-in. Defaults to `true`.
    (Optional) `scale_in_cooldown` - The amount of time, in seconds, after a scale-in activity completes before another scale-in activity can start. If not provided, the default of the service is used.
    (Optional) `scale_out_cooldown` - The amount of time, in seconds, after a scale-out activity completes before another scale-out activity can start. If not provided, the default of the service is used.
  EOF
  type = list(object({
    name         = string
    target_value = number
    predefined_metric = optional(object({
      type           = string
      resource_label = optional(string)
    }))
    custom_metric = optional(object({
      namespace  = string
      name       = string
      dimensions = optional(map(string), {})
      statistic  = optional(string, "Average")
      unit       = optional(string)
    }))
    scale_in_enabled   = optional(bool, true)
    scale_in_cooldown  = optional(number)
    scale_out_cooldown = optional(number)
  }))
  default  = []
  nullable = false

  validation {
    condition = alltrue([
      for policy in var.target_tracking_policies :
      (policy.predefined_metric != null) != (policy.custom_metric != null)
    ])
    error_message = "Each of `target_tracking_policies` requires exactly one of `predefined_metric` or `custom_metric`."
  }
  validation {
    condition = alltrue([
      for policy in var.target_tracking_policies :
      contains(["Average", "Minimum", "Maximum", "SampleCount", "Sum"], policy.custom_metric.statistic)
      if policy.custom_metric != null
    ])
    error_message = "Valid values for `custom_metric.statistic` are `Average`, `Minimum`, `Maximum`, `SampleCount` and `Sum`."
  }
}

variable "step_scaling_policies" {
  description = <<EOF
  (Optional) A list of step scaling policies for the scalable target. A step scaling policy adjusts the capacity by steps that depend on the size of the alarm breach. The policy does nothing until a CloudWatch alarm invokes it; create the alarm outside of this module and set the policy ARN from the `step_scaling_policies` output as an alarm action. Each item of `step_scaling_policies` as defined below.
    (Required) `name` - The name of the scaling policy. Must be unique across `target_tracking_policies`, `step_scaling_policies` and `predictive_scaling_policies`.
    (Required) `adjustment_type` - Whether the adjustment is an absolute number or a percentage of the current capacity. Valid values are `ChangeInCapacity`, `ExactCapacity` and `PercentChangeInCapacity`.
    (Required) `steps` - A list of the step adjustments. The bounds are relative to the alarm threshold. Each item of `steps` as defined below.
      (Optional) `lower_bound` - The lower bound of the metric interval, inclusive. If not provided, the interval has no lower bound.
      (Optional) `upper_bound` - The upper bound of the metric interval, exclusive. If not provided, the interval has no upper bound.
      (Required) `adjustment` - The amount to scale by when the metric is within the interval. A positive value scales out, and a negative value scales in.
    (Optional) `cooldown` - The amount of time, in seconds, after a scaling activity completes before another scaling activity can start. If not provided, the default of the service is used.
    (Optional) `metric_aggregation_type` - The aggregation type of the metric. Valid values are `Average`, `Minimum` and `Maximum`. Defaults to `Average`.
    (Optional) `min_adjustment_magnitude` - The minimum number to adjust the capacity by when `adjustment_type` is `PercentChangeInCapacity`.
  EOF
  type = list(object({
    name            = string
    adjustment_type = string
    steps = list(object({
      lower_bound = optional(number)
      upper_bound = optional(number)
      adjustment  = number
    }))
    cooldown                 = optional(number)
    metric_aggregation_type  = optional(string, "Average")
    min_adjustment_magnitude = optional(number)
  }))
  default  = []
  nullable = false

  validation {
    condition = alltrue([
      for policy in var.step_scaling_policies :
      contains(["ChangeInCapacity", "ExactCapacity", "PercentChangeInCapacity"], policy.adjustment_type)
    ])
    error_message = "Valid values for `adjustment_type` are `ChangeInCapacity`, `ExactCapacity` and `PercentChangeInCapacity`."
  }
  validation {
    condition = alltrue([
      for policy in var.step_scaling_policies :
      length(policy.steps) > 0
    ])
    error_message = "Each of `step_scaling_policies` requires at least one item in `steps`."
  }
  validation {
    condition = alltrue([
      for policy in var.step_scaling_policies :
      contains(["Average", "Minimum", "Maximum"], policy.metric_aggregation_type)
    ])
    error_message = "Valid values for `metric_aggregation_type` are `Average`, `Minimum` and `Maximum`."
  }
}

variable "predictive_scaling_policies" {
  description = <<EOF
  (Optional) A list of predictive scaling policies for the scalable target. A predictive scaling policy forecasts the load from the metric history and scales out ahead of it. Only supported by some services, such as ECS services. Each item of `predictive_scaling_policies` as defined below.
    (Required) `name` - The name of the scaling policy. Must be unique across `target_tracking_policies`, `step_scaling_policies` and `predictive_scaling_policies`.
    (Required) `metrics` - A list of the predefined metric pairs to forecast and scale on. Each item of `metrics` as defined below.
      (Required) `type` - The type of the predefined metric pair, such as `ECSServiceCPUUtilization` and `ECSServiceMemoryUtilization`.
      (Required) `target_value` - The target value for the metric.
      (Optional) `resource_label` - The resource label to identify the target group for `ALBRequestCount`.
    (Optional) `mode` - The mode of the predictive scaling policy. Valid values are `ForecastOnly` and `ForecastAndScale`. Start with `ForecastOnly` to evaluate the forecast before it scales the capacity. Defaults to `ForecastOnly`.
    (Optional) `scheduling_buffer_time` - The amount of time, in seconds, to scale out ahead of the forecast. If not provided, the default of the service is used.
    (Optional) `max_capacity_breach_behavior` - The behavior when the forecast capacity exceeds `max_capacity`. Valid values are `HonorMaxCapacity` and `IncreaseMaxCapacity`. Defaults to `HonorMaxCapacity`.
    (Optional) `max_capacity_buffer` - The size, in percent of the forecast capacity, of the capacity buffer above `max_capacity` when `max_capacity_breach_behavior` is `IncreaseMaxCapacity`.
  EOF
  type = list(object({
    name = string
    metrics = list(object({
      type           = string
      target_value   = number
      resource_label = optional(string)
    }))
    mode                         = optional(string, "ForecastOnly")
    scheduling_buffer_time       = optional(number)
    max_capacity_breach_behavior = optional(string, "HonorMaxCapacity")
    max_capacity_buffer          = optional(number)
  }))
  default  = []
  nullable = false

  validation {
    condition = alltrue([
      for policy in var.predictive_scaling_policies :
      length(policy.metrics) > 0
    ])
    error_message = "Each of `predictive_scaling_policies` requires at least one item in `metrics`."
  }
  validation {
    condition = alltrue([
      for policy in var.predictive_scaling_policies :
      contains(["ForecastOnly", "ForecastAndScale"], policy.mode)
    ])
    error_message = "Valid values for `mode` are `ForecastOnly` and `ForecastAndScale`."
  }
  validation {
    condition = alltrue([
      for policy in var.predictive_scaling_policies :
      contains(["HonorMaxCapacity", "IncreaseMaxCapacity"], policy.max_capacity_breach_behavior)
    ])
    error_message = "Valid values for `max_capacity_breach_behavior` are `HonorMaxCapacity` and `IncreaseMaxCapacity`."
  }
}

variable "scheduled_actions" {
  description = <<EOF
  (Optional) A list of scheduled actions for the scalable target. A scheduled action changes `min_capacity` and `max_capacity` of the scalable target at the scheduled time, and scaling policies keep working within the new range. Terraform reverts the range changed by a scheduled action to `min_capacity` and `max_capacity` of this module on the next apply. Each item of `scheduled_actions` as defined below.
    (Required) `name` - The name of the scheduled action. Must be unique in `scheduled_actions`.
    (Required) `schedule` - The schedule of the action. Supports `at(yyyy-mm-ddThh:mm:ss)` for a one-time action, `rate(value unit)` and `cron(fields)` for a recurring action.
    (Optional) `timezone` - The time zone of `schedule`, `start_time` and `end_time`, such as `Asia/Seoul`. Defaults to `UTC`.
    (Optional) `start_time` - The date and time to start the recurring schedule, in the format `yyyy-mm-ddThh:mm:ssZ`.
    (Optional) `end_time` - The date and time to end the recurring schedule, in the format `yyyy-mm-ddThh:mm:ssZ`.
    (Optional) `min_capacity` - The minimum capacity to set at the scheduled time. At least one of `min_capacity` or `max_capacity` is required.
    (Optional) `max_capacity` - The maximum capacity to set at the scheduled time. At least one of `min_capacity` or `max_capacity` is required.
  EOF
  type = list(object({
    name         = string
    schedule     = string
    timezone     = optional(string, "UTC")
    start_time   = optional(string)
    end_time     = optional(string)
    min_capacity = optional(number)
    max_capacity = optional(number)
  }))
  default  = []
  nullable = false

  validation {
    condition     = length(var.scheduled_actions) == length(distinct(var.scheduled_actions[*].name))
    error_message = "The names of `scheduled_actions` must be unique."
  }
  validation {
    condition = alltrue([
      for action in var.scheduled_actions :
      action.min_capacity != null || action.max_capacity != null
    ])
    error_message = "Each of `scheduled_actions` requires at least one of `min_capacity` or `max_capacity`."
  }
  validation {
    condition = alltrue([
      for action in var.scheduled_actions :
      can(regex("^(at|rate|cron)\\(.+\\)$", action.schedule))
    ])
    error_message = "`schedule` must be an `at()`, `rate()` or `cron()` expression."
  }
}

variable "tags" {
  description = "(Optional) A map of tags to add to all resources."
  type        = map(string)
  default     = {}
  nullable    = false
}

variable "module_tags_enabled" {
  description = "(Optional) Whether to create AWS Resource Tags for the module informations."
  type        = bool
  default     = true
  nullable    = false
}


###################################################
# Resource Group
###################################################

variable "resource_group" {
  description = <<EOF
  (Optional) A configurations of Resource Group for this module. `resource_group` as defined below.
    (Optional) `enabled` - Whether to create Resource Group to find and group AWS resources which are created by this module. Defaults to `true`.
    (Optional) `name` - The name of Resource Group. A Resource Group name can have a maximum of 127 characters, including letters, numbers, hyphens, dots, and underscores. The name cannot start with `AWS` or `aws`. If not provided, a name will be generated using the module name and instance name.
    (Optional) `description` - The description of Resource Group. Defaults to `Managed by Terraform.`.
  EOF
  type = object({
    enabled     = optional(bool, true)
    name        = optional(string, "")
    description = optional(string, "Managed by Terraform.")
  })
  default  = {}
  nullable = false
}
