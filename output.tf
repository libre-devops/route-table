output "force_tunnel_route_id" {
  description = "If force tunneling is enabled, the id of the route"
  value       = var.enable_force_tunneling == true ? azurerm_route.force_internet_tunneling.0.id : null
}

output "force_tunnel_route_name" {
  description = "If force tunneling is enabled, the name of the route"
  value       = var.enable_force_tunneling == true ? azurerm_route.force_internet_tunneling.0.name : null
}

output "rt_id" {
  description = "The id of the route table"
  value       = azurerm_route_table.rt.id
}

output "rt_name" {
  description = "The name of the route table"
  value       = azurerm_route_table.rt.name
}

output "rt_subnets" {
  description = "The subnets the route table is attitude to"
  value       = azurerm_route_table.rt.subnets
}
