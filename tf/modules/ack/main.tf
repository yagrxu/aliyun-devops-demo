locals {
  cluster_addons = [
    {
      "name"   = "terway-eniip",
      "config" = "",
      "disabled" = false,
    },
    {
      "name"   = "flexvolume",
      "config" = "",
      "disabled" = false,
    },
    {
      "name"   = "alicloud-disk-controller",
      "config" = "",
      "disabled" = false,
    },
    {
      "name"   = "logtail-ds",
      "config" = jsonencode({
        "IngressDashboardEnabled" : "true",
        "sls_project_name" : alicloud_log_project.k8s_sls.name
      }),
      "disabled" = false,
    },
    {
      "name"     = "nginx-ingress-controller",
      "config"   = "",
      "disabled" = true,
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
  version     = "1.16.9-aliyun.1"

  pod_vswitch_ids = var.pod_vswitch_ids
  service_cidr    = "192.168.0.0/16"

  slb_internet_enabled  = true
  new_nat_gateway       = true
  install_cloud_monitor = true

  worker_vswitch_ids    = var.worker_vswitch_ids
  worker_number         = 6
  worker_instance_types = var.worker_types
  worker_disk_size      = 40
  worker_disk_category  = "cloud_ssd"
  password              = local.ssh_password
  exclude_autoscaler_nodes = true

  kube_config = local.kube_config_path

  dynamic "addons" {
    for_each = local.cluster_addons
    content {
      name     = lookup(addons.value, "name", local.cluster_addons)
      config   = lookup(addons.value, "config", local.cluster_addons)
      disabled = lookup(addons.value, "disabled", local.cluster_addons) == null ? false:lookup(addons.value, "disabled", local.cluster_addons)
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
    token          = ", '\";=()[]{}?@&<>/:\n\t\r"
  }
  dynamic "field_search" {
    for_each = var.fields
    content {
      name = field_search.value["name"]
      enable_analytics = true
    }
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

resource "alicloud_security_group_rule" "allow_rds_access" {
  security_group_id = alicloud_cs_managed_kubernetes.k8s.security_group_id
  type              = "ingress"
  nic_type          = "intranet"
  policy            = "accept"
  ip_protocol       = "tcp"
  port_range        = "3306/3306"
  cidr_ip           = "0.0.0.0/0"
}

resource "alicloud_security_group_rule" "allow_pressure_test" {
  security_group_id = alicloud_cs_managed_kubernetes.k8s.security_group_id
  type              = "ingress"
  nic_type          = "intranet"
  policy            = "accept"
  ip_protocol       = "tcp"
  port_range        = "8080/8080"
  cidr_ip           = "0.0.0.0/0"
}

data "alicloud_instances" "worker" {
  ids   = alicloud_cs_managed_kubernetes.k8s.worker_nodes.*.id
}

data "alicloud_ram_roles" "roles_ack_cluster" {
  name_regex  = data.alicloud_instances.worker.instances[0].ram_role_name
  policy_type = "Custom"
  depends_on = [alicloud_cs_managed_kubernetes.k8s]
}

data "alicloud_ram_policies" "kube2ram_policy" {
  name_regex = "Kube2RamStsPolicy"
}

data "alicloud_ram_policies" "autoscaler_policy" {
  name_regex = "k8s_autoscaler_policy"
}

resource "alicloud_ram_role_policy_attachment" "attach01" {
  policy_name = data.alicloud_ram_policies.autoscaler_policy.policies[0].name
  policy_type = data.alicloud_ram_policies.autoscaler_policy.policies[0].type
  role_name   = data.alicloud_ram_roles.roles_ack_cluster.roles[0].name
}

resource "alicloud_ram_role_policy_attachment" "attach" {
  policy_name = data.alicloud_ram_policies.kube2ram_policy.policies[0].name
  policy_type = data.alicloud_ram_policies.kube2ram_policy.policies[0].type
  role_name   = data.alicloud_ram_roles.roles_ack_cluster.roles[0].name
  provisioner "local-exec" {
    command = <<EOF
    aliyun ram UpdateRole --RoleName ${data.alicloud_ram_roles.roles_ack_cluster.roles[0].name} --NewAssumeRolePolicyDocument '{
        "Statement": [
            {
                "Action": "sts:AssumeRole",
                "Effect": "Allow",
                "Principal": {
                    "Service": [
                        "ecs.aliyuncs.com"
                    ]
                }
            },
            {
                "Action": "sts:AssumeRole",
                "Effect": "Allow",
                "Principal": {
                    "RAM": [
                        "acs:ram::${var.account_id}:root"
                    ]
                }
            }
        ],
        "Version": "1"
    }'
    EOF
  }
}


data "alicloud_ram_policies" "external_secret_policy" {
  name_regex = "ExternalSecretPolicy"
}

resource "alicloud_ram_role_policy_attachment" "external_secret_policy_attach" {
  policy_name = data.alicloud_ram_policies.external_secret_policy.policies[0].name
  policy_type = data.alicloud_ram_policies.external_secret_policy.policies[0].type
  role_name   = data.alicloud_ram_roles.roles_ack_cluster.roles[0].name
}

resource "alicloud_ess_scaling_group" "k8s_asg" {
  min_size           = 0
  max_size           = 5
  scaling_group_name = "demo_asg"
  default_cooldown   = 5
  vswitch_ids        = var.pod_vswitch_ids
  removal_policies   = ["OldestInstance", "OldestScalingConfiguration"]
  depends_on         = [alicloud_cs_managed_kubernetes.k8s]
}

resource "alicloud_ess_scaling_configuration" "k8s_asc" {
  scaling_group_id  = alicloud_ess_scaling_group.k8s_asg.id
  image_id          = "centos_7_7_x64_20G_alibase_20200329.vhd"
  instance_type     = "ecs.g6.large"
  role_name         = data.alicloud_ram_roles.roles_ack_cluster.roles[0].name
  security_group_id = alicloud_cs_managed_kubernetes.k8s.security_group_id
  force_delete      = true
  active            = true
  enable            = true
  depends_on        = [alicloud_cs_managed_kubernetes.k8s]
}

resource "alicloud_cs_kubernetes_autoscaler" "k8s_autoscaler" {
  cluster_id              = alicloud_cs_managed_kubernetes.k8s.id
  nodepools {
        id                = alicloud_ess_scaling_group.k8s_asg.id
        taints            = null
        labels            = ""
  }
  utilization             = "0.4"
  cool_down_duration      = "1m"
  defer_scale_in_duration = "1m"
  use_ecs_ram_role_token  = true
  depends_on         = [alicloud_cs_managed_kubernetes.k8s, alicloud_ess_scaling_configuration.k8s_asc]
}