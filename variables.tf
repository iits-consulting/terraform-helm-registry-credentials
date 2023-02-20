variable "registry_credentials_version" {
  description = "Version of Registry Credentials chart. (default: 1.1.3)"
  type        = string
  default     = "1.1.3"
}

variable "registry_credentials_namespace" {
  description = "Kubernetes namespace to install Registry Credentials chart to. (default: registry-creds)"
  type        = string
  default     = "registry-creds"
}

variable "registry_credentials_dockerconfig" {
  description = "Dockerconfig in kubernetes.io/dockerconfigjson format. See https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/"
  type        = string
  sensitive   = true
}

resource "errorcheck_is_valid" "registry_credentials_dockerconfig_validation" {
  name = "Registry Credentials Dockerconfig Validation"
  test = {
    assert        = can([for value in values(jsondecode(base64decode(var.registry_credentials_dockerconfig))["auths"]) : base64decode(value["auth"])])
    error_message = "The variable registry_credentials_dockerconfig is empty or not in kubernetes.io/dockerconfigjson format!"
  }
}
