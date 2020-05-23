
resource "kubernetes_namespace" "cert_manager_namespace" {
  metadata {
    annotations = {
      name = "cert-manager"
    }
    name = "cert-manager"
  }
}

resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  namespace  = "cert-manager"
  version    = "v0.15.0"
  set {
    name  = "installCRDs"
    value = "true"
  }
  depends_on = [kubernetes_namespace.cert_manager_namespace]
}