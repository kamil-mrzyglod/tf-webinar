data "terraform_remote_state" "aks" {
  backend = "local"

  config = {
    path = "../aks-cluster/terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

data "azurerm_kubernetes_cluster" "cluster" {
  name                = data.terraform_remote_state.aks.outputs.kubernetes_cluster_name
  resource_group_name = data.terraform_remote_state.aks.outputs.resource_group_name
}

provider "kubernetes" {
  host = data.azurerm_kubernetes_cluster.cluster.kube_config.0.host

  client_certificate     = base64decode(data.azurerm_kubernetes_cluster.cluster.kube_config.0.client_certificate)
  client_key             = base64decode(data.azurerm_kubernetes_cluster.cluster.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.cluster.kube_config.0.cluster_ca_certificate)
}

resource "kubernetes_namespace" "terramino" {
  metadata {
    name = "terramino"
  }
}

resource "kubernetes_deployment" "terramino" {
  metadata {
    name      = var.application_name
    namespace = kubernetes_namespace.terramino.id
    labels = {
      app = var.application_name
    }
  }

  spec {
    replicas = 3
    selector {
      match_labels = {
        app = var.application_name
      }
    }
    template {
      metadata {
        labels = {
          app = var.application_name
        }
      }
      spec {
        container {
          image = "tr0njavolta/terramino"
          name  = var.application_name
        }
      }
    }
  }
}

resource "kubernetes_service" "terramino" {
  metadata {
    name      = var.application_name
    namespace = kubernetes_namespace.terramino.id
  }
  spec {
    selector = {
      app = kubernetes_deployment.terramino.metadata[0].labels.app
    }
    port {
      port        = 8080
      target_port = 80
    }
    type = "LoadBalancer"
  }
}
