terraform {
  required_version = ">= 1.0.0"
  required_providers {
    grafana = {
      source  = "grafana/grafana"
      version = "~> 1.43.0"
    }
  }
}

provider "grafana" {
  url  = var.grafana_url
}