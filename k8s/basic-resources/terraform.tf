terraform {
  backend "azurerm" {
    resource_group_name  = "tf-rg"
    storage_account_name = "poznajtfstate"
    container_name       = "tfstate"
    key                  = "k8s.terraform.tfstate"
  }
}