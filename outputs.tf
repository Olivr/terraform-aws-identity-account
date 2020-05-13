/*
 * IAM
 */

output "iam_roles" {
  value       = module.iam_roles.roles
  description = "List of IAM roles that were created"
}

output "iam_users_with_roles" {
  value = {
    for user, props in module.iam_users.users : user => merge(props, {
      assumable_roles = flatten([
        for group in var.aws_iam_users[user] : [lookup(lookup(var.aws_iam_groups, group, {}), "assume_roles", [])]
      ])
    })
  }
  description = "List of IAM users that were created along with their roles and encrypted access key secrets"
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
  value       = "https://${var.auth0_domain}/samlp/${auth0_client.aws.id}?connection=${module.cognito_users_label.id}&RelayState=https://console.aws.amazon.com/console/home?region=${local.aws_default_region}"
  description = "URL your Cognito users should use to signin to the AWS Console"
}
