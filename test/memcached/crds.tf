resource "kubernetes_manifest" "customresourcedefinition_memcacheds_cache_example_com" {
  manifest = {
    apiVersion = "apiextensions.k8s.io/v1beta1"
    kind       = "CustomResourceDefinition"
    metadata = {
      annotations = {
        "controller-gen.kubebuilder.io/version" = "v0.3.0"
      }
      creationTimestamp = null
      name              = "memcacheds.cache.example.com"
    }
    spec = {
      group = "cache.example.com"
      names = {
        kind     = "Memcached"
        listKind = "MemcachedList"
        plural   = "memcacheds"
        singular = "memcached"
      }
      scope = "Namespaced"
      subresources = {
        status = {}
      }
      validation = {
        openAPIV3Schema = {
          description = "Memcached is the Schema for the memcacheds API"
          properties = {
            apiVersion = {
              description = "APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources"
              type        = "string"
            }
            kind = {
              description = "Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds"
              type        = "string"
            }
            metadata = {
              type = "object"
            }
            spec = {
              description = "MemcachedSpec defines the desired state of Memcached"
              properties = {
                foo = {
                  description = "Foo is an example field of Memcached. Edit Memcached_types.go to remove/update"
                  type        = "string"
                }
                size = {
                  description = "Size defines the number of Memcached instances"
                  format      = "int32"
                  type        = "integer"
                }
              }
              type = "object"
            }
            status = {
              description = "MemcachedStatus defines the observed state of Memcached"
              properties = {
                nodes = {
                  description = "Nodes store the name of the pods which are running Memcached instances"
                  items = {
                    type = "string"
                  }
                  type = "array"
                }
              }
              type = "object"
            }
          }
          type = "object"
        }
      }
      version = "v1alpha1"
      versions = [
        {
          name    = "v1alpha1"
          served  = true
          storage = true
        },
      ]
    }
    status = {
      acceptedNames = {
        kind   = ""
        plural = ""
      }
      conditions     = []
      storedVersions = []
    }
  }
}

resource "kubernetes_manifest" "customresourcedefinition_memcacheds_cache_example_com_ca_injection_patch" {
  manifest = {
    apiVersion = "apiextensions.k8s.io/v1beta1"
    kind       = "CustomResourceDefinition"
    metadata = {
      annotations = {
        "cert-manager.io/inject-ca-from" = "$(CERTIFICATE_NAMESPACE)/$(CERTIFICATE_NAME)"
      }
      name = "memcacheds.cache.example.com"
    }
  }
}

resource "kubernetes_manifest" "customresourcedefinition_memcacheds_cache_example_com_webhooks_patch" {
  manifest = {
    apiVersion = "apiextensions.k8s.io/v1beta1"
    kind       = "CustomResourceDefinition"
    metadata = {
      name = "memcacheds.cache.example.com"
    }
    spec = {
      conversion = {
        strategy = "Webhook"
        webhookClientConfig = {
          caBundle = "Cg=="
          service = {
            name      = "webhook-service"
            namespace = "system"
            path      = "/convert"
          }
        }
      }
    }
  }
}
