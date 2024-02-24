variable "resource_group_name" {
  type    = string
  default = ""
}

variable "api_management_name" {
  type    = string
  default = ""
}

variable "product_id" {
  type    = string
  default = ""
}

variable "config_file" {
  type    = string
  default = ""
}

locals {
  config          = yamldecode(file("${path.module}/../../../config/${var.config_file}.yaml"))
  apim_api        = local.config.apim_api
  apim_api_policy = local.config.apim_api_policy
  operations      = local.config.operations
}
