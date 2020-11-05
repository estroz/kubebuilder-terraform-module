resource "kubernetes_manifest" "clusterrole_manager_role" {
  manifest = {
    apiVersion = "rbac.authorization.k8s.io/v1"
    kind       = "ClusterRole"
    metadata = {
      creationTimestamp = null
      name              = "manager-role"
    }
    rules = [
      {
        apiGroups = [
          "apps",
        ]
        resources = [
          "deployments",
        ]
        verbs = [
          "create",
          "delete",
          "get",
          "list",
          "patch",
          "update",
          "watch",
        ]
      },
      {
        apiGroups = [
          "cache.example.com",
        ]
        resources = [
          "memcacheds",
        ]
        verbs = [
          "create",
          "delete",
          "get",
          "list",
          "patch",
          "update",
          "watch",
        ]
      },
      {
        apiGroups = [
          "cache.example.com",
        ]
        resources = [
          "memcacheds/finalizers",
        ]
        verbs = [
          "update",
        ]
      },
      {
        apiGroups = [
          "cache.example.com",
        ]
        resources = [
          "memcacheds/status",
        ]
        verbs = [
          "get",
          "patch",
          "update",
        ]
      },
      {
        apiGroups = [
          "",
        ]
        resources = [
          "pods",
        ]
        verbs = [
          "get",
          "list",
        ]
      },
    ]
  }
}
