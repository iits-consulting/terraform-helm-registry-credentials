# DEPRECATED

The module creates to much complexity. We are using it like this now:

```hcl
resource "helm_release" "registry_credentials" {
  depends_on = [helm_release.custom_resource_definitions]
  name                  = "registry-creds"
  repository            = "https://charts.iits.tech"
  chart                 = "registry-creds"
  version               = local.charts.registry_creds_version
  namespace             = "registry-creds"
  create_namespace      = true
  atomic                = true
  render_subchart_notes = true
  dependency_update     = true
  set_sensitive {
    name  = "defaultClusterPullSecret.dockerConfigJsonBase64Encoded"
    value = base64encode(jsonencode({
      auths = {
        "https://index.docker.io/v1/" = {
          username = var.dockerhub_username
          password = var.dockerhub_password
          auth     = base64encode("${var.dockerhub_username}:${var.dockerhub_password}")
        }
      }
    }))
  }
}
```

## Registry Credentials

Installs the registry credentials helm chart [https://github.com/iits-consulting/registry-creds-chart]().

See [https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/]() for how to create docker config json.

Usage Example

```hcl

locals {
  dockerhubconfigjsonbase64 = base64encode(jsonencode({
    auths = {
      "https://${var.registry_url}" = {
        username = var.registry_credentials_dockerconfig_username
        password = var.registry_credentials_dockerconfig_password
        auth     = base64encode("${var.registry_credentials_dockerconfig_username}:${var.registry_credentials_dockerconfig_password}")
      }
    }
  }))
}


module "registry-credentials" {
  source  = "iits-consulting/registry-credentials/helm"
  version = "0.0.1"
  registry_credentials_dockerconfig = local.dockerhubconfigjsonbase64
}
```
