output "name" {
  value = var.name
}

output "secret_data" {
  value     = random_password.secret_data.result
  sensitive = true
}

output "version_id" {
  value = var.version_id
}
