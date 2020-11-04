resource "kubernetes_cluster_role_binding" "proxy-role-binding" {
  metadata {
    name = "proxy-role-binding"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "proxy-role"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "default"
    namespace = "system"
  }
}

resource "kubernetes_cluster_role" "proxy-role" {
  metadata {
    name = "proxy-role"
  }
  rule {
    api_groups = ["authentication.k8s.io"]
    resources  = ["tokenreviews"]
    verbs      = ["create"]
  }
  rule {
    api_groups = ["authorization.k8s.io"]
    resources  = ["subjectaccessreviews"]
    verbs      = ["create"]
  }
}

resource "kubernetes_service" "controller-manager-metrics-service" {
  metadata {
    name      = "controller-manager-metrics-service"
    namespace = "system"
    labels = {
      control-plane = "controller-manager"
    }
  }
  spec {
    port {
      name        = "https"
      port        = 8443
      target_port = "https"
    }
    selector = {
      control-plane = "controller-manager"
    }
  }
}


resource "kubernetes_cluster_role" "metrics-reader-role" {
  metadata {
    name = "metrics-reader-role"
  }
  rule {
    non_resource_urls = ["/metrics"]
    verbs             = ["get"]
  }
}
