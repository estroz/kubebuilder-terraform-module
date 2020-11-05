resource "kubernetes_manifest" "ontroller_manager_service_monitor" {
  manifest = {
    apiVersion = "monitoring.coreos.com/v1"
    kind       = "ServiceMonitor"
    metadata = {
      labels = {
        control-plane = "controller-manager"
      }
      name      = "controller-manager-metrics-monitor"
      namespace = "system"
    }
    spec = {
      endpoints = [
        {
          path = "/metrics"
          port = "https"
        },
      ]
      selector = {
        matchLabels = {
          control-plane = "controller-manager"
        }
      }
    }
  }
}