variable "name" {
  description = "Desired name for the VPC Peering resources."
  type        = string
}

variable "grants" {
  description = "A list of the ACL policy grant. Conflicts with acl. Valid values for `grant.type` are `CanonicalUser` and `Group`. `AmazonCustomerByEmail` is not supported. Valid values for `grant.permissions` are `READ`, `WRITE`, `READ_ACP`, `WRITE_ACP`, `FULL_CONTROL`."
  type        = list(any)
  default     = []
}

variable "public_access_block_enabled" {
  description = "Enable S3 bucket-level Public Access Block configuration."
  type        = bool
  default     = false
}

variable "force_destroy" {
  description = "A bool that indicates all objects (including any locked objects) should be deleted from the bucket so the bucket can be destroyed without error."
  type        = bool
  default     = false
}

variable "enforce_tls" {
  description = "Deny any access to the S3 bucket that is not encrypted in-transit if true."
  type        = bool
  default     = true
}

variable "default_expiration_enabled" {
  description = "A bool that to enable the expiration lifecycle rule for this bucket."
  type        = bool
  default     = false
}

variable "default_expiration_date" {
  description = "Specifies the date after which you want the expiration action takes effect for this bucket."
  type        = string
  default     = null
}

variable "default_expiration_days" {
  description = "Specifies the number of days after object creation when the expiration action takes effect for this bucket."
  type        = number
  default     = 365
}

variable "cloudfront_enabled" {
  description = "Allow CloudFront service to export logs to bucket."
  type        = bool
  default     = false
}

variable "cloudfront_bucket_prefixes" {
  description = "List of the S3 key prefixes that follows the name of the bucket you have allowed for CloudFront log file delivery."
  type        = list(string)
  default     = []
}

variable "cloudfront_expiration_enabled" {
  description = "A bool that to enable the expiration lifecycle rule for CloudFront prefixes."
  type        = bool
  default     = false
}

variable "cloudfront_expiration_date" {
  description = "Specifies the date after which you want the expiration action takes effect for CloudFront prefixes."
  type        = string
  default     = null
}

variable "cloudfront_expiration_days" {
  description = "Specifies the number of days after object creation when the expiration action takes effect for CloudFront prefixes."
  type        = number
  default     = 365
}

variable "cloudtrail_enabled" {
  description = "Allow CloudTrail service to export logs to bucket."
  type        = bool
  default     = false
}

variable "cloudtrail_bucket_prefixes" {
  description = "List of the S3 key prefixes that follows the name of the bucket you have allowed for CloudTrail log file delivery."
  type        = list(string)
  default     = []
}

variable "cloudtrail_expiration_enabled" {
  description = "A bool that to enable the expiration lifecycle rule for CloudTrail prefixes."
  type        = bool
  default     = false
}

variable "cloudtrail_expiration_date" {
  description = "Specifies the date after which you want the expiration action takes effect for CloudTrail prefixes."
  type        = string
  default     = null
}

variable "cloudtrail_expiration_days" {
  description = "Specifies the number of days after object creation when the expiration action takes effect for CloudTrail prefixes."
  type        = number
  default     = 365
}

variable "elb_enabled" {
  description = "Allow ELB(Elastic Load Balancer) service to export logs to bucket."
  type        = bool
  default     = false
}

variable "elb_bucket_prefixes" {
  description = "List of the S3 key prefixes that follows the name of the bucket you have allowed for ELB(Elastic Load Balancer) log file delivery."
  type        = list(string)
  default     = []
}

variable "elb_expiration_enabled" {
  description = "A bool that to enable the expiration lifecycle rule for ELB(Elastic Load Balancer) prefixes."
  type        = bool
  default     = false
}

variable "elb_expiration_date" {
  description = "Specifies the date after which you want the expiration action takes effect for ELB(Elastic Load Balancer) prefixes."
  type        = string
  default     = null
}

variable "elb_expiration_days" {
  description = "Specifies the number of days after object creation when the expiration action takes effect for ELB(Elastic Load Balancer) prefixes."
  type        = number
  default     = 365
}

variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}
