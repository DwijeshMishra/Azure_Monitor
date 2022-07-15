variable "resource_group_name" {
  type        = string
  description = " The name of the resource group in which to create the Action Group instance."
}

variable "action_groups" {
  type = map(object({
    name       = string
    short_name = string
    enabled    = bool
    email_receivers = list(object({
      name                    = string
      email_address           = string
      use_common_alert_schema = bool
    }))
  }))
  description = "Map of Azure Monitor Action Groups Specification."
}

variable "query_rules_alerts" {
  type = map(object({
    name               = string
    law_name           = string
    frequency          = number
    query              = string
    time_window        = number
    email_subject      = string
    description        = string
    enabled            = bool
    severity           = number
    throttling         = number
    action_group_names = list(string)
    trigger = object({
      operator  = string
      threshold = number
      metric_trigger = object({
        metric_column       = string
        metric_trigger_type = string
        operator            = string
        threshold           = number
      })
    })
  }))
  description = "Map of Azure Monitor Scheduled Query Rules Alerts Specification."
}

variable "law_id_map" {
  type        = map(string)
  description = "Specifies the Map of Log Analytics Workspace Id's."
  default     = {}
}

variable "data_source_id" {
  type = string
  description = "data source id to attach alert and action log like aks sub id"
}