variable "name" {
  description = "(Required) Desired name for the S3 bucket."
  type        = string
}

variable "force_destroy" {
  description = "(Optional) A bool that indicates all objects (including any locked objects) should be deleted from the bucket so the bucket can be destroyed without error."
  type        = bool
  default     = false
  nullable    = false
}

variable "transfer_acceleration_enabled" {
  description = "(Optional) Whether to use an accelerated endpoint for faster data transfers."
  type        = bool
  default     = false
  nullable    = false
}

variable "versioning_status" {
  description = "(Optional) A desired status of the bucket versioning. Valid values are `ENABLED`, `SUSPENDED`, or `DISABLED`. Disabled should only be used when creating or importing resources that correspond to unversioned S3 buckets."
  type        = string
  default     = "DISABLED"
  nullable    = false

  validation {
    condition     = contains(["ENABLED", "SUSPENDED", "DISABLED"], var.versioning_status)
    error_message = "Valid values for `versioning_status` are `ENABLED`, `SUSPENDED`, `DISABLED`."
  }
}

variable "versioning_mfa_deletion" {
  description = <<EOF
  (Optional) A configuration for MFA (Multi-factors Authentication) of the bucket versioning on deletion. `versioning_mfa_deletion` block as defined below.
    (Required) `enabled` - Whether MFA delete is enabled in the bucket versioning configuration. Default is `false`.
    (Required) `device` - The concatenation of the authentication device's serial number, a space, and the value that is displayed on your authentication device.
  EOF
  type = object({
    enabled = bool
    device  = string
  })
  default = null
}

variable "policy" {
  description = "(Optional) A valid policy JSON document. Although this is a bucket policy, not an IAM policy, the `aws_iam_policy_document` data source may be used, so long as it specifies a principal. Bucket policies are limited to 20 KB in size."
  type        = string
  default     = null
}

variable "grants" {
  description = "(Optional) A list of the ACL policy grant. Conflicts with acl. Valid values for `grant.type` are `CanonicalUser` and `Group`. `AmazonCustomerByEmail` is not supported. Valid values for `grant.permission` are `READ`, `WRITE`, `READ_ACP`, `WRITE_ACP`, `FULL_CONTROL`."
  type        = list(any)
  default     = []
  nullable    = false

  validation {
    condition = alltrue([
      for grant in var.grants :
      contains(["READ", "WRITE", "READ_ACP", "WRITE_ACP", "FULL_CONTROL"], grant.permission)
    ])
    error_message = "Valid values for `grant.permission` are `READ`, `WRITE`, `READ_ACP`, `WRITE_ACP`, `FULL_CONTROL`."
  }
}

variable "object_ownership" {
  description = "(Optional) Control ownership of objects written to this bucket from other AWS accounts and granted using access control lists (ACLs). Object ownership determines who can specify access to objects. Valid values: `BucketOwnerPreferred`, `BucketOwnerEnforced` or `ObjectWriter`."
  type        = string
  default     = "BucketOwnerPreferred"
  nullable    = false

  validation {
    condition     = contains(["BucketOwnerPreferred", "BucketOwnerEnforced", "ObjectWriter"], var.object_ownership)
    error_message = "Valid values for `object_ownership` are `BucketOwnerPreferred`, `BucketOwnerEnforced` or `ObjectWriter`."
  }
}

variable "public_access_enabled" {
  description = "(Optional) Whether to enable S3 bucket-level Public Access Block configuration. Block the public access to S3 bucket if the value is `false`."
  type        = bool
  default     = false
  nullable    = false
}

variable "tls_required" {
  description = "(Optional) Deny any access to the S3 bucket that is not encrypted in-transit if true."
  type        = bool
  default     = true
  nullable    = false
}

variable "delivery_cloudfront_enabled" {
  description = "(Optional) Allow CloudFront service to export logs to bucket."
  type        = bool
  default     = false
  nullable    = false
}

variable "delivery_cloudtrail_enabled" {
  description = "(Optional) Allow CloudTrail service to export logs to bucket."
  type        = bool
  default     = false
  nullable    = false
}

variable "delivery_cloudtrail_key_prefixes" {
  description = "(Optional) List of the S3 key prefixes that follows the name of the bucket you have allowed for CloudTrail log file delivery."
  type        = list(string)
  default     = []
  nullable    = false
}

variable "delivery_config_enabled" {
  description = "(Optional) Allow Config service to delivery to bucket."
  type        = bool
  default     = false
  nullable    = false
}

variable "delivery_config_key_prefixes" {
  description = "(Optional) List of the S3 key prefixes that follows the name of the bucket you have allowed for Config."
  type        = list(string)
  default     = []
  nullable    = false
}

variable "delivery_elb_enabled" {
  description = "(Optional) Allow ELB(Elastic Load Balancer) service to export logs to bucket."
  type        = bool
  default     = false
  nullable    = false
}

variable "delivery_elb_key_prefixes" {
  description = "(Optional) List of the S3 key prefixes that follows the name of the bucket you have allowed for ELB(Elastic Load Balancer) log file delivery."
  type        = list(string)
  default     = []
  nullable    = false
}

variable "lifecycle_rules" {
  description = "(Optional) Use lifecycle rules to define actions you want Amazon S3 to take during an object's lifetime such as transitioning objects to another storage class, archiving them, or deleting them after a specified period of time."
  type        = list(any)
  default     = []
  nullable    = false
}

variable "logging_enabled" {
  description = "(Optional) Whether to enable S3 bucket logging for the access log. Defaults to `false`."
  type        = bool
  default     = false
  nullable    = false
}

variable "logging_s3_bucket" {
  description = "(Optional) The name of the bucket that will receive the log objects."
  type        = string
  default     = null
}

variable "logging_s3_key_prefix" {
  description = "(Optional) To specify a key prefix of log objects."
  type        = string
  default     = null
}

variable "tags" {
  description = "(Optional) A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}

variable "module_tags_enabled" {
  description = "(Optional) Whether to create AWS Resource Tags for the module informations."
  type        = bool
  default     = true
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
