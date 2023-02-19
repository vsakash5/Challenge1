resource "azurerm_resource_group" "rg" {
  name     = "AppRG"
  location = "eastus"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "AppVnet"
  location            = "eastus"
  address_space       = ["10.0.0.0/16"]
  resource_group_name = "${azurerm_resource_group.rg.name}"
}

resource "azurerm_subnet" "subnet1" {
  name                 = "subnet1"
  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
  resource_group_name  = "${azurerm_resource_group.rg.name}"
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "subnet2" {
  name                 = "subnet2"
  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
  resource_group_name  = "${azurerm_resource_group.rg.name}"
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_availability_set" "ApplicationAVset" {
   name                         = "ApplicationAVset"
   location            = azurerm_resource_group.rg.location
   resource_group_name = azurerm_resource_group.rg.name
   platform_fault_domain_count  = 3
   platform_update_domain_count = 20
   managed                      = true
 }


resource "azurerm_network_interface" "main" {
  name                = "${var.vm_name}-nic-${count.index}"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  count               = 3

  ip_configuration {
    name                          = "testconfiguration${count.index}"
    subnet_id                     = "${azurerm_subnet.subnet1.id}"
    private_ip_address_allocation = "dynamic"
  }
}