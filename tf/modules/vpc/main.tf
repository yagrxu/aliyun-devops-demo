locals {
  tags = {
    Environment = var.environment
    Product     = var.product
  }
}

resource "alicloud_vpc" "vpc" {
  name       = "${var.product}-${var.environment}"
  cidr_block = var.vpc_cidr
  tags       = local.tags
}

resource "alicloud_vswitch" "private" {
  count             = length(var.private_subnets)
  name              = "private-${var.availability_zones[count.index]}"
  vpc_id            = alicloud_vpc.vpc.id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = var.availability_zones[count.index]
  tags              = local.tags
}

resource "alicloud_vswitch" "pods" {
  count             = length(var.pod_subnets)
  name              = "pods-${var.availability_zones[count.index]}"
  vpc_id            = alicloud_vpc.vpc.id
  cidr_block        = var.pod_subnets[count.index]
  availability_zone = var.availability_zones[count.index]
  tags              = local.tags
}

resource "alicloud_nat_gateway" "nat" {
  name          = alicloud_vpc.vpc.name
  vpc_id        = alicloud_vpc.vpc.id
  specification = "Small"
  // tags not supported
}

resource "alicloud_eip" "nat" {
  name      = alicloud_vpc.vpc.name
  bandwidth = 100
  tags      = local.tags
}

resource "alicloud_eip_association" "nat" {
  allocation_id = alicloud_eip.nat.id
  instance_id   = alicloud_nat_gateway.nat.id
  // tags not supported
}

locals {
  all_vswitch_ids = concat(alicloud_vswitch.private.*.id, alicloud_vswitch.pods.*.id)
}

// Associate subnets with NAT gateway
resource "alicloud_snat_entry" "nat" {
  count             = length(local.all_vswitch_ids)
  snat_table_id     = alicloud_nat_gateway.nat.snat_table_ids
  source_vswitch_id = local.all_vswitch_ids[count.index]
  snat_ip           = alicloud_eip.nat.ip_address
  depends_on        = [alicloud_eip_association.nat]
  // tags not supported
}
