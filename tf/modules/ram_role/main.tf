resource "alicloud_ram_role" "role" {
  name        = var.role_name
  document    = var.document_policy
  description = var.description
  force       = true
}

resource "alicloud_ram_role_policy_attachment" "attach" {
  policy_name = var.policy_name
  policy_type = var.policy_type
  role_name   = alicloud_ram_role.role.name
}
