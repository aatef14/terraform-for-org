output "redis_id" {
  description = "ID of the Redis cache"
  value       = azurerm_redis_cache.redis.id
}

output "redis_hostname" {
  description = "Hostname of the Redis cache"
  value       = azurerm_redis_cache.redis.hostname
}

output "redis_port" {
  description = "Port of the Redis cache"
  value       = azurerm_redis_cache.redis.port
}
