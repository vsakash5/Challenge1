resource "azurerm_resource_group" "SQLDB" {
  name     = "databaseRG"
  location = "eastus"
}

resource "azurerm_sql_server" "sqlserver" {
  name                         = "sqlserverdatabasekpmg"
  resource_group_name          = azurerm_resource_group.SQLDB.name
  location                     = azurerm_resource_group.SQLDB.location
  version                      = "12.0"
  administrator_login          = var.admin_user
  administrator_login_password = var.admin_password


}


resource "azurerm_sql_database" "database1" {
  name                = "ProductionDB"
  resource_group_name = azurerm_resource_group.SQLDB.name
  location            = azurerm_resource_group.SQLDB.location
  server_name         = azurerm_sql_server.sqlserver.name

}