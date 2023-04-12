# resource "kubernetes_manifest" "aks_proxy_defaults" {
#   provider = kubernetes.aks
#   manifest = {
#     "apiVersion" = "consul.hashicorp.com/v1alpha1"
#     "kind"       = "ProxyDefaults"
#     "metadata" = {
#       "name"      = "global"
#       "namespace" = "default"
#       "finalizers" = ["finalizers.consul.hashicorp.com"]
#     }
#     "spec" = {
#       "meshGateway" = {
#         "mode" = "local"
#       }
#     }
#   }
# }


# resource "kubernetes_manifest" "aks_proxy_defaults2" {
#   provider = kubernetes.aks2
#   manifest = {
#     "apiVersion" = "consul.hashicorp.com/v1alpha1"
#     "kind"       = "ProxyDefaults"
#     "metadata" = {
#       "name"      = "global"
#       "namespace" = "default"
#       "finalizers" = ["finalizers.consul.hashicorp.com"]
#     }
#     "spec" = {
#       "meshGateway" = {
#         "mode" = "local"
#       }
#     }
#   }
# }