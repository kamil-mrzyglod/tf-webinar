resource "kubernetes_manifest" "crontab_crd" {
  manifest = {
    "apiVersion" = "apiextensions.k8s.io/v1"
    "kind"       = "CustomResourceDefinition"
    "metadata" = {
      "name" = "crontabs.stable.example.com"
    }
    "spec" = {
      "group" = "stable.example.com"
      "names" = {
        "kind"   = "CronTab"
        "plural" = "crontabs"
        "shortNames" = [
          "ct",
        ]
        "singular" = "crontab"
      }
      "scope" = "Namespaced"
      "versions" = [
        {
          "name" = "v1"
          "schema" = {
            "openAPIV3Schema" = {
              "properties" = {
                "spec" = {
                  "properties" = {
                    "cronSpec" = {
                      "type" = "string"
                    }
                    "image" = {
                      "type" = "string"
                    }
                  }
                  "type" = "object"
                }
              }
              "type" = "object"
            }
          }
          "served"  = true
          "storage" = true
        },
      ]
    }
  }
}
