resource "kubernetes_manifest" "my_new_crontab" {
  manifest = {
    "apiVersion" = "stable.example.com/v1"
    "kind"       = "CronTab"
    "metadata" = {
      "name"      = "my-new-cron-object"
      "namespace" = "default"
    }
    "spec" = {
      "cronSpec" = "* * * * */5"
      "image"    = "my-awesome-cron-image"
    }
  }
}
