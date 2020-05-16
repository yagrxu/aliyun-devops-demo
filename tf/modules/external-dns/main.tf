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
            "--alibaba-cloud-zone-type=public",
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
}
