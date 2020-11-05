resource "kubernetes_manifest" "mutatingwebhookconfiguration_mutating_webhook_configuration_ca_injection_patch" {
  manifest = {
    apiVersion = "admissionregistration.k8s.io/v1beta1"
    kind       = "MutatingWebhookConfiguration"
    metadata = {
      annotations = {
        "cert-manager.io/inject-ca-from" = "$(CERTIFICATE_NAMESPACE)/$(CERTIFICATE_NAME)"
      }
      name = "mutating-webhook-configuration"
    }
  }
}

resource "kubernetes_manifest" "validatingwebhookconfiguration_validating_webhook_configuration_ca_injection_patch" {
  manifest = {
    apiVersion = "admissionregistration.k8s.io/v1beta1"
    kind       = "ValidatingWebhookConfiguration"
    metadata = {
      annotations = {
        "cert-manager.io/inject-ca-from" = "$(CERTIFICATE_NAMESPACE)/$(CERTIFICATE_NAME)"
      }
      name = "validating-webhook-configuration"
    }
  }
}

resource "kubernetes_manifest" "service_webhook_service" {
  manifest = {
    apiVersion = "v1"
    kind       = "Service"
    metadata = {
      name      = "webhook-service"
      namespace = "system"
    }
    spec = {
      ports = [
        {
          port       = 443
          targetPort = 9443
        },
      ]
      selector = {
        control-plane = "controller-manager"
      }
    }
  }
}
