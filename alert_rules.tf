# Create alert folder
resource "grafana_folder" "alerts_folder" {
  title = "Redshift_Monitoring_AlertsFolder"
}

# Create contact point for email notifications
resource "grafana_contact_point" "email" {
  name = "AnuragContactPoint"
  
  email {
    addresses = [var.alert_email]
    message   = "{{ .Message }}"
    subject   = "{{ .Title }}"
  }
}

# Create notification policy
resource "grafana_notification_policy" "default_policy" {
  group_by        = ["alertname"]
  contact_point   = grafana_contact_point.email.name
  group_wait      = "30s"
  group_interval  = "5m"
  repeat_interval = "4h"
}

# Create alert rule for DWH and BI CPUUtilization
resource "grafana_rule_group" "cpu_alerts" {
  name             = "NewEvaluationGroup1"
  folder_uid       = grafana_folder.alerts_folder.uid
  interval_seconds = 60 # 1m
  org_id           = 1
  
  rule {
    name           = "Alert_for_CPUUtilization_DWH"
    for            = "1m"
    condition      = "C"
    no_data_state  = "NoData"
    exec_err_state = "Error"
    
    annotations = {
      summary = "CPUUtilization threshold for DWH cluster breached"
    }
    
    data {
      ref_id = "A"
      relative_time_range {
        from = 259200
        to   = 172800
      }
      datasource_uid = var.DWH_cloudwatch_uid
      
      model = jsonencode({
        dimensions = {
          ClusterIdentifier = "redshift-cluster-ft-grafana"
        }
        metricName      = "CPUUtilization"
        namespace       = "AWS/Redshift"
        statistic       = "Maximum"
        metricQueryType = 0
        metricEditorMode = 0
        queryMode       = "Metrics"
        region          = "default"
      })
    }
    
    data {
      ref_id        = "B"
      datasource_uid = "__expr__"
      relative_time_range {
        from = 259200
        to   = 172800
      }
      
      model = jsonencode({
        expression   = "A"
        reducer      = "max"
        type         = "reduce"
      })
    }
    
    data {
      ref_id        = "C"
      datasource_uid = "__expr__"
      relative_time_range {
        from = 259200
        to   = 172800
      }
      
      model = jsonencode({
        expression = "B"
        type       = "threshold"
        conditions = [
          {
            evaluator = {
              params = [20]
              type   = "gt"
            }
            operator = {
              type = "and"
            }
            reducer = {
              type = "last"
            }
            type = "query"
          }
        ]
      })
    }
  }
  
  rule {
    name           = "Alert_for_CPUUtilization_BI"
    for            = "1m"
    condition      = "C"
    no_data_state  = "NoData"
    exec_err_state = "Error"
    
    annotations = {
      summary = "CPUUtilization threshold for BI cluster breached"
    }
    
    data {
      ref_id = "A"
      relative_time_range {
        from = 259200
        to   = 172800
      }
      datasource_uid = var.BI_cloudwatch_uid
      
      model = jsonencode({
        dimensions = {
          ClusterIdentifier = "redshift-cluster-ft-grafana"
        }
        metricName      = "CPUUtilization"
        namespace       = "AWS/Redshift"
        statistic       = "Maximum"
        metricQueryType = 0
        metricEditorMode = 0
        queryMode       = "Metrics"
        region          = "default"
      })
    }
    
    data {
      ref_id        = "B"
      datasource_uid = "__expr__"
      relative_time_range {
        from = 259200
        to   = 172800
      }
      
      model = jsonencode({
        expression   = "A"
        reducer      = "max"
        type         = "reduce"
      })
    }
    
    data {
      ref_id        = "C"
      datasource_uid = "__expr__"
      relative_time_range {
        from = 259200
        to   = 172800
      }
      
      model = jsonencode({
        expression = "B"
        type       = "threshold"
        conditions = [
          {
            evaluator = {
              params = [20]
              type   = "gt"
            }
            operator = {
              type = "and"
            }
            reducer = {
              type = "last"
            }
            type = "query"
          }
        ]
      })
    }
  }
}
