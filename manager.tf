resource "kubernetes_namespace" "controller-manager" {
  metadata {
    name = "system"
    labels = {
      control-plane = "controller-manager"
    }
  }
}

resource "kubernetes_deployment" "controller-manager" {
  metadata {
    name      = "controller-manager"
    namespace = "system"
    labels = {
      control-plane = "controller-manager"
    }
  }
  spec {
    selector {
      match_labels = {
        control-plane = "controller-manager"
      }
    }
    replicas = 1
    template {
      metadata {
        labels = {
          control-plane = "controller-manager"
        }
      }
      spec {
        security_context {
          run_as_user = 65532
        }
        container {
          command = ["/manager"]
          args    = ["--enable-leader-election"]
          image   = var.image_name
          name    = "manager"
          security_context {
            allow_privilege_escalation = false
          }
          resources {
            limits {
              cpu    = "100m"
              memory = "30Mi"
            }
            requests {
              cpu    = "100m"
              memory = "20Mi"
            }
          }
        }
        termination_grace_period_seconds = 10
      }
    }
  }
}

# TODO: this is a patch, figure out how to conditionally add it it controller-manager Deployment above.
resource "kubernetes_deployment" "controller-manager-webhook-patch" {
  metadata {
    name      = "controller-manager"
    namespace = "system"
  }
  spec {
    template {
      metadata {}
      spec {
        container {
          name = "manager"
          port {
            container_port = 9443
            name           = "webhook-server"
            protocol       = "TCP"
          }
          volume_mount {
            mount_path = "/tmp/k8s-webhook-server/serving-certs"
            name       = "cert"
            read_only  = true
          }
        }
        volume {
          name = "cert"
          secret {
            default_mode = 0420
            secret_name  = "webhook-server-cert"
          }
        }
      }
    }
  }
}

# TODO: this is a patch, figure out how to conditionally add it it controller-manager Deployment above.
resource "kubernetes_deployment" "controller-manager-auth-proxy-patch" {
  metadata {
    name      = "controller-manager"
    namespace = "system"
  }
  spec {
    template {
      metadata {}
      spec {
        container {
          name  = "kube-rbac-proxy"
          image = "gcr.io/kubebuilder/kube-rbac-proxy:v0.5.0"
          args  = ["--secure-listen-address=0.0.0.0:8443", "--upstream=http://127.0.0.1:8080/", "--logtostderr=true", "--v=10"]
          port {
            container_port = 8443
            name           = "https"
          }
        }
        container {
          name = "manager"
          args = ["--metrics-addr=127.0.0.1:8080", "--enable-leader-election"]
        }
      }
    }
  }
}

resource "kubernetes_cluster_role_binding" "manager-role-binding" {
  metadata {
    name = "manager-role-binding"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "manager-role"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "default"
    namespace = "system"
  }
}
