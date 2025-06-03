# Grafana Redshift Monitoring

This Terraform module deploys Grafana dashboards and alerts for monitoring AWS Redshift clusters.

## Overview

The module creates:
- A Grafana folder for organizing dashboards and alerts. there are 5 panels:
   1. CPU Utilization
   2. WLMQueueWaitTime
   3. QueryExecutionTime
   4. historical trend for last 3 years for CPU Utilization
   5. Alerts panel showing list of alerts and their state
- Alert rules for monitoring critical Redshift metrics
- Slack notification setup for alerts - TBD

## Prerequisites

- Grafana instance with datasources configured(read below for details in "Required Datasources" section)
- AWS Redshift clusters to monitor

## Required Datasources

The following datasources must be configured in your Grafana instance:
- CloudWatch datasources for both DWH and BI clusters
- Redshift datasources for both DWH and BI clusters
- Athena datasources for both DWH and BI clusters

## Usage

1. Update the `dev.tfvars` or `prod.tfvars` file with your environment-specific values:
   - Datasource UIDs for CloudWatch, Redshift, and Athena
   - Slack channel name - TBD

2. Initialize Terraform:
```bash
terraform init
```

3. Apply the configuration:
```bash
terraform apply -var-file=dev.tfvars
```

## Variables

| Name | Description | Required |
|------|-------------|----------|
| grafana_url | URL of the Grafana instance | Yes |
| slack channel name | slack channel to receive alert notifications | Yes |
| DWH_cloudwatch_uid | UID for CloudWatch datasource for DWH cluster | Yes |
| BI_cloudwatch_uid | UID for CloudWatch datasource for BI cluster | Yes |
| DWH_Redshift_uid | UID for Redshift datasource for DWH cluster | Yes |
| BI_Redshift_uid | UID for Redshift datasource for BI cluster | Yes |
| DWH_Athena_uid | UID for Athena datasource for DWH cluster | Yes |
| BI_Athena_uid | UID for Athena datasource for BI cluster | Yes |

## Cluster Identifiers

The module is configured to monitor the following Redshift clusters:
- DWH cluster: `ft-data-reporting-test`
- BI cluster: `ft-data-warehouse-test`

## Customization

To customize the alerts or dashboard, modify the following files:
- `alert_rules.tf`: Contains alert rule definitions
- `dashboard.template.json`: Contains the dashboard template






## TBD:
1. Slack notification to be setup by admin/devops 
2. Slack channel name
3. As per the structure of circleci's config.yml the terraform command won't consider the dev.tfvars. In that case need to check if the required param values need to be put in variables.tf or some such .tf file.