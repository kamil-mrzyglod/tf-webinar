resource "random_pet" "prefix" {}
resource "random_pet" "prefix2" {}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "default" {
  name     = "${random_pet.prefix.id}-aks"
  location = "West Europe"

  tags = {
    environment = "Demo"
  }
}

resource "azurerm_resource_group" "default2" {
  name     = "${random_pet.prefix2.id}-aks"
  location = "West Europe"

  tags = {
    environment = "Demo"
  }
}

resource "azurerm_kubernetes_cluster" "default" {
  name                = "${random_pet.prefix.id}-aks"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  dns_prefix          = "${random_pet.prefix.id}-k8s"

  default_node_pool {
    name            = "default"
    node_count      = 3
    vm_size         = "Standard_D2_v2"
    os_disk_size_gb = 30
  }

  service_principal {
    client_id     = var.appId
    client_secret = var.password
  }

  role_based_access_control_enabled = true

  tags = {
    environment = "Demo"
  }
}

resource "azurerm_kubernetes_cluster" "default2" {
  name                = "${random_pet.prefix2.id}-aks"
  location            = azurerm_resource_group.default2.location
  resource_group_name = azurerm_resource_group.default2.name
  dns_prefix          = "${random_pet.prefix2.id}-k8s"

  default_node_pool {
    name            = "default"
    node_count      = 3
    vm_size         = "Standard_D2_v2"
    os_disk_size_gb = 30
  }

  service_principal {
    client_id     = var.appId
    client_secret = var.password
  }

  role_based_access_control_enabled = true

  tags = {
    environment = "Demo"
  }
}
