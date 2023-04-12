output "resource_group_name" {
  description = "Azure resource group name"
  value       = azurerm_resource_group.default.name
}

output "resource_group_name2" {
  description = "Azure resource group name"
  value       = azurerm_resource_group.default2.name
}

output "kubernetes_cluster_name" {
  description = "AKS cluster name"
  value       = azurerm_kubernetes_cluster.default.name
}

output "kubernetes_cluster_name2" {
  description = "AKS cluster name"
  value       = azurerm_kubernetes_cluster.default2.name
}
