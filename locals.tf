/**
 * AWS variables
 */

data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

locals {
  aws_default_region = data.aws_region.current.name
  aws_account_id     = data.aws_caller_identity.current.account_id

  tags = {
    Namespace                  = var.namespace
    Environment                = var.environment
    Attributes                 = try(join(", ", var.attributes), null)
    Automation                 = "true"
    Terraform                  = "true"
    TerraformCloudOrganization = var.tfe_organization
    TerraformCloudWorkspace    = var.tfe_workspace
  }
}


/**
 * AWS Cognito variables
 */

locals {
  aws_cognito_domain_is_custom = var.aws_cognito_custom_domain != null && var.aws_cognito_custom_domain_certificate_arn != null ? true : false
}

locals {
  aws_cognito_auth_url = local.aws_cognito_domain_is_custom == true ? "https://${aws_cognito_user_pool_domain.users.domain}" : "https://${aws_cognito_user_pool_domain.users.domain}.auth.${local.aws_default_region}.amazoncognito.com"
}


/**
 * AWS IAM variables
 */

locals {
  aws_iam_roles = {
    for role, props in var.aws_iam_roles : role => merge(props, {
      assumable_by_federated = contains(lookup(props, "assumable_by_federated", []), "cognito") == false ? props.assumable_by_federated : setunion(
        setsubtract(props.assumable_by_federated, ["cognito"]),
        ["arn:aws:iam::${local.aws_account_id}:saml-provider/${module.auth0_saml_provider_label.id}"]
      )
    })
  }
}
