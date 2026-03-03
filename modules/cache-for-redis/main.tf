resource "azurerm_redis_cache" "redis" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  sku_name            = var.sku_name # Standard, Premium, Basic
  family              = var.family   # C, P, B
  capacity            = var.capacity # instance size
  minimum_tls_version = var.minimum_tls_version

  shard_count         = var.shard_count
  replicas_per_master = var.replicas_per_master

  tags = var.tags
}
