resource "random_pet" "prefix" {}

provider "azurerm" {
  features {}

  client_id       = var.appId
  client_secret   = var.spPass
  tenant_id       = "c2d4fe14-0652-4dac-b415-5a65748fd6c9"
  subscription_id = "f81e70a7-e819-49b2-a980-8e9c433743dd"
}

data "azurerm_resource_group" "default" {
  name = "tf-rg"
}

resource "azurerm_kubernetes_cluster" "default" {
  name                = "${random_pet.prefix.id}-aks"
  location            = data.azurerm_resource_group.default.location
  resource_group_name = data.azurerm_resource_group.default.name
  dns_prefix          = "${random_pet.prefix.id}-k8s"

  default_node_pool {
    name            = "default"
    node_count      = 2
    vm_size         = "Standard_D2_v2"
    os_disk_size_gb = 30
  }

  service_principal {
    client_id     = var.appId
    client_secret = var.spPass 
  }

  role_based_access_control {
    enabled = true
  }

  tags = {
    environment = "Demo"
  }
}
