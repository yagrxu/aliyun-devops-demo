variable worker_vswitch_ids {
  type = list(string)
}
variable worker_types {
  type = list(string)
}
variable pod_vswitch_ids {
  type = list(string)
}
variable account_id {

}

variable fields {
  type = list(object({
    name = string
  }))
  default = [
    {
      name = "_container_name_"
    },
    {
      name = "_image_name_"
    },
    {
      name = "__topic__"
    }
  ]
}
