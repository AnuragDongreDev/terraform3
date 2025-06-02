# Use the same folder for both dashboards and alerts
resource "grafana_folder" "monitoring_folder" {
  title = "DPM-Redshift Monitoring"
}

# Deploy dashboard
resource "grafana_dashboard" "main" {
  folder = grafana_folder.monitoring_folder.id
  config_json = templatefile("${path.module}/dashboard.template.json",
    {
      DWH_cloudwatch_uid = var.DWH_cloudwatch_uid
      BI_cloudwatch_uid  = var.BI_cloudwatch_uid
      DWH_Redshift_uid   = var.DWH_Redshift_uid
      BI_Redshift_uid    = var.BI_Redshift_uid
      DWH_Athena_uid     = var.DWH_Athena_uid
      BI_Athena_uid      = var.BI_Athena_uid
  })
  overwrite = true
}
