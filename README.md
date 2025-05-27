# Grafana Dashboard Deployment

This Terraform project deploys Redshift monitoring dashboards to Grafana.

## Structure

- `main.tf` - Core resources (folders and dashboards)
- `variables.tf` - Input variable definitions
- `outputs.tf` - Output definitions
- `providers.tf` - Provider configuration
- `versions.tf` - Terraform version requirements
- `dashboard.json` - Grafana dashboard definition

## Usage

```bash
# Initialize Terraform
terraform init

# Preview changes
terraform plan

# Apply changes
terraform apply

# To use custom values
terraform apply -var="grafana_url=http://grafana.example.com" -var="folder_name=Production"
```

## Variables

| Name | Description | Default |
|------|-------------|---------|
| grafana_url | URL of the Grafana instance | http://localhost:3000 |
| grafana_auth | Authentication credentials | admin:admin |
| dashboard_path | Path to dashboard JSON | dashboard.json |
| folder_name | Grafana folder name | Redshift Monitoring |

## Security Note

For production use, do not store credentials in the code. Use environment variables:

```bash
export TF_VAR_grafana_auth="apikey:yourapikey"
terraform apply
```