resource "kubernetes_cluster_role" "editor-roles" {

  dynamic "editor_role" {
    for_each = var.resource

    content {
      metadata {
        name = "${editor_role.value.kind}-editor-role"
      }
      rule {
        api_groups = [editor_role.value.domain]
        resources  = [editor_role.value.plural]
        verbs      = ["get", "list", "watch", "create", "update", "patch", "delete"]
      }
      rule {
        api_groups = [editor_role.value.domain]
        resources  = ["${editor_role.value.plural}/status"]
        verbs      = ["get"]
      }
    }
  }
}

resource "kubernetes_cluster_role" "viewer-roles" {

  dynamic "viewer_role" {
    for_each = var.resource

    content {
      metadata {
        name = "${viewer_role.value.kind}-viewer-role"
      }
      rule {
        api_groups = [viewer_role.value.domain]
        resources  = [viewer_role.value.plural]
        verbs      = ["get", "list", "watch"]
      }
      rule {
        api_groups = [viewer_role.value.domain]
        resources  = ["${viewer_role.value.plural}/status"]
        verbs      = ["get"]
      }
    }
  }
}
