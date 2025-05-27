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


variable "DWH-cloudwatch_uid" {
  description = "UID for cloudwatch datasource defined in grafana for the Redshift cluster - DWH"
  type        = string
}
variable "BI-cloudwatch_uid" {
  description = "UID for cloudwatch datasource defined in grafana for the Redshift cluster - BI"
  type        = string
}

variable "DWH-Redshift_uid" {
  description = "UID for Redshift datasource defined in grafana for the Redshift cluster - DWH"
  type        = string
}

variable "BI-Redshift_uid" {
  description = "UID for Redshift datasource defined in grafana for the Redshift cluster - BI"
  type        = string
}

variable "DWH-Athena_uid" {
  description = "UID for Athena datasource defined in grafana for the Redshift cluster - DWH"
  type        = string
}

variable "BI-Athena_uid" {
  description = "UID for Athena datasource defined in grafana for the Redshift cluster - BI"
  type        = string
}