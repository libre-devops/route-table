resource "azurerm_route_table" "rt" {
  name                = var.route_table_name
  location            = var.location
  resource_group_name = var.rg_name
  dynamic "route" {
    for_each = try(var.routes, null) == null ? [] : [1]
    content {
      name                   = route.value.name
      address_prefix         = route.value.address_prefix
      next_hop_type          = route.value.next_hop_type
      next_hop_in_ip_address = lookup(route.value, "next_hop_in_ip_address", null)
    }
  }
  disable_bgp_route_propagation = var.disable_bgp_route_propagation
  tags                          = var.tags
}

resource "azurerm_route" "force_tunneling" {
  name                = try(var.force_tunnel_route_name, "InternetForceTunneling", null)
  resource_group_name = var.rg_name
  route_table_name    = azurerm_route_table.rt.name
  address_prefix      = "0.0.0.0/0"
  next_hop_type       = var.enable_force_tunneling == true ? try(var.force_tunnel_next_hope_type, null) : "VirtualNetworkGateway"

  count = var.enable_force_tunneling ? 1 : 0
}

resource "azurerm_subnet_route_table_association" "rt_snet_association" {
  subnet_id      = var.associate_with_subnet == true ? try(var.subnet_id_to_associate, null) : null
  route_table_id = azurerm_route_table.rt.id
  count          = var.associate_with_subnet ? 1 : 0
}