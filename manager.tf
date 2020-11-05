resource "kubernetes_manifest" "namespace_system" {
  manifest = {
    apiVersion = "v1"
    kind       = "Namespace"
    metadata = {
      labels = {
        control-plane = "controller-manager"
      }
      name = "system"
    }
  }
}

resource "kubernetes_manifest" "deployment_controller_manager" {
  manifest = {
    apiVersion = "apps/v1"
    kind       = "Deployment"
    metadata = {
      labels = {
        control-plane = "controller-manager"
      }
      name      = "controller-manager"
      namespace = "system"
    }
    spec = {
      replicas = 1
      selector = {
        matchLabels = {
          control-plane = "controller-manager"
        }
      }
      template = {
        metadata = {
          labels = {
            control-plane = "controller-manager"
          }
        }
        spec = {
          containers = [
            {
              args = [
                "--enable-leader-election",
              ]
              command = ["/manager"]
              image   = "controller:latest"
              name    = "manager"
              resources = {
                limits = {
                  cpu    = "100m"
                  memory = "30Mi"
                }
                requests = {
                  cpu    = "100m"
                  memory = "20Mi"
                }
              }
            },
          ]
          terminationGracePeriodSeconds = 10
        }
      }
    }
  }
}

resource "kubernetes_manifest" "deployment_controller_manager_webhook_patch" {
  manifest = {
    apiVersion = "apps/v1"
    kind       = "Deployment"
    metadata = {
      name      = "controller-manager"
      namespace = "system"
    }
    spec = {
      template = {
        spec = {
          containers = [
            {
              name = "manager"
              ports = [
                {
                  containerPort = 9443
                  name          = "webhook-server"
                  protocol      = "TCP"
                },
              ]
              volumeMounts = [
                {
                  mountPath = "/tmp/k8s-webhook-server/serving-certs"
                  name      = "cert"
                  readOnly  = true
                },
              ]
            },
          ]
          volumes = [
            {
              name = "cert"
              secret = {
                defaultMode = 420
                secretName  = "webhook-server-cert"
              }
            },
          ]
        }
      }
    }
  }
}

resource "kubernetes_manifest" "deployment_controller_manager_auth_proxy_patch" {
  manifest = {
    apiVersion = "apps/v1"
    kind       = "Deployment"
    metadata = {
      name      = "controller-manager"
      namespace = "system"
    }
    spec = {
      template = {
        spec = {
          containers = [
            {
              args = [
                "--secure-listen-address=0.0.0.0:8443",
                "--upstream=http://127.0.0.1:8080/",
                "--logtostderr=true",
                "--v=10",
              ]
              image = "gcr.io/kubebuilder/kube-rbac-proxy:v0.5.0"
              name  = "kube-rbac-proxy"
              ports = [
                {
                  containerPort = 8443
                  name          = "https"
                },
              ]
            },
            {
              args = [
                "--metrics-addr=127.0.0.1:8080",
                "--enable-leader-election",
              ]
              name = "manager"
            },
          ]
        }
      }
    }
  }
}
