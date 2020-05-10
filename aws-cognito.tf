/**
 * Create Cognito user pool
 */

// Resource naming following the general convention
module "cognito_users_label" {
  source  = "cloudposse/label/null"
  version = "0.16.0"

  name = "users"

  namespace   = var.namespace
  environment = var.environment
  attributes  = var.attributes
  tags        = local.tags
}

resource "aws_cognito_user_pool" "users" {
  name                     = module.cognito_users_label.id
  alias_attributes         = ["email", "preferred_username"]
  auto_verified_attributes = ["email"]
  tags                     = module.cognito_users_label.tags

  admin_create_user_config { allow_admin_create_user_only = true }
  username_configuration { case_sensitive = false }

  dynamic "schema" {
    for_each = var.aws_cognito_user_fields
    content {
      attribute_data_type      = lookup(schema.value, "attribute_data_type", "String")
      developer_only_attribute = lookup(schema.value, "developer_only_attribute", false)
      mutable                  = lookup(schema.value, "mutable", true)
      name                     = schema.key
      required                 = lookup(schema.value, "required", false)

      dynamic "string_attribute_constraints" {
        for_each = lookup(schema.value, "attribute_data_type", "String") == "String" ? { k = lookup(schema.value, "string_attribute_constraints", {}) } : {}
        content {
          max_length = lookup(string_attribute_constraints.value, "max_length", 2048)
          min_length = lookup(string_attribute_constraints.value, "min_length", 0)
        }
      }

      dynamic "number_attribute_constraints" {
        for_each = lookup(schema.value, "attribute_data_type", "String") == "Number" ? { k = lookup(schema.value, "number_attribute_constraints", {}) } : {}
        content {
          max_value = lookup(number_attribute_constraints.value, "max_value", 1000)
          min_value = lookup(number_attribute_constraints.value, "min_value", 0)
        }
      }
    }
  }
}

/**
 * Attach custom domain to the user pool or create cognito subdomain
 * A custom domain must have a certificate already issued
 */

resource "aws_cognito_user_pool_domain" "users" {
  user_pool_id    = aws_cognito_user_pool.users.id
  domain          = local.aws_cognito_domain_is_custom == true ? var.aws_cognito_custom_domain : module.cognito_users_label.id
  certificate_arn = var.aws_cognito_custom_domain_certificate_arn
}


/**
 * Create Cognito client to interact with Auth0 authentication
 */

resource "aws_cognito_user_pool_client" "auth0" {
  user_pool_id                         = aws_cognito_user_pool.users.id
  name                                 = "auth0"
  generate_secret                      = true
  prevent_user_existence_errors        = "ENABLED"
  explicit_auth_flows                  = ["ALLOW_REFRESH_TOKEN_AUTH"]
  supported_identity_providers         = ["COGNITO"]
  callback_urls                        = concat(["https://${var.auth0_domain}/login/callback"], var.aws_cognito_allowed_callback_urls)
  logout_urls                          = var.aws_cognito_allowed_logout_urls
  allowed_oauth_flows_user_pool_client = "true"
  allowed_oauth_flows                  = ["code"]
  allowed_oauth_scopes                 = ["phone", "email", "openid", "profile"]
}


/**
 * Create groups in Cognito
 */

resource "aws_cognito_user_group" "admin" {
  for_each = var.aws_cognito_groups

  name         = each.key
  user_pool_id = aws_cognito_user_pool.users.id
  description  = each.value.description
  role_arn     = module.iam_roles.roles[each.value.role].arn
  precedence   = each.value.precedence
}
