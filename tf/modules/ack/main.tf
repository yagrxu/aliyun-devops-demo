locals {
  cluster_addons = [
    {
      "name"   = "terway-eniip",
      "config" = "",
    },
    {
      "name"   = "flexvolume",
      "config" = "",
    },
    {
      "name"   = "alicloud-disk-controller",
      "config" = "",
    },
    {
      "name"   = "logtail-ds",
      "config" = jsonencode({
        "IngressDashboardEnabled" : "true",
        "sls_project_name" : alicloud_log_project.k8s_sls.name
      }),
    }
  ]
  ssh_password     = random_password.ssh.result
  kube_config_path = "~/.kube/config-demo"
}

resource "random_password" "ssh" {
  length = 30
}

resource "alicloud_cs_managed_kubernetes" "k8s" {
  name_prefix = "demo"
  version     = "1.16.6-aliyun.1"

  pod_vswitch_ids = var.pod_vswitch_ids
  service_cidr    = "192.168.0.0/16"

  slb_internet_enabled  = true
  new_nat_gateway       = true
  install_cloud_monitor = true

  worker_vswitch_ids    = var.worker_vswitch_ids
  worker_number         = 2
  worker_instance_types = var.worker_types
  worker_disk_size      = 40
  worker_disk_category  = "cloud_ssd"
  password              = local.ssh_password

  kube_config = local.kube_config_path

  dynamic "addons" {
    for_each = local.cluster_addons
    content {
      name   = lookup(addons.value, "name", local.cluster_addons)
      config = lookup(addons.value, "config", local.cluster_addons)
    }
  }
}

resource "alicloud_log_project" "k8s_sls" {
  name = "k8s-demo"
}

resource "alicloud_log_store" "k8s_logstore" {
  project               = alicloud_log_project.k8s_sls.name
  name                  = "k8s_pod_log"
  shard_count           = 3
  auto_split            = true
  max_split_shard_count = 60
}

resource "alicloud_log_store_index" "index" {
  project  = alicloud_log_project.k8s_sls.name
  logstore = alicloud_log_store.k8s_logstore.name
  full_text {
    case_sensitive = true
  }
}

resource "alicloud_security_group_rule" "allow_ssh_via_vpn" {
  security_group_id = alicloud_cs_managed_kubernetes.k8s.security_group_id
  type              = "ingress"
  nic_type          = "intranet"
  policy            = "accept"
  ip_protocol       = "tcp"
  port_range        = "22/22"
  cidr_ip           = "0.0.0.0/0"
}
