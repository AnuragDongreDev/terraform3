# Create folder for dashboards
resource "grafana_folder" "monitoring" {
  title = var.folder_name
}

# Deploy dashboard
resource "grafana_dashboard" "main" {
  folder      = grafana_folder.monitoring.id
  config_json = templatefile("${path.module}/dashboard.template.json",
  {
  DWH-cloudwatch_uid = var.DWH-cloudwatch_uid
  BI-cloudwatch_uid = var.BI-cloudwatch_uid
  DWH-Redshift_uid = var.DWH-Redshift_uid
  BI-Redshift_uid = var.BI-Redshift_uid
  DWH-Athena_uid = var.DWH-Athena_uid
  BI-Athena_uid = var.BI-Athena_uid
  })
  overwrite   = true
}