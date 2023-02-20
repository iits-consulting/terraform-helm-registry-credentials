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
