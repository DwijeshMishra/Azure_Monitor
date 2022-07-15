module "AzureMonitor" {
  source                        = "./modules/AzureMonitor"
  resource_group_name           =  var.resource_group_name
  action_groups                 =  var.action_groups
  query_rules_alerts            =  var.query_rules_alerts
  data_source_id                = var.data_source_id
}
