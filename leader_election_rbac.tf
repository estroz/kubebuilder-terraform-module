resource "kubernetes_role_binding" "leader-election-role-binding" {
  metadata {
    name = "leader-election-role-binding"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "leader-election-role"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "default"
    namespace = "system"
  }
}

resource "kubernetes_role" "leader-election-role" {
  metadata {
    name = "leader-election-role"
  }
  rule {
    api_groups = [""]
    resources  = ["configmaps"]
    verbs      = ["get", "list", "watch", "create", "update", "patch", "delete"]
  }
  rule {
    api_groups = [""]
    resources  = ["events"]
    verbs      = ["create", "patch"]
  }
}
