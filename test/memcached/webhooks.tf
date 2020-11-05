resource "kubernetes_manifest" "mutatingwebhookconfiguration_mutating_webhook_configuration" {
  manifest = {
    apiVersion = "admissionregistration.k8s.io/v1beta1"
    kind       = "MutatingWebhookConfiguration"
    metadata = {
      creationTimestamp = null
      name              = "mutating-webhook-configuration"
    }
    webhooks = [
      {
        clientConfig = {
          caBundle = "Cg=="
          service = {
            name      = "webhook-service"
            namespace = "system"
            path      = "/mutate-cache-example-com-v1alpha1-memcached"
          }
        }
        failurePolicy = "Fail"
        name          = "mmemcached.kb.io"
        rules = [
          {
            apiGroups = [
              "cache.example.com",
            ]
            apiVersions = [
              "v1alpha1",
            ]
            operations = [
              "CREATE",
              "UPDATE",
            ]
            resources = [
              "memcacheds",
            ]
          },
        ]
      },
    ]
  }
}

resource "kubernetes_manifest" "validatingwebhookconfiguration_validating_webhook_configuration" {
  manifest = {
    apiVersion = "admissionregistration.k8s.io/v1beta1"
    kind       = "ValidatingWebhookConfiguration"
    metadata = {
      creationTimestamp = null
      name              = "validating-webhook-configuration"
    }
    webhooks = [
      {
        clientConfig = {
          caBundle = "Cg=="
          service = {
            name      = "webhook-service"
            namespace = "system"
            path      = "/validate-cache-example-com-v1alpha1-memcached"
          }
        }
        failurePolicy = "Fail"
        name          = "vmemcached.kb.io"
        rules = [
          {
            apiGroups = [
              "cache.example.com",
            ]
            apiVersions = [
              "v1alpha1",
            ]
            operations = [
              "CREATE",
              "UPDATE",
            ]
            resources = [
              "memcacheds",
            ]
          },
        ]
      },
    ]
  }
}
