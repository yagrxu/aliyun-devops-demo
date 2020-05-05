variable "region" {
  default = "eu-central-1"
}

variable "name" {
  description = "Secret name"
  type        = string
}

variable "value" {
  description = "Secret value"
  type        = string
  default     = ""
}

variable "version_id" {
  description = "Secret version ID (must be incremented when changing secret value)"
  type        = string
  default     = "1"
}

variable "generate" {
  description = "Set to true to generate a random secret"
  type        = bool
  default     = false
}

variable "secret_length" {
  description = "Set length of secret"
  type        = number
  default     = 32
}

variable "secret_special" {
  description = "Allow special characters in generated secret"
  type        = bool
  default     = true
}

variable "secret_min_special" {
  description = "Minimum number of special characters in random string (default 0)"
  type        = number
  default     = 0
}

variable "secret_override_special" {
  description = "Supply your own list of special characters to use for string generation"
  type        = string
  default     = null
}

variable "secret_lower" {
  description = "Include lowercase alphabet characters in random string (default true)"
  type        = bool
  default     = true
}

variable "secret_min_lower" {
  description = "Minimum number of lowercase alphabet characters in random string (default 0)"
  type        = number
  default     = 0
}

variable "secret_upper" {
  description = "Include uppercase alphabet characters in random string (default true)"
  type        = bool
  default     = true
}

variable "secret_min_upper" {
  description = "Minimum number of uppercase alphabet characters in random string (default 0)"
  type        = number
  default     = 0
}

variable "secret_number" {
  description = "Include numeric characters in random string (default true)"
  type        = bool
  default     = true
}

variable "secret_min_numeric" {
  description = "Minimum number of numeric characters in random string (default 0)"
  type        = number
  default     = 0
}
