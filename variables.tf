variable "grafana_url" {
  description = "URL of the Grafana instance"
  type        = string
  default     = "http://localhost:3000"
}

variable "grafana_auth" {
  description = "Authentication credentials for Grafana"
  type        = string
  sensitive   = true
  default     = "admin:admin"  # Default for local development only
}

variable "folder_name" {
  description = "Grafana folder to store the dashboard"
  type        = string
  default     = "Redshift Monitoring"
}

variable "alert_email" {
  description = "Email address to receive alert notifications"
  type        = string
  default     = "anuragdongre198609@gmail.com"
}

variable "DWH_cloudwatch_uid" {
  description = "UID for cloudwatch datasource defined in grafana for the Redshift cluster - DWH"
  type        = string
}
variable "BI_cloudwatch_uid" {
  description = "UID for cloudwatch datasource defined in grafana for the Redshift cluster - BI"
  type        = string
}

variable "DWH_Redshift_uid" {
  description = "UID for Redshift datasource defined in grafana for the Redshift cluster - DWH"
  type        = string
}

variable "BI_Redshift_uid" {
  description = "UID for Redshift datasource defined in grafana for the Redshift cluster - BI"
  type        = string
}

variable "DWH_Athena_uid" {
  description = "UID for Athena datasource defined in grafana for the Redshift cluster - DWH"
  type        = string
}

variable "BI_Athena_uid" {
  description = "UID for Athena datasource defined in grafana for the Redshift cluster - BI"
  type        = string
}