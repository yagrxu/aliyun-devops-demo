resource "random_password" "secret_data" {
  length = 8
}

resource "alicloud_kms_secret" "secret" {
  secret_name                   = var.secret_name
  secret_data                   = random_password.secret_data.result
  version_id                    = var.version_id
  force_delete_without_recovery = true
}
