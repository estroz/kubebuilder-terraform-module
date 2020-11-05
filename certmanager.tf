resource "kubernetes_manifest" "issuer_selfsigned_issuer" {
  manifest = {
    apiVersion = "cert-manager.io/v1alpha2"
    kind       = "Issuer"
    metadata = {
      name      = "selfsigned-issuer"
      namespace = "system"
    }
    spec = {
      selfSigned = {}
    }
  }
}

resource "kubernetes_manifest" "certificate_serving_cert" {
  manifest = {
    apiVersion = "cert-manager.io/v1alpha2"
    kind       = "Certificate"
    metadata = {
      name      = "serving-cert"
      namespace = "system"
    }
    spec = {
      dnsNames = [
        "$(SERVICE_NAME).$(SERVICE_NAMESPACE).svc",
        "$(SERVICE_NAME).$(SERVICE_NAMESPACE).svc.cluster.local",
      ]
      issuerRef = {
        kind = "Issuer"
        name = "selfsigned-issuer"
      }
      secretName = "webhook-server-cert"
    }
  }
}
