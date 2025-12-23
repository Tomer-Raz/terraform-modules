resource "azurerm_synapse_spark_pool" "synapse" {
  count                = 1
  name                 = "${local.sparkpool_name_prefix}1"
  synapse_workspace_id = azurerm_synapse_workspace.synapse.id
  node_size_family     = "MemoryOptimized"
  node_size            = "Small"
  cache_size           = 0
  spark_version        = "3.3"

  auto_scale {
    max_node_count = 10
    min_node_count = 5
  }
  auto_pause {
    delay_in_minutes = 5
  }
  library_requirement {
    content  = <<EOF
appnope==0.1.0
beautifulsoup4==4.6.3
EOF
    filename = "requirements.txt"
  }
  spark_config {
    content  = <<EOF
spark.shuffle.spill                true
EOF
    filename = "config.txt"
  }
  tags = {
    ENV = var.env
  }

  lifecycle {
    ignore_changes = [tags, spark_config]
  }
  depends_on = [azurerm_synapse_workspace_key.synapse_key, azurerm_synapse_workspace.synapse]
}