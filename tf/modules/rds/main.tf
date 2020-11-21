locals {
  db_names          = ["demo01", "demo02", "demo03"]
  db_usernames      = ["user_a", "user_b", "user_c"]
  db_userprivileges = ["DBOwner", "DBOwner", "DBOwner"]
}

resource "alicloud_db_instance" "db_instance" {
  engine              = var.engine
  engine_version      = var.engine_version
  db_instance_storage_type = var.storage_type
  instance_type            = var.instance_type
  instance_storage    = "40"
  instance_name       = "demo"
  security_ips        = var.security_ips
  vswitch_id          = var.vswitch_id
  force_restart       = true
  parameters {
    name  = var.timezone_name
    value = var.timezone_value
  }
}

resource "alicloud_db_database" "db_schema" {
  count       = length(local.db_names)
  instance_id = alicloud_db_instance.db_instance.id
  name        = local.db_names[count.index]
  character_set = "UTF8"
}

resource "alicloud_db_account" "db_account" {
  count       = length(local.db_usernames)
  instance_id = alicloud_db_instance.db_instance.id
  name        = local.db_usernames[count.index]
  password    = alicloud_kms_secret.secret[count.index].secret_data
  description = "from terraform"
  depends_on   = [alicloud_db_instance.db_instance]
}

resource "alicloud_db_account_privilege" "privilege" {
  count        = length(local.db_userprivileges)
  instance_id  = alicloud_db_instance.db_instance.id
  account_name = local.db_usernames[count.index]
  privilege    = local.db_userprivileges[count.index]
  db_names     = [local.db_names[count.index]]
  depends_on   = [alicloud_db_account.db_account, alicloud_db_database.db_schema]
}

resource "random_password" "secret_data" {
  count  = length(local.db_usernames)
  length = 8
  special = false
}

resource "alicloud_kms_secret" "secret" {
  count  = length(local.db_usernames)
  secret_name                   = "${alicloud_db_instance.db_instance.instance_name}-${local.db_usernames[count.index]}-password"
  secret_data                   = random_password.secret_data[count.index].result
  version_id                    = var.version_ids[count.index]
  force_delete_without_recovery = true
}
