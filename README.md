# Grafana Dashboard Deployment with Terraform

This project deploys Grafana dashboards for monitoring Redshift clusters across multiple AWS accounts using Terraform.

## Project Structure

- `dashboard.template.json` - Template for Grafana dashboard with variable placeholders
- `main.tf` - Terraform configuration for deploying the dashboard
- `variables.tf` - Variable definitions
- `providers.tf` - Provider configuration
- `outputs.tf` - Output definitions
- `dev.tfvars` - Development environment variables
- `prod.tfvars` - Production environment variables

## Setup Instructions

### 1. Create Template Dashboard

1. Export your dashboard from Grafana as JSON
2. Rename it to `dashboard.template.json`
3. Replace all hardcoded datasource UIDs with variables:

```json
"datasource": {
  "type": "cloudwatch",
  "uid": "${DWH-cloudwatch_uid}"
}
```

4. Make sure to replace UIDs in both locations:
   - Panel-level datasource: `panels[].datasource.uid`
   - Target-level datasource: `panels[].targets[].datasource.uid`

### 2. Define Variables

Create `variables.tf` with all required variables:

```hcl
variable "DWH-cloudwatch_uid" {
  description = "UID for CloudWatch datasource for DWH cluster"
  type        = string
}

variable "BI-cloudwatch_uid" {
  description = "UID for CloudWatch datasource for BI cluster"
  type        = string
}

# Add other datasource UIDs as needed
```

### 3. Configure Main Terraform File

Update `main.tf` to use the template:

```hcl
resource "grafana_dashboard" "main" {
  folder      = grafana_folder.monitoring.id
  config_json = templatefile("${path.module}/dashboard.template.json", {
    DWH-cloudwatch_uid = var.DWH-cloudwatch_uid
    BI-cloudwatch_uid = var.BI-cloudwatch_uid
    DWH-Redshift_uid = var.DWH-Redshift_uid
    BI-Redshift_uid = var.BI-Redshift_uid
    DWH-Athena_uid = var.DWH-Athena_uid
    BI-Athena_uid = var.BI-Athena_uid
  })
  overwrite   = true
}
```

### 4. Create Environment-Specific Variable Files

Create `dev.tfvars` for development:

```hcl
DWH-cloudwatch_uid = "dev-dwh-cloudwatch-uid"
BI-cloudwatch_uid = "dev-bi-cloudwatch-uid"
DWH-Redshift_uid = "dev-dwh-redshift-uid"
BI-Redshift_uid = "dev-bi-redshift-uid"
DWH-Athena_uid = "dev-dwh-athena-uid"
BI-Athena_uid = "dev-bi-athena-uid"
```

Create `prod.tfvars` for production:

```hcl
DWH-cloudwatch_uid = "prod-dwh-cloudwatch-uid"
BI-cloudwatch_uid = "prod-bi-cloudwatch-uid"
DWH-Redshift_uid = "prod-dwh-redshift-uid"
BI-Redshift_uid = "prod-bi-redshift-uid"
DWH-Athena_uid = "prod-dwh-athena-uid"
BI-Athena_uid = "prod-bi-athena-uid"
```

### 5. Finding UIDs in Grafana

To find the UIDs of datasources in each environment:

1. Log into the Grafana instance
2. Go to Configuration > Data Sources
3. Click on a data source
4. Look at the URL - it contains the UID (e.g., `/datasources/edit/abc123def456`)
5. Record these UIDs in your environment-specific .tfvars files

### 6. Deployment

Deploy to development:

```bash
terraform init
terraform apply -var-file=dev.tfvars
```

Deploy to production:

```bash
terraform init
terraform apply -var-file=prod.tfvars
```

## Usage

```bash
# Initialize Terraform
terraform init

# Preview changes
terraform plan -var-file=dev.tfvars

# Apply changes
terraform apply -var-file=dev.tfvars

# To use custom values
terraform apply -var-file=dev.tfvars -var="grafana_url=http://grafana.example.com" -var="folder_name=Production"
```

## Variables

| Name | Description | Default |
|------|-------------|---------|
| grafana_url | URL of the Grafana instance | http://localhost:3000 |
| grafana_auth | Authentication credentials | admin:admin |
| folder_name | Grafana folder name | Redshift Monitoring |
| DWH-cloudwatch_uid | UID for CloudWatch datasource for DWH cluster | (no default) |
| BI-cloudwatch_uid | UID for CloudWatch datasource for BI cluster | (no default) |
| DWH-Redshift_uid | UID for Redshift datasource for DWH cluster | (no default) |
| BI-Redshift_uid | UID for Redshift datasource for BI cluster | (no default) |
| DWH-Athena_uid | UID for Athena datasource for DWH cluster | (no default) |
| BI-Athena_uid | UID for Athena datasource for BI cluster | (no default) |

## Security Note

For production use, do not store credentials in the code. Use environment variables:

```bash
export TF_VAR_grafana_auth="apikey:yourapikey"
terraform apply -var-file=prod.tfvars
```

## Notes

- This approach allows the same dashboard to be deployed across different environments
- Each environment can use its own data sources with different UIDs
- The dashboard template can show data from multiple AWS accounts in the same panel
- Make sure to update the .tfvars files when data source UIDs change in any environment