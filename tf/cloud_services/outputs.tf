output cluster_id {
  value = module.managed_k8s.cluster_id
}

output connection_string {
  value = module.database.connection_string
}