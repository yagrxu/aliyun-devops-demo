variable "region" {
  description = "Region for resources"
  default     = "eu-central-1"
}

variable "role_name" {
  description = "The RAM role name."
  type        = string
}

variable "description" {
  description = "The RAM Role description."
  type        = string
}

variable "document_policy" {
  description = "The RAM Role Trusted Policy."
  type        = string
}

variable "policy_name" {
  description = "The name of RAM policy."
  type        = string
}

variable "policy_type" {
  description = "Type for RAM policy."
  default     = "System"
}
