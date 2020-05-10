/**
 * Create Connection (identity provider)
 */

resource "auth0_connection" "cognito" {
  name                 = module.cognito_users_label.id
  strategy             = "oidc"
  is_domain_connection = false
  enabled_clients      = [auth0_client.aws.id]

  options {
    client_id              = aws_cognito_user_pool_client.auth0.id
    client_secret          = aws_cognito_user_pool_client.auth0.client_secret
    scope                  = "openid profile email"
    type                   = "back_channel"
    issuer                 = "https://${aws_cognito_user_pool.users.endpoint}"
    jwks_uri               = "https://${aws_cognito_user_pool.users.endpoint}/.well-known/jwks.json"
    discovery_url          = "https://${aws_cognito_user_pool.users.endpoint}/.well-known/openid-configuration"
    token_endpoint         = "${local.aws_cognito_auth_url}/oauth2/token"
    userinfo_endpoint      = "${local.aws_cognito_auth_url}/oauth2/userInfo"
    authorization_endpoint = "${local.aws_cognito_auth_url}/oauth2/authorize"
  }

  lifecycle {
    ignore_changes = [enabled_clients]
  }
}
