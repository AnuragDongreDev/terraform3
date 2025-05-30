# Create folder for dashboards
resource "grafana_folder" "monitoring" {
  title = var.folder_name
}

# Deploy dashboard
resource "grafana_dashboard" "main" {
  folder      = grafana_folder.monitoring.id
  config_json = templatefile("${path.module}/dashboard.template.json",
  {
  DWH_cloudwatch_uid = var.DWH_cloudwatch_uid
  BI_cloudwatch_uid = var.BI_cloudwatch_uid
  DWH_Redshift_uid = var.DWH_Redshift_uid
  BI_Redshift_uid = var.BI_Redshift_uid
  DWH_Athena_uid = var.DWH_Athena_uid
  BI_Athena_uid = var.BI_Athena_uid
  })
  overwrite   = true
}
