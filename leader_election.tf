resource "kubernetes_manifest" "leader_election_role_binding" {
  manifest = {
    apiVersion = "rbac.authorization.k8s.io/v1"
    kind       = "RoleBinding"
    metadata = {
      name = "leader-election-rolebinding"
    }
    roleRef = {
      apiGroup = "rbac.authorization.k8s.io"
      kind     = "Role"
      name     = "leader-election-role"
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

resource "kubernetes_manifest" "leader_election_role" {
  manifest = {
    apiVersion = "rbac.authorization.k8s.io/v1"
    kind       = "Role"
    metadata = {
      name = "leader-election-role"
    }
    rules = [
      {
        apiGroups = [""]
        resources = ["configmaps"]
        verbs     = ["get", "list", "watch", "create", "update", "patch", "delete"]
      },
      {
        apiGroups = [""]
        resources = ["configmaps/status"]
        verbs     = ["get", "update", "patch"]
      },
      {
        apiGroups = [""]
        resources = ["events"]
        verbs     = ["create", "patch"]
      },
    ]
  }
}
