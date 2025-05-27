terraform {
  required_version = ">= 1.0.0"
  required_providers {
    grafana = {
      source  = "grafana/grafana"
      version = "~> 1.43.0"
    }
  }
}

# Variables
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

# Provider configuration
provider "grafana" {
  url  = var.grafana_url
  auth = var.grafana_auth
}

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