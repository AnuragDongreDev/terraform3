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

variable "dashboard_path" {
  description = "Path to the dashboard JSON file"
  type        = string
  default     = "dashboard.json"
}

variable "folder_name" {
  description = "Grafana folder to store the dashboard"
  type        = string
  default     = "Redshift Monitoring"
}