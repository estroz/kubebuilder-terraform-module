resource "kubernetes_manifest" "clusterrolebinding_manager_rolebinding" {
  manifest = {
    apiVersion = "rbac.authorization.k8s.io/v1"
    kind       = "ClusterRoleBinding"
    metadata = {
      name = "manager-rolebinding"
    }
    roleRef = {
      apiGroup = "rbac.authorization.k8s.io"
      kind     = "ClusterRole"
      name     = "manager-role"
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
