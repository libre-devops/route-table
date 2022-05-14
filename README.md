```hcl
module "rg" {
  source = "registry.terraform.io/libre-devops/rg/azurerm"

  rg_name  = "rg-${var.short}-${var.loc}-${terraform.workspace}-build" // rg-ldo-euw-dev-build
  location = local.location                                            // compares var.loc with the var.regions var to match a long-hand name, in this case, "euw", so "westeurope"
  tags     = local.tags

  #  lock_level = "CanNotDelete" // Do not set this value to skip lock
}

module "network" {
  source = "registry.terraform.io/libre-devops/network/azurerm"

  rg_name  = module.rg.rg_name // rg-ldo-euw-dev-build
  location = module.rg.rg_location
  tags     = local.tags

  vnet_name     = "vnet-${var.short}-${var.loc}-${terraform.workspace}-01" // vnet-ldo-euw-dev-01
  vnet_location = module.network.vnet_location

  address_space   = ["10.0.0.0/16"]
  subnet_prefixes = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  subnet_names    = ["sn1-${module.network.vnet_name}", "sn2-${module.network.vnet_name}", "sn3-${module.network.vnet_name}"] //sn1-vnet-ldo-euw-dev-01
  subnet_service_endpoints = {
    "sn1-${module.network.vnet_name}" = ["Microsoft.Storage"]                   // Adds extra subnet endpoints to sn1-vnet-ldo-euw-dev-01
    "sn2-${module.network.vnet_name}" = ["Microsoft.Storage", "Microsoft.Sql"], // Adds extra subnet endpoints to sn2-vnet-ldo-euw-dev-01
    "sn3-${module.network.vnet_name}" = ["Microsoft.AzureActiveDirectory"]      // Adds extra subnet endpoints to sn3-vnet-ldo-euw-dev-01
  }
}

module "rt" {
  source = "registry.terraform.io/libre-devops/route-table/azurerm"

  rg_name  = module.rg.rg_name
  location = module.rg.rg_location
  tags     = module.rg.rg_tags

  route_table_name              = "rt-${var.short}-${var.loc}-${terraform.workspace}-01"
  enable_force_tunneling        = true
  force_tunnel_route_name       = "udr-${var.short}-${var.loc}-${terraform.workspace}-ForceInternetTunnel"
  disable_bgp_route_propagation = true

  associate_with_subnet  = true
  subnet_id_to_associate = element(values(module.network.subnets_ids), 0)
}

```

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_route.force_tunneling](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route) | resource |
| [azurerm_route_table.rt](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route_table) | resource |
| [azurerm_subnet_route_table_association.rt_snet_association](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_route_table_association) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_associate_with_subnet"></a> [associate\_with\_subnet](#input\_associate\_with\_subnet) | If this route table should be assosciated with a subnet, defaults to true | `bool` | `true` | no |
| <a name="input_disable_bgp_route_propagation"></a> [disable\_bgp\_route\_propagation](#input\_disable\_bgp\_route\_propagation) | Whether or not to enable or disable BGP routes | `bool` | n/a | yes |
| <a name="input_enable_force_tunneling"></a> [enable\_force\_tunneling](#input\_enable\_force\_tunneling) | Whether or not force tunneling is enabled, defaults to true | `bool` | `true` | no |
| <a name="input_force_tunnel_next_hope_type"></a> [force\_tunnel\_next\_hope\_type](#input\_force\_tunnel\_next\_hope\_type) | The next hop type if a forced tunnel is created, defaults to VirtualNetworkGateway | `string` | `"VirtualNetworkGateway"` | no |
| <a name="input_force_tunnel_route_name"></a> [force\_tunnel\_route\_name](#input\_force\_tunnel\_route\_name) | The name of the force tunnel route name if used | `string` | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | The location for this resource to be put in | `string` | n/a | yes |
| <a name="input_rg_name"></a> [rg\_name](#input\_rg\_name) | The name of the resource group, this module does not create a resource group, it is expecting the value of a resource group already exists | `string` | n/a | yes |
| <a name="input_route_table_name"></a> [route\_table\_name](#input\_route\_table\_name) | The name of the route table | `string` | n/a | yes |
| <a name="input_routes"></a> [routes](#input\_routes) | The map block for the routes | `any` | `null` | no |
| <a name="input_subnet_id_to_associate"></a> [subnet\_id\_to\_associate](#input\_subnet\_id\_to\_associate) | If you wish to associate with a subnet, the ID of it | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of the tags to use on the resources that are deployed with this module. | `map(string)` | <pre>{<br>  "source": "terraform"<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_force_tunnel_route_id"></a> [force\_tunnel\_route\_id](#output\_force\_tunnel\_route\_id) | If force tunneling is enabled, the id of the route |
| <a name="output_force_tunnel_route_name"></a> [force\_tunnel\_route\_name](#output\_force\_tunnel\_route\_name) | If force tunneling is enabled, the name of the route |
| <a name="output_rt_id"></a> [rt\_id](#output\_rt\_id) | The id of the route table |
| <a name="output_rt_name"></a> [rt\_name](#output\_rt\_name) | The name of the route table |
| <a name="output_rt_subnets"></a> [rt\_subnets](#output\_rt\_subnets) | The subnets the route table is attitude to |
