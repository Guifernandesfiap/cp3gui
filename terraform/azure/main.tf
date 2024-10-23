# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "my-resource-group"
  location = "eastus"  
}


resource "azurerm_virtual_network" "vnet10" {
  name                = "vnet10"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_virtual_network" "vnet20" {
  name                = "vnet20"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = ["20.0.0.0/16"]
}


resource "azurerm_subnet" "public_subnet" {
  name                 = "public-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet10.name
  address_prefixes     = ["10.0.1.0/24"]
}


resource "azurerm_subnet" "private_subnet" {
  name                 = "private-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet20.name
  address_prefixes     = ["20.0.1.0/24"]
}


resource "azurerm_virtual_network_peering" "vnet10_to_vnet20" {
  name                      = "peer10to20"
  resource_group_name       = azurerm_resource_group.rg.name
  virtual_network_name      = azurerm_virtual_network.vnet10.name
  remote_virtual_network_id = azurerm_virtual_network.vnet20.id

  allow_virtual_network_access = true
  allow_forwarded_traffic     = true
  allow_gateway_transit       = false
  use_remote_gateways        = false
}


resource "azurerm_virtual_network_peering" "vnet20_to_vnet10" {
  name                      = "peer20to10"
  resource_group_name       = azurerm_resource_group.rg.name
  virtual_network_name      = azurerm_virtual_network.vnet20.name
  remote_virtual_network_id = azurerm_virtual_network.vnet10.id

  allow_virtual_network_access = true
  allow_forwarded_traffic     = true
  allow_gateway_transit       = false
  use_remote_gateways        = false
}