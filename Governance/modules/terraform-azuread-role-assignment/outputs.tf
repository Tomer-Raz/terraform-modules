output "role_assignments" {
  value       = { for key, ra in azuread_directory_role_assignment.role_assignment : key => ra }
  description = "All role assignments created."
}