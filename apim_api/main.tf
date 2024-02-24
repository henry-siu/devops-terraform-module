# apim_api resource
resource "azurerm_api_management_api" "apim_api" {
  name                  = local.apim_api.name
  resource_group_name   = var.resource_group_name
  api_management_name   = var.api_management_name
  revision              = local.apim_api.revision
  display_name          = local.apim_api.display_name
  path                  = local.apim_api.path
  protocols             = local.apim_api.protocols
  service_url           = local.apim_api.service_url
  subscription_required = local.apim_api.subscription_required
  description           = local.apim_api.description
  subscription_key_parameter_names {
    header = local.apim_api.subscription_key.header
    query  = local.apim_api.subscription_key.query
  }

  dynamic "import" {
    for_each = contains(keys(local.apim_api), "import") ? [1] : []
    content {
      content_format = local.apim_api.import.content_format
      content_value  = local.apim_api.subscription_key.query
    }
  }
}

# template for apim_product_api resource

resource "azurerm_api_management_product_api" "apim_product_api" {
  count               = local.apim_api.apim_product_api ? 1 : 0
  api_name            = local.apim_api.name
  product_id          = var.product_id
  api_management_name = var.api_management_name
  resource_group_name = var.resource_group_name
}


# apim_api_policy resource

resource "azurerm_api_management_api_policy" "apim_api_policy" {
  api_name            = azurerm_api_management_api.apim_api.name
  resource_group_name = var.resource_group_name
  api_management_name = var.api_management_name
  xml_content         = local.apim_api_policy.xml_content
}

# apim_api_operation resoures

resource "azurerm_api_management_api_operation" "by_operations" {
  for_each = local.operations

  operation_id        = each.key
  api_name            = azurerm_api_management_api.apim_api.name
  api_management_name = azurerm_api_management_api.apim_api.api_management_name
  resource_group_name = azurerm_api_management_api.apim_api.resource_group_name
  display_name        = each.value.display_name
  method              = each.value.method
  url_template        = each.value.url_template
  description         = each.value.description


  dynamic "template_parameter" {
    for_each = contains(keys(each.value), "template_parameter") ? toset(each.value.template_parameter) : []
    iterator = template_parameter
    content {
      name     = template_parameter.key
      type     = ""
      required = true
    }
  }
}
