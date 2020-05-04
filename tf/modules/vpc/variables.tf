variable "product" {
  description = "Product name"
  type        = string
}

variable "environment" {
  description = "Environment type"
  type        = string
}

variable "region" {
  description = "Region for resources"
  type        = string
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = []
}

variable "vpc_cidr" {
  description = "Main CIDR block for VPC"
  type        = string
}

variable "private_subnets" {
  description = "List of private subnets in CIDR format"
  type        = list(string)
  default     = []
}

variable "pod_subnets" {
  description = "List of pod subnets in CIDR format"
  type        = list(string)
  default     = []
}
