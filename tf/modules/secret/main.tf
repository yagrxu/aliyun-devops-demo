resource "helm_release" "secret_manager" {
  name       = "secret-manager"
  repository = "http://aliacs-k8s-eu-central-1.oss-eu-central-1.aliyuncs.com/app/charts-incubator/"
  chart      = "ack-secret-manager"
  namespace  = "kube-system"
  version    = "0.1.0"

  set {
    name  = "command.region"
    value = var.region
  }
}