resource "azurerm_cosmosdb_account" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  offer_type          = var.cosmos_db_offer_type
  kind                = var.cosmos_db_kind

  free_tier_enabled = false # Always-free quantity disabled

  consistency_policy {
    consistency_level = var.consistency_level
  }

  geo_location {
    location          = var.location
    failover_priority = 0
    zone_redundant    = var.zone_redundant
  }



  multiple_write_locations_enabled = var.enable_multiple_write_locations

  backup {
    type                = "Periodic"
    interval_in_minutes = 240
    retention_in_hours  = 8
    storage_redundancy  = "Geo" # Periodic backup storage
  }

  analytical_storage_enabled = false
}

resource "azurerm_cosmosdb_sql_database" "this" {
  name                = var.db_name
  resource_group_name = azurerm_cosmosdb_account.this.resource_group_name
  account_name        = azurerm_cosmosdb_account.this.name
  throughput          = var.throughput # 6,000 RUs
}
