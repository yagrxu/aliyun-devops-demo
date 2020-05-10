resource "kubernetes_service_account" "kube2ram_service_account" {
  metadata {
    name = "kube2ram"
    namespace = "kube-system"
  }
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
        service_account_name = "kube2ram"
      }
    }
  }
}