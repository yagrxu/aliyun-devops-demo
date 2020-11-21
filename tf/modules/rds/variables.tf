variable vswitch_id {

}
variable security_ips {
  
}
variable version_ids {
  type = list(string)
}

variable engine {
  default = "MySQL"
}

variable engine_version {
  default = "5.7"
}

variable storage_type {
  default = "local_ssd"
}

variable instance_type {
  default = "rds.mysql.t1.small"
}

variable timezone_name {
  default = "default_time_zone"
}

variable timezone_value {
  default = "Europe/Amsterdam"
}