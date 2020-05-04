output "vpc_id" {
  value = alicloud_vpc.vpc.id
}

output "vpc_cidr" {
  value = alicloud_vpc.vpc.cidr_block
}

output "private_vswitch_ids" {
  value = alicloud_vswitch.private.*.id
}

output "pod_vswitch_ids" {
  value = alicloud_vswitch.pods.*.id
}

output "vswitch_ids" {
  value = local.all_vswitch_ids
}
