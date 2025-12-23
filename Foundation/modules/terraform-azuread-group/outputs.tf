output "groups" {
  value = {
    for k, v in azuread_group.group : k => {
      display_name = v.display_name
      members      = v.members
    }
  }
}
