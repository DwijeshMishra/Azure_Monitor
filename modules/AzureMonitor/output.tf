output "action_group_ids" {
  value = [for x in azurerm_monitor_action_group.this : x.id]
}

output "action_group_ids_map" {
  value = { for x in azurerm_monitor_action_group.this : x.name => x.id }
}

output "query_rule_alert_ids" {
  value = [for x in azurerm_monitor_scheduled_query_rules_alert.this : x.id]
}

output "query_rule_alert_ids_map" {
  value = { for x in azurerm_monitor_scheduled_query_rules_alert.this : x.name => x.id }
}
