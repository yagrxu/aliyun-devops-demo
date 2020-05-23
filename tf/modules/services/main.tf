resource "kubernetes_service_account" "kube2ram_service_account" {
  metadata {
    name = "kube2ram"
    namespace = "kube-system"
  }
  automount_service_account_token = true
}

resource "kubernetes_cluster_role" "kube2ram_cluster_role" {
  metadata {
    name = "kube2ram"
  }

  rule {
    api_groups = [""]
    resources = ["namespaces","pods"]
    verbs     = ["get","watch","list"]
  }
}

resource "kubernetes_cluster_role_binding" "kube2ram_cluster_role_binding" {
  metadata {
    name = "kube2ram"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "kube2ram"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "kube2ram"
    namespace = "kube-system"
  }
}

resource "kubernetes_daemonset" "kube2ram" {
  metadata {
    name      = "kube2ram"
    namespace = "kube-system"
    labels = {
      "app.kubernetes.io/name" = "kube2ram"
    }
  }

  spec {
    selector {
      match_labels = {
        "app.kubernetes.io/name" = "kube2ram"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/name" = "kube2ram"
        }
      }

      spec {
        automount_service_account_token = true
        service_account_name = kubernetes_service_account.kube2ram_service_account.metadata[0].name
        container {
          image = "registry.cn-hangzhou.aliyuncs.com/acs/kube2ram:1.0.0"
          name  = "kube2ram"
          image_pull_policy = "Always"
          args = [
            "--app-port=8181",
            "--iptables=true",
            "--host-ip=$(HOST_IP)",
            "--host-interface=${var.host_interface}",
            "--verbose",
            "--debug",
            "--auto-discover-default-role",
          ]
          env {
            name = "HOST_IP"
            value_from {
              field_ref {
                api_version = "v1"
                field_path  = "status.podIP"
              }
            }
          }
          env {
            name = "NODE_NAME"
            value_from {
              field_ref {
                field_path = "spec.nodeName"
              }
            }
          }
          port {
            container_port = 8181
            protocol       = "TCP"
          }
          security_context {
            privileged = true
          }
        }
        host_network = true
      }
    }
  }
}

resource "kubernetes_service_account" "alicloud_external_dns_service_account" {
  metadata {
    name = "external-dns"
    namespace = "kube-system"
  }
  automount_service_account_token = true
}

resource "kubernetes_cluster_role" "alicloud_external_dns_cluster_role" {
  metadata {
    name = "external-dns"
  }

  rule {
    api_groups = [""]
    resources = ["services"]
    verbs     = ["get","watch","list"]
  }
  rule {
    api_groups = [""]
    resources = ["pods"]
    verbs     = ["get","watch","list"]
  }
  rule {
    api_groups = ["extensions"]
    resources = ["ingresses"]
    verbs     = ["get","watch","list"]
  }
  rule {
    api_groups = [""]
    resources = ["nodes"]
    verbs     = ["watch","list"]
  }
}

resource "kubernetes_cluster_role_binding" "alicloud_external_dns_cluster_role_binding" {
  metadata {
    name = "external-dns-viewer"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "external-dns"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "external-dns"
    namespace = "kube-system"
  }
}

resource "kubernetes_deployment" "alicloud_external_dns" {
  metadata {
    name = "external-dns"
    namespace = "kube-system"

  }

  spec {
    strategy {
      type = "Recreate"
    }
    selector {
      match_labels = {
        app = "external-dns"
      }
    }

    template {
      metadata {
        annotations = {
          "ram.aliyuncs.com/role" = var.dns_ram_role
        }
        labels = {
          app = "external-dns"
        }
      }

      spec {
        service_account_name = "external-dns"
        automount_service_account_token = true
        container {
          image = "registry.opensource.zalan.do/teapot/external-dns:latest"
          name  = "external-dns"
          args = [
            "--source=service",
            "--source=ingress",
            //"--dry-run",
            //"--domain-filter=${var.domain_name}", # will make ExternalDNS see only the hosted zones matching provided domain, omit to process all available hosted zones,
            "--provider=alibabacloud",
            "--policy=sync", # would prevent ExternalDNS from deleting any records, omit to enable full synchronization",
            "--registry=txt",
            "--txt-owner-id=my-identifier",
            "--alibaba-cloud-config-file="
          ]
          volume_mount {
            name       = "hostpath"
            mount_path = "/usr/share/zoneinfo"
          }
        }
        volume {
          name = "hostpath"
          host_path {
            type = "Directory"
            path = "/usr/share/zoneinfo"
          }
        }
      }
    }
  }
  depends_on = [kubernetes_daemonset.kube2ram]
}

