resource "helm_release" "registry_credentials" {
  name                  = "registry-creds"
  repository            = "https://iits-consulting.github.io/registry-creds-chart"
  chart                 = "registry-creds"
  version               = var.registry_credentials_version
  namespace             = var.registry_credentials_namespace
  create_namespace      = true
  atomic                = true
  render_subchart_notes = true
  dependency_update     = true
  set_sensitive {
    name  = "defaultClusterPullSecret.dockerConfigJsonBase64Encoded"
    value = var.registry_credentials_dockerconfig
  }
}
