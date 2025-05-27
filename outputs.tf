output "dashboard_url" {
  description = "URL of the deployed Grafana dashboard"
  value       = "${var.grafana_url}/d/${jsondecode(resource.grafana_dashboard.main.config_json).uid}"
}

output "folder_id" {
  description = "ID of the created Grafana folder"
  value       = grafana_folder.monitoring.id
}