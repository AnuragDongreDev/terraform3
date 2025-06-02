# Create contact point for email notifications - this worked for me but we will need to change it for slcak
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

# Create additional alert rules for Redshift monitoring
resource "grafana_rule_group" "redshift_monitoring_alerts" {
  name             = "Redshift_Monitoring_EG4"
  folder_uid       = grafana_folder.monitoring_folder.uid
  interval_seconds = 60 # 1m
  org_id           = 1

  # Alert for WLMQueue DWH
  rule {
    name           = "Alert_for_WLMQueue_DWH"
    for            = "5m"
    condition      = "C"
    no_data_state  = "NoData"
    exec_err_state = "Error"

    annotations = {
      summary = "WLMQueueWaitTime on DWH Redshift cluster has been >1m for more than 5minutes or more."
    }

    data {
      ref_id = "A"
      relative_time_range {
        from = 300
        to   = 0
      }
      datasource_uid = var.DWH_cloudwatch_uid

      model = jsonencode({
        dimensions = {
          ClusterIdentifier = "redshift-cluster-ft-grafana"
        }
        metricName       = "WLMQueueWaitTime"
        namespace        = "AWS/Redshift"
        statistic        = "Maximum"
        metricQueryType  = 0
        metricEditorMode = 0
        queryMode        = "Metrics"
        region           = "default"
      })
    }

    data {
      ref_id         = "B"
      datasource_uid = "__expr__"
      relative_time_range {
        from = 300
        to   = 0
      }

      model = jsonencode({
        expression = "A"
        reducer    = "last"
        type       = "reduce"
      })
    }

    data {
      ref_id         = "C"
      datasource_uid = "__expr__"
      relative_time_range {
        from = 300
        to   = 0
      }

      model = jsonencode({
        expression = "B"
        type       = "threshold"
        conditions = [
          {
            evaluator = {
              params = [60000]
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

  # Alert for WLMQueue BI
  rule {
    name           = "Alert_for_WLMQueue_BI"
    for            = "5m"
    condition      = "C"
    no_data_state  = "NoData"
    exec_err_state = "Error"

    annotations = {
      summary = "WLMQueueWaitTime on BI Redshift cluster has been >1m for more than 5minutes or more."
    }

    data {
      ref_id = "A"
      relative_time_range {
        from = 300
        to   = 0
      }
      datasource_uid = var.BI_cloudwatch_uid

      model = jsonencode({
        dimensions = {
          ClusterIdentifier = "redshift-cluster-ft-grafana"
        }
        metricName       = "WLMQueueWaitTime"
        namespace        = "AWS/Redshift"
        statistic        = "Maximum"
        metricQueryType  = 0
        metricEditorMode = 0
        queryMode        = "Metrics"
        region           = "default"
      })
    }

    data {
      ref_id         = "B"
      datasource_uid = "__expr__"
      relative_time_range {
        from = 300
        to   = 0
      }

      model = jsonencode({
        expression = "A"
        reducer    = "last"
        type       = "reduce"
      })
    }

    data {
      ref_id         = "C"
      datasource_uid = "__expr__"
      relative_time_range {
        from = 300
        to   = 0
      }

      model = jsonencode({
        expression = "B"
        type       = "threshold"
        conditions = [
          {
            evaluator = {
              params = [60000]
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

  # Alert for CPUUtilization DWH (higher threshold)
  rule {
    name           = "Alert_for_CPUUtilization_DWH_High"
    for            = "5m"
    condition      = "C"
    no_data_state  = "NoData"
    exec_err_state = "Error"

    annotations = {
      summary = "CPUUtilization threshold for DWH cluster breached"
    }

    data {
      ref_id = "A"
      relative_time_range {
        from = 600
        to   = 0
      }
      datasource_uid = var.DWH_cloudwatch_uid

      model = jsonencode({
        dimensions = {
          ClusterIdentifier = "redshift-cluster-ft-grafana"
        }
        metricName       = "CPUUtilization"
        namespace        = "AWS/Redshift"
        statistic        = "Maximum"
        metricQueryType  = 0
        metricEditorMode = 0
        queryMode        = "Metrics"
        region           = "us-east-1"
      })
    }

    data {
      ref_id         = "B"
      datasource_uid = "__expr__"
      relative_time_range {
        from = 600
        to   = 0
      }

      model = jsonencode({
        expression = "A"
        reducer    = "max"
        type       = "reduce"
      })
    }

    data {
      ref_id         = "C"
      datasource_uid = "__expr__"
      relative_time_range {
        from = 600
        to   = 0
      }

      model = jsonencode({
        expression = "B"
        type       = "threshold"
        conditions = [
          {
            evaluator = {
              params = [85]
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

  # Alert for CPUUtilization BI (higher threshold)
  rule {
    name           = "Alert_for_CPUUtilization_BI_High"
    for            = "5m"
    condition      = "C"
    no_data_state  = "NoData"
    exec_err_state = "Error"

    annotations = {
      summary = "CPUUtilization threshold for BI cluster breached"
    }

    data {
      ref_id = "A"
      relative_time_range {
        from = 600
        to   = 0
      }
      datasource_uid = var.BI_cloudwatch_uid

      model = jsonencode({
        dimensions = {
          ClusterIdentifier = "redshift-cluster-ft-grafana"
        }
        metricName       = "CPUUtilization"
        namespace        = "AWS/Redshift"
        statistic        = "Maximum"
        metricQueryType  = 0
        metricEditorMode = 0
        queryMode        = "Metrics"
        region           = "us-east-1"
      })
    }

    data {
      ref_id         = "B"
      datasource_uid = "__expr__"
      relative_time_range {
        from = 600
        to   = 0
      }

      model = jsonencode({
        expression = "A"
        reducer    = "max"
        type       = "reduce"
      })
    }

    data {
      ref_id         = "C"
      datasource_uid = "__expr__"
      relative_time_range {
        from = 600
        to   = 0
      }

      model = jsonencode({
        expression = "B"
        type       = "threshold"
        conditions = [
          {
            evaluator = {
              params = [85]
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

  # Alert for QueryExecutionTime DWH
  rule {
    name           = "Alert_for_QueryExecutionTime_DWH"
    for            = "5m"
    condition      = "C"
    no_data_state  = "NoData"
    exec_err_state = "Error"

    annotations = {
      summary = "QueryExecutionTime on DWH Redshift cluster has been >1m for more than 5minutes or more."
    }

    data {
      ref_id = "A"
      relative_time_range {
        from = 300
        to   = 0
      }
      datasource_uid = var.DWH_Redshift_uid

      model = jsonencode({
        rawSQL = <<-EOT
          SELECT
            MAX(EXTRACT(EPOCH FROM endtime - starttime)) AS max_execution_time_seconds
          FROM
            stl_query
          WHERE
            userid > 1
            AND starttime >= getdate() - interval '5 minutes'
            AND endtime IS NOT NULL;
        EOT
      })
    }

    data {
      ref_id         = "C"
      datasource_uid = "__expr__"
      relative_time_range {
        from = 300
        to   = 0
      }

      model = jsonencode({
        expression = "A"
        type       = "threshold"
        conditions = [
          {
            evaluator = {
              params = [180]
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

  # Alert for QueryExecutionTime BI
  rule {
    name           = "Alert_for_QueryExecutionTime_BI"
    for            = "5m"
    condition      = "C"
    no_data_state  = "NoData"
    exec_err_state = "Error"

    annotations = {
      summary = "QueryExecutionTime on BI Redshift cluster has been >1m for more than 5minutes or more."
    }

    data {
      ref_id = "A"
      relative_time_range {
        from = 300
        to   = 0
      }
      datasource_uid = var.BI_Redshift_uid

      model = jsonencode({
        rawSQL = <<-EOT
          SELECT
            MAX(EXTRACT(EPOCH FROM endtime - starttime)) AS max_execution_time_seconds
          FROM
            stl_query
          WHERE
            userid > 1
            AND starttime >= getdate() - interval '5 minutes'
            AND endtime IS NOT NULL;
        EOT
      })
    }

    data {
      ref_id         = "C"
      datasource_uid = "__expr__"
      relative_time_range {
        from = 300
        to   = 0
      }

      model = jsonencode({
        expression = "A"
        type       = "threshold"
        conditions = [
          {
            evaluator = {
              params = [180]
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