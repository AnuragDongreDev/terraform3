# Create folder for dashboards
resource "grafana_folder" "monitoring" {
  title = var.folder_name
}

# Deploy dashboard
resource "grafana_dashboard" "main" {
  folder      = grafana_folder.monitoring.id
  config_json = file("${path.module}/${var.dashboard_path}")
  overwrite   = true
}