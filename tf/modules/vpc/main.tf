locals {
  tags = {
    Environment = var.env
    Product     = var.product
  }
}

resource "alicloud_vpc" "vpc" {
  name       = "${var.product}-${var.env}"
  cidr_block = var.vpc_cidr
  tags       = local.tags
}

resource "alicloud_vswitch" "worker_vswitch" {
  count             = length(var.worker_subnets)
  name              = "worker-${var.availability_zones[count.index]}"
  vpc_id            = alicloud_vpc.vpc.id
  cidr_block        = var.worker_subnets[count.index]
  availability_zone = var.availability_zones[count.index]
  tags              = local.tags
}

resource "alicloud_vswitch" "pod_vswitch" {
  count             = length(var.pod_subnets)
  name              = "pod-${var.availability_zones[count.index]}"
  vpc_id            = alicloud_vpc.vpc.id
  cidr_block        = var.pod_subnets[count.index]
  availability_zone = var.availability_zones[count.index]
  tags              = local.tags
}

locals {
  all_vswitch_ids = concat(alicloud_vswitch.worker_vswitch.*.id, alicloud_vswitch.pod_vswitch.*.id)
}