resource "azurerm_monitor_scheduled_query_rules_alert_v2" "scheduled_query_rules_alert" {
  for_each                = { for value in var.scheduled_query_rules_alert : value.name => value }
  name                    = "${each.value.name}"
  location                = each.value.location
  resource_group_name     = each.value.resource_group_name
  description             = each.value.properties.description != "" ? each.value.properties.description : null
  enabled                 = each.value.properties.enabled
  evaluation_frequency    = each.value.properties.evaluationFrequency == 15 ? "PT15M" : each.value.properties.evaluationFrequency ==  5 ? "PT5M" : each.value.properties.evaluationFrequency == 60 ? "PT1H" : each.value.properties.evaluationFrequency
  severity                = each.value.properties.severity
  window_duration         = each.value.properties.windowSize == 15 ? "PT15M" : each.value.properties.windowSize == 5 ? "PT5M" : each.value.properties.windowSize == 60 ? "PT1H" : each.value.properties.windowSize
  auto_mitigation_enabled = each.value.properties.auto_mitigation_enabled
  scopes                  = each.value.properties.scopes
  tags                    = each.value.tags

  criteria {
    query                   = <<-QUERY
  ${each.value.properties.criteria.allOf[0].query}
  QUERY
    time_aggregation_method = each.value.properties.criteria.allOf[0].timeAggregation
    metric_measure_column   = each.value.properties.criteria.allOf[0].metricMeasureColumn
    operator                = each.value.properties.criteria.allOf[0].operator
    threshold               = each.value.properties.criteria.allOf[0].threshold

    failing_periods {
      minimum_failing_periods_to_trigger_alert = each.value.properties.criteria.allOf[0].failingPeriods.minFailingPeriodsToAlert
      number_of_evaluation_periods             = each.value.properties.criteria.allOf[0].failingPeriods.numberOfEvaluationPeriods
    }
  }

}
