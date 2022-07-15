resource_group_name = "Deployment" # "<resource_group_name>"

action_groups = {
  ag1 = {
    name                     = "test"
    short_name               = "test"
    enabled                  =  true
    email_receivers = [{
      name                    = "test"
      email_address           = "test@gmail.com"
      use_common_alert_schema = true
    }]
  }
}

query_rules_alerts = {
  qra1 = {
    name               = "cpu-utilization-alert"
    law_name           = "temp-ansible"
    frequency          = 5
    time_window        = 30
    action_group_names = ["test"]
    email_subject      = null
    description        = "CPU Utilization"
    enabled            = true
    severity           = 1
    throttling         = 5
    query              = <<-EOT
        InsightsMetrics
            | where Origin == "vm.azm.ms" 
            | where Namespace == "Processor" and Name == "UtilizationPercentage" 
            | summarize AggregatedValue = avg(Val) by bin(TimeGenerated, 15m), Computer, _ResourceId
      EOT
    trigger = {
      operator  = "GreaterThan"
      threshold = 3
      metric_trigger = {
        operator            = "GreaterThan"
        threshold           = 1
        metric_trigger_type = "Total"
        metric_column       = "operation_Name"
      }
    }
  }

  qra2 = {
    name               = "cpu-utilization"
    law_name           = "temp-ansible"
    frequency          = 5
    time_window        = 30
    action_group_names = ["test"]
    email_subject      = null
    description        = "CPU Utilization"
    enabled            = true
    severity           = 1
    throttling         = 5
    query              = <<-EOT
        InsightsMetrics
            | where Origin == "vm.azm.ms" 
            | where Namespace == "Processor" and Name == "UtilizationPercentage" 
            | summarize AggregatedValue = avg(Val) by bin(TimeGenerated, 15m), Computer, _ResourceId
      EOT
    trigger = {
      operator  = "GreaterThan"
      threshold = 3
      metric_trigger = {
        operator            = "GreaterThan"
        threshold           = 1
        metric_trigger_type = "Total"
        metric_column       = "operation_Name"
      }
    }
  }
}


additional_tags = {
  iac = "Terraform"
  env = "DEV"
}

data_source_id = "/subscriptions/14bd8c10-e331-4e85-b9d5-f011e1bf485c/resourceGroups/Deployment/providers/Microsoft.ContainerService/managedClusters/temp-ansible"