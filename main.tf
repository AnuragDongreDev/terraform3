provider "grafana" {
  url  = "http://localhost:3000"
  auth = "admin:admin"  # or use env vars for secrets
}



terraform {
  required_providers {
    grafana = {
      source  = "grafana/grafana"
      version = "~> 1.0"  # or latest compatible version
    }
  }
}



resource "grafana_dashboard" "main" {
  config_json = file("${path.module}/dashboard.json")
}
