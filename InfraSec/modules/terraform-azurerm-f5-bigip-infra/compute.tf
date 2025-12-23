# Create F5 BIGIP1
resource "azurerm_linux_virtual_machine" "f5vm" {
  count                           = var.instances
  name                            = format("%s-f5vm-%s", local.instance_prefix, count.index)
  location                        = data.azurerm_resource_group.rg.location
  resource_group_name             = data.azurerm_resource_group.rg.name
  network_interface_ids           = [azurerm_network_interface.mgmt_nic[count.index].id, azurerm_network_interface.external_nic[count.index].id, azurerm_network_interface.internal_nic[count.index].id]
  secure_boot_enabled             = false
  vtpm_enabled                    = false
  size                            = var.bigip_details.virtual_machine_details.instance_type
  disable_password_authentication = var.bigip_details.virtual_machine_details.enable_ssh_key
  computer_name                   = format("%s-f5vm", local.instance_prefix)
  admin_username                  = var.bigip_details.credentials.username
  admin_password                  = lookup(var.bigip_details.credentials, "password", null) != null ? var.bigip_details.credentials.password : random_string.password.result
  custom_data = base64encode(coalesce(var.custom_user_data, templatefile("${path.module}/templates/${var.script_name}.tmpl",
    {
      INIT_URL                   = var.INIT_URL
      DO_URL                     = var.DO_URL
      AS3_URL                    = var.AS3_URL
      TS_URL                     = var.TS_URL
      CFE_URL                    = var.CFE_URL
      FAST_URL                   = var.FAST_URL,
      DO_VER                     = format("v%s", split("-", split("/", var.DO_URL)[length(split("/", var.DO_URL)) - 1])[3])
      AS3_VER                    = format("v%s", split("-", split("/", var.AS3_URL)[length(split("/", var.AS3_URL)) - 1])[2])
      TS_VER                     = format("v%s", split("-", split("/", var.TS_URL)[length(split("/", var.TS_URL)) - 1])[2])
      CFE_VER                    = format("v%s", split("-", split("/", var.CFE_URL)[length(split("/", var.CFE_URL)) - 1])[3])
      FAST_VER                   = format("v%s", split("-", split("/", var.FAST_URL)[length(split("/", var.FAST_URL)) - 1])[3])
      vault_url                  = ""
      secret_id                  = ""
      az_keyvault_authentication = false
      ssh_keypair                = var.f5_ssh_publickey
      bigip_username             = (lookup(var.bigip_details.credentials, "username", null) != null ? var.bigip_details.credentials.username : "bigipuser")
      bigip_password             = (lookup(var.bigip_details.credentials, "password", null) != null ? var.bigip_details.credentials.password : random_string.password.result)
      reg_key                    = var.byol_reg_key[count.index]
  })))
  source_image_reference {
    offer     = var.bigip_details.virtual_machine_details.product_name
    publisher = var.bigip_details.virtual_machine_details.image_publisher
    sku       = var.bigip_details.virtual_machine_details.image_name
    version   = var.bigip_details.virtual_machine_details.version
  }
  # boot_diagnostics {
  #   storage_account_uri = azurerm_storage_account.f5.primary_blob_endpoint
  # }

  os_disk {
    caching                   = "ReadWrite"
    disk_size_gb              = var.bigip_details.virtual_machine_details.os_disk_size
    name                      = "${local.instance_prefix}-osdisk-f5vm-${count.index}"
    storage_account_type      = var.bigip_details.virtual_machine_details.storage_account_type
    write_accelerator_enabled = false
  }

  admin_ssh_key {
    public_key = var.f5_ssh_publickey
    username   = var.bigip_details.credentials.username
  }
  plan {
    name      = var.bigip_details.virtual_machine_details.image_name
    product   = var.bigip_details.virtual_machine_details.product_name
    publisher = var.bigip_details.virtual_machine_details.image_publisher
  }
  zone = var.bigip_details.virtual_machine_details.availability_zone

  tags = merge(local.tags, {
    Name = format("%s-f5vm", local.instance_prefix)
    }
  )
  identity {
    type         = "UserAssigned"
    identity_ids = var.bigip_details.user_identity == null ? flatten([azurerm_user_assigned_identity.user_identity.*.id]) : [var.bigip_details.user_identity]
  }
}

## ..:: Run Startup Script ::..
resource "azurerm_virtual_machine_extension" "vmext" {
  count                = var.instances
  name                 = format("%s-vmext1", local.instance_prefix)
  depends_on           = [azurerm_linux_virtual_machine.f5vm]
  virtual_machine_id   = azurerm_linux_virtual_machine.f5vm[count.index].id # Use count.index here
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  tags = merge(local.tags, {
    Name = format("%s-vmext1", local.instance_prefix)
    }
  )

  settings = <<SETTINGS
    {
      "commandToExecute": "bash /var/lib/waagent/CustomData; exit 0;"
    }
SETTINGS
}

resource "time_sleep" "wait_for_azurerm_virtual_machine_f5vm" {
  create_duration = var.sleep_time
  depends_on      = [azurerm_virtual_machine_extension.vmext]
}

# resource "azurerm_storage_account" "f5" {
#   name                     = lower(format("%sf5storage", random_id.module_id.hex))
#   resource_group_name      = data.azurerm_resource_group.rg.name
#   location                 = data.azurerm_resource_group.rg.location
#   account_kind             = "StorageV2"
#   account_tier             = "Standard"
#   account_replication_type = "LRS"

#   shared_access_key_enabled = false
#   public_network_access_enabled = false
  
#   tags = merge(local.tags, {
#     Name = format("%s-f5-storage", local.instance_prefix)
#   })
# }

