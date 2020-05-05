output "vpc_id" {
  value = alicloud_vpc.vpc.id
}

output "vpc_cidr" {
  value = alicloud_vpc.vpc.cidr_block
}

output "worker_vswitch_ids" {
  value = alicloud_vswitch.worker_vswitch.*.id
}

output "pod_vswitch_ids" {
  value = alicloud_vswitch.pod_vswitch.*.id
}

output "vswitch_ids" {
  value = local.all_vswitch_ids
}
