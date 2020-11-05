resource "kubernetes_manifest" "auth_proxy_client_cluster_role" {
  manifest = {
    apiVersion = "rbac.authorization.k8s.io/v1"
    kind       = "ClusterRole"
    metadata = {
      name = "metrics-reader"
    }
    rules = [
      {
        nonResourceURLs = ["/metrics"]
        verbs           = ["get"]
      },
    ]
  }
}

resource "kubernetes_manifest" "auth_proxy_cluster_role_binding" {
  manifest = {
    apiVersion = "rbac.authorization.k8s.io/v1"
    kind       = "ClusterRoleBinding"
    metadata = {
      name = "proxy-rolebinding"
    }
    roleRef = {
      apiGroup = "rbac.authorization.k8s.io"
      kind     = "ClusterRole"
      name     = "proxy-role"
    }
    subjects = [
      {
        kind      = "ServiceAccount"
        name      = "default"
        namespace = "system"
      },
    ]
  }
}

resource "kubernetes_manifest" "auth_proxy_role" {
  manifest = {
    apiVersion = "rbac.authorization.k8s.io/v1"
    kind       = "ClusterRole"
    metadata = {
      name = "proxy-role"
    }
    rules = [
      {
        apiGroups = ["authentication.k8s.io"]
        resources = ["tokenreviews"]
        verbs     = ["create"]
      },
      {
        apiGroups = ["authorization.k8s.io"]
        resources = ["subjectaccessreviews"]
        verbs     = ["create"]
      },
    ]
  }
}

resource "kubernetes_manifest" "auth_proxy_service" {
  manifest = {
    apiVersion = "v1"
    kind       = "Service"
    metadata = {
      labels = {
        control-plane = "controller-manager"
      }
      name      = "controller-manager-metrics-service"
      namespace = "system"
    }
    spec = {
      ports = [
        {
          name       = "https"
          port       = 8443
          targetPort = "https"
        },
      ]
      selector = {
        control-plane = "controller-manager"
      }
    }
  }
}
