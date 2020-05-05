variable "product" {
  description = "Product name"
  type        = string
}

variable "env" {
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = []
}

variable "vpc_cidr" {

}

variable "worker_subnets" {
  description = "List of private subnets in CIDR format"
  type        = list(string)
  default     = []
}

variable "pod_subnets" {
  description = "List of pod subnets in CIDR format"
  type        = list(string)
  default     = []
}
