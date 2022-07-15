data "azurerm_resource_group" "this" {
  name = var.resource_group_name
}

locals {
  tags =  data.azurerm_resource_group.this.tags

  action_group_ids_map = {
    for x in azurerm_monitor_action_group.this : x.name => x.id
  }
}

resource "azurerm_monitor_action_group" "this" {
  for_each            = var.action_groups
  name                = each.value["name"]
  resource_group_name = data.azurerm_resource_group.this.name
  short_name          = each.value["short_name"]
  enabled             = lookup(each.value, "enabled", null)

  dynamic "email_receiver" {
    for_each = coalesce(lookup(each.value, "email_receivers"), [])
    content {
      name                    = email_receiver.value.name
      email_address           = email_receiver.value.email_address
      use_common_alert_schema = coalesce(lookup(email_receiver.value, "use_common_alert_schema"), true)
    }
  }

  tags = local.tags
}

resource "azurerm_monitor_scheduled_query_rules_alert" "this" {
  for_each            = var.query_rules_alerts
  name                = each.value["name"]
  resource_group_name = data.azurerm_resource_group.this.name
  location            = data.azurerm_resource_group.this.location
  data_source_id      = var.data_source_id
  frequency           = each.value["frequency"]
  query               = <<-QUERY
    ${each.value["query"]}
  QUERY
  time_window         = each.value["time_window"]
  trigger {
    operator  = "GreaterThan"
    threshold = 0
  } 

  dynamic "action" {
    for_each = lookup(each.value, "action_group_names", null) != null ? [lookup(each.value, "action_group_names")] : []
    content {
      action_group = [
        for action_group_name in action.value :
        lookup(local.action_group_ids_map, action_group_name)
      ]
      email_subject = lookup(each.value, "email_subject", null)
    }
  }

 # authorized_resource_ids = list(lookup(var.law_id_map, each.value["law_name"], null))
  description             = lookup(each.value, "description", null)
  enabled                 = coalesce(lookup(each.value, "enabled"), true)
  severity                = lookup(each.value, "severity", null)
  throttling              = lookup(each.value, "throttling", null)

  depends_on = [azurerm_monitor_action_group.this]
}