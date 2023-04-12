terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0.1"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.0.2"
    }
  }
  required_version = ">= 0.14"
}
