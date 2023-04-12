provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

resource "helm_release" "kubewatch" {
  name       = "kubewatch"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "kubewatch"

  values = [
    file("${path.module}/kubewatch-values.yaml")
  ]

  set_sensitive {
    name  = "slack.token"
    value = "xoxb-3960755497696-4523045137680-T6HvaJRAD2pBkybmFpWZudUl" # Tak tego nie robimy ;)
  }
}
