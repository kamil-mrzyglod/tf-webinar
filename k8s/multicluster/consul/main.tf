data "terraform_remote_state" "aks" {
  backend = "local"
  config = {
    path = "../aks/terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

data "azurerm_kubernetes_cluster" "cluster" {
  name                = data.terraform_remote_state.aks.outputs.kubernetes_cluster_name
  resource_group_name = data.terraform_remote_state.aks.outputs.resource_group_name
}

data "azurerm_kubernetes_cluster" "cluster2" {
  name                = data.terraform_remote_state.aks.outputs.kubernetes_cluster_name2
  resource_group_name = data.terraform_remote_state.aks.outputs.resource_group_name2
}

provider "kubernetes" {
  alias                  = "aks"
  host                   = data.azurerm_kubernetes_cluster.cluster.kube_config.0.host
  client_certificate     = base64decode(data.azurerm_kubernetes_cluster.cluster.kube_config.0.client_certificate)
  client_key             = base64decode(data.azurerm_kubernetes_cluster.cluster.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.cluster.kube_config.0.cluster_ca_certificate)

  experiments {
    manifest_resource = true
  }
}

provider "kubernetes" {
  alias                  = "aks2"
  host                   = data.azurerm_kubernetes_cluster.cluster2.kube_config.0.host
  client_certificate     = base64decode(data.azurerm_kubernetes_cluster.cluster2.kube_config.0.client_certificate)
  client_key             = base64decode(data.azurerm_kubernetes_cluster.cluster2.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.cluster2.kube_config.0.cluster_ca_certificate)

  experiments {
    manifest_resource = true
  }
}

provider "helm" {
  alias = "aks"
  kubernetes {
    host                   = data.azurerm_kubernetes_cluster.cluster.kube_config.0.host
    client_certificate     = base64decode(data.azurerm_kubernetes_cluster.cluster.kube_config.0.client_certificate)
    client_key             = base64decode(data.azurerm_kubernetes_cluster.cluster.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.cluster.kube_config.0.cluster_ca_certificate)
  }
}

provider "helm" {
  alias = "aks2"
  kubernetes {
    host                   = data.azurerm_kubernetes_cluster.cluster.kube_config.0.host
    client_certificate     = base64decode(data.azurerm_kubernetes_cluster.cluster.kube_config.0.client_certificate)
    client_key             = base64decode(data.azurerm_kubernetes_cluster.cluster.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.cluster.kube_config.0.cluster_ca_certificate)
  }
}

resource "kubernetes_secret" "aks_federation_secret" {
  provider = kubernetes.aks
  metadata {
    name = "consul-federation"
  }

  data = data.kubernetes_secret.aks_federation_secret2.data
}

resource "kubernetes_secret" "aks_federation_secret2" {
  provider = kubernetes.aks2
  metadata {
    name = "consul-federation"
  }

  data = data.kubernetes_secret.aks_federation_secret.data
}

resource "helm_release" "consul_dc1" {
  provider   = helm.aks
  name       = "consul"
  repository = "https://helm.releases.hashicorp.com"
  chart      = "consul"
  version    = "0.32.1"

  values = [
    file("dc1.yaml")
  ]
}

resource "helm_release" "consul_dc2" {
  provider   = helm.aks2
  name       = "consul"
  repository = "https://helm.releases.hashicorp.com"
  chart      = "consul"
  version    = "0.32.1"

  values = [
    file("dc2.yaml")
  ]

  depends_on = [kubernetes_secret.aks_federation_secret2]
}

data "kubernetes_secret" "aks_federation_secret" {
  provider = kubernetes.aks
  metadata {
    name = "consul-federation"
  }

  depends_on = [helm_release.consul_dc1]
}

data "kubernetes_secret" "aks_federation_secret2" {
  provider = kubernetes.aks2
  metadata {
    name = "consul-federation"
  }

  depends_on = [helm_release.consul_dc2]
}
