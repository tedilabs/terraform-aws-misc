variable "name" {
  description = "Desired name for the S3 bucket."
  type        = string
}

variable "force_destroy" {
  description = "A bool that indicates all objects (including any locked objects) should be deleted from the bucket so the bucket can be destroyed without error."
  type        = bool
  default     = false
}

variable "transfer_acceleration_enabled" {
  description = "Whether to use an accelerated endpoint for faster data transfers."
  type        = bool
  default     = false
}

variable "versioning_status" {
  description = "A desired status of the bucket versioning. Valid values are `ENABLED`, `SUSPENDED`, or `DISABLED`. Disabled should only be used when creating or importing resources that correspond to unversioned S3 buckets."
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
  default = {
    enabled = false
    device  = null
  }
  nullable = false
}

variable "grants" {
  description = "A list of the ACL policy grant. Conflicts with acl. Valid values for `grant.type` are `CanonicalUser` and `Group`. `AmazonCustomerByEmail` is not supported. Valid values for `grant.permissions` are `READ`, `WRITE`, `READ_ACP`, `WRITE_ACP`, `FULL_CONTROL`."
  type        = list(any)
  default     = []
}

variable "object_ownership" {
  description = "Control ownership of objects written to this bucket from other AWS accounts and granted using access control lists (ACLs). Object ownership determines who can specify access to objects. Valid values: `BucketOwnerPreferred` or `ObjectWriter`."
  type        = string
  default     = "BucketOwnerPreferred"
}

variable "public_access_block_enabled" {
  description = "Enable S3 bucket-level Public Access Block configuration."
  type        = bool
  default     = true
}

variable "tls_required" {
  description = "Deny any access to the S3 bucket that is not encrypted in-transit if true."
  type        = bool
  default     = true
}

variable "delivery_cloudfront_enabled" {
  description = "Allow CloudFront service to export logs to bucket."
  type        = bool
  default     = false
}

variable "delivery_cloudtrail_enabled" {
  description = "Allow CloudTrail service to export logs to bucket."
  type        = bool
  default     = false
}

variable "delivery_cloudtrail_key_prefixes" {
  description = "List of the S3 key prefixes that follows the name of the bucket you have allowed for CloudTrail log file delivery."
  type        = list(string)
  default     = []
}

variable "delivery_config_enabled" {
  description = "Allow Config service to delivery to bucket."
  type        = bool
  default     = false
}

variable "delivery_config_key_prefixes" {
  description = "List of the S3 key prefixes that follows the name of the bucket you have allowed for Config."
  type        = list(string)
  default     = []
}

variable "delivery_elb_enabled" {
  description = "Allow ELB(Elastic Load Balancer) service to export logs to bucket."
  type        = bool
  default     = false
}

variable "delivery_elb_key_prefixes" {
  description = "List of the S3 key prefixes that follows the name of the bucket you have allowed for ELB(Elastic Load Balancer) log file delivery."
  type        = list(string)
  default     = []
}

variable "lifecycle_rules" {
  description = "Use lifecycle rules to define actions you want Amazon S3 to take during an object's lifetime such as transitioning objects to another storage class, archiving them, or deleting them after a specified period of time."
  type        = list(any)
  default     = []
}

variable "logging_s3_bucket" {
  description = "The name of the bucket that will receive the log objects."
  type        = string
  default     = null
}

variable "logging_s3_key_prefix" {
  description = "To specify a key prefix of log objects."
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}

variable "module_tags_enabled" {
  description = "Whether to create AWS Resource Tags for the module informations."
  type        = bool
  default     = true
}


###################################################
# Resource Group
###################################################

variable "resource_group_enabled" {
  description = "Whether to create Resource Group to find and group AWS resources which are created by this module."
  type        = bool
  default     = true
}

variable "resource_group_name" {
  description = "The name of Resource Group. A Resource Group name can have a maximum of 127 characters, including letters, numbers, hyphens, dots, and underscores. The name cannot start with `AWS` or `aws`."
  type        = string
  default     = ""
}

variable "resource_group_description" {
  description = "The description of Resource Group."
  type        = string
  default     = "Managed by Terraform."
}
