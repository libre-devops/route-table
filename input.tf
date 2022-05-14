variable "associate_with_subnet" {
  type        = bool
  description = "If this route table should be assosciated with a subnet, defaults to true"
  default     = true
}

variable "disable_bgp_route_propagation" {
  type        = bool
  description = "Whether or not to enable or disable BGP routes"
}

variable "enable_force_tunneling" {
  type        = bool
  description = "Whether or not force tunneling is enabled, defaults to true"
  default     = true
}

variable "force_tunnel_next_hope_type" {
  type        = string
  description = "The next hop type if a forced tunnel is created, defaults to VirtualNetworkGateway"
  default     = "VirtualNetworkGateway"
}

variable "force_tunnel_route_name" {
  type        = string
  description = "The name of the force tunnel route name if used"
  default     = null
}

variable "location" {
  description = "The location for this resource to be put in"
  type        = string
}

variable "rg_name" {
  description = "The name of the resource group, this module does not create a resource group, it is expecting the value of a resource group already exists"
  type        = string
  validation {
    condition     = length(var.rg_name) > 1 && length(var.rg_name) <= 24
    error_message = "Resource group name is not valid."
  }
}

variable "route_table_name" {
  type        = string
  description = "The name of the route table"
}

variable "routes" {
  type        = any
  description = "The map block for the routes"
  default     = null
}

variable "subnet_id_to_associate" {
  type        = string
  description = "If you wish to associate with a subnet, the ID of it"
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "A map of the tags to use on the resources that are deployed with this module."

  default = {
    source = "terraform"
  }
}
