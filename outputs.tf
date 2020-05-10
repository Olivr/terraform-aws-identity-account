/*
 * IAM
 */

output "iam_roles" {
  value = module.iam_roles.roles
}

output "iam_users_with_roles" {
  value = {
    for user, props in module.iam_users.users : user => merge(props, {
      assumable_roles = flatten([
        for group in var.aws_iam_users[user] : [lookup(lookup(var.aws_iam_groups, group, {}), "assume_roles", [])]
      ])
    })
  }
}


/**
 * Cognito
 */

output "cognito_domain_alias" {
  value       = local.aws_cognito_domain_is_custom == true ? aws_cognito_user_pool_domain.users.cloudfront_distribution_arn : null
  description = "CNAME alias to use to finalize configuration of your custom cognito domain (if any)"
}


/**
 * Auth0
 */

output "aws_signin_url" {
  value = "https://${var.auth0_domain}/samlp/${auth0_client.aws.id}?connection=${module.cognito_users_label.id}&RelayState=https://console.aws.amazon.com/console/home?region=${local.aws_default_region}"
}

/*
output "auth0_create_conn" {
  value       = <<EOF
  {
    "options": {
      "type": "back_channel",
      "scope": "openid profile email",
      "client_id": "${aws_cognito_user_pool_client.auth0.id}",
      "client_secret": "${aws_cognito_user_pool_client.auth0.client_secret}",
      "issuer": "https://${aws_cognito_user_pool.users.endpoint}",
      "jwks_uri": "https://${aws_cognito_user_pool.users.endpoint}/.well-known/jwks.json",
      "discovery_url": "https://${aws_cognito_user_pool.users.endpoint}/.well-known/openid-configuration",
      "token_endpoint": "${local.aws_cognito_auth_url}/oauth2/token",
      "userinfo_endpoint": "${local.aws_cognito_auth_url}/oauth2/userInfo",
      "authorization_endpoint": "${local.aws_cognito_auth_url}/oauth2/authorize"
    },
    "strategy": "oidc",
    "name": "${module.cognito_users_label.id}",
    "is_domain_connection": false,
    "enabled_clients": [
      "${auth0_client.aws.id}"
    ]
  }
EOF
  description = "Create Auth0 connection"
}
*/
