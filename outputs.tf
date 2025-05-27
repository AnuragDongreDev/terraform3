# Dashboard outputs
output "dashboard_url" {
  description = "URL of the deployed Grafana dashboard"
  value       = "${var.grafana_url}/d/${jsondecode(resource.grafana_dashboard.main.config_json).uid}"
}