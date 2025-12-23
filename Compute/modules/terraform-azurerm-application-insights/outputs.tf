# output "application_insights" { 
#                                 value = azurerm_application_insights.app_insights
  
# }


output "application_insights" {
  value = {for k, v in azurerm_application_insights.app_insights : k => v}
}
