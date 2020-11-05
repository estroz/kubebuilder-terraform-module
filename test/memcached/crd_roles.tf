resource "kubernetes_manifest" "editor_cluster_roles" {
  manifest = {
    apiVersion = "rbac.authorization.k8s.io/v1"
    kind       = "ClusterRole"
    metadata = {
      name = "memcached-editor-role"
    }
    rules = [
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
          "memcacheds/status",
        ]
        verbs = [
          "get",
        ]
      },
    ]
  }
}

resource "kubernetes_manifest" "viewer_cluster_roles" {
  manifest = {
    apiVersion = "rbac.authorization.k8s.io/v1"
    kind       = "ClusterRole"
    metadata = {
      name = "memcached-viewer-role"
    }
    rules = [
      {
        apiGroups = [
          "cache.example.com",
        ]
        resources = [
          "memcacheds",
        ]
        verbs = [
          "get",
          "list",
          "watch",
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
        ]
      },
    ]
  }
}
