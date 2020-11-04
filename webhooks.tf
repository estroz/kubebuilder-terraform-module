resource "kubernetes_service" "webhook-service" {
  metadata {
    name      = "webhook-service"
    namespace = "system"
  }
  spec {
    port {
      port        = 443
      target_port = 9443
    }
    selector = {
      control-plane = "controller-manager"
    }
  }
}

# TODO: generated webhooks should have .spec.webhooks.clientConfig.service.{name,namespace}
# substituted with that of the service.

# TODO: figure out how to conditionally patch webhooks with cert annotations.
/*
apiVersion: admissionregistration.k8s.io/v1beta1
kind: MutatingWebhookConfiguration
metadata:
  name: mutating-webhook-configuration
  annotations:
    cert-manager.io/inject-ca-from: $(CERTIFICATE_NAMESPACE)/$(CERTIFICATE_NAME)
---
apiVersion: admissionregistration.k8s.io/v1beta1
kind: ValidatingWebhookConfiguration
metadata:
  name: validating-webhook-configuration
  annotations:
    cert-manager.io/inject-ca-from: $(CERTIFICATE_NAMESPACE)/$(CERTIFICATE_NAME)
*/
