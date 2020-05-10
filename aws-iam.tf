/*
 * Create IAM roles to be associated with Cognito groups
 */

module "iam_roles" {

  source = "../terraform-aws-bulk-iam-roles"
  /*
  source  = "olivr-com/bulk-iam-roles/aws"
  version = "1.0.0"
  */

  roles = local.aws_iam_roles
  tags  = local.tags
}


/*
 * Create IAM groups to be associated with programatic users
 */

module "iam_groups" {
  source  = "olivr-com/bulk-iam-groups/aws"
  version = "1.0.0"

  groups = var.aws_iam_groups
}


/*
 * Create IAM users
 */

module "iam_users" {
  source  = "olivr-com/bulk-iam-users/aws"
  version = "1.0.0"

  users_groups       = var.aws_iam_users
  force_destroy      = true
  create_access_keys = true
  pgp_key            = var.pgp_key
  tags               = local.tags

  module_depends_on = [module.iam_groups.groups]
}


/*
 * Create Auth0/Cognito IAM identity provider
 */

// Resource naming following the general convention
module "auth0_saml_provider_label" {
  source  = "cloudposse/label/null"
  version = "0.16.0"

  name = "cognito-auth0"

  namespace   = var.namespace
  environment = var.environment
  attributes  = ["internal"]
  tags        = local.tags
}

resource "aws_iam_saml_provider" "auth0" {
  name = module.auth0_saml_provider_label.id
  saml_metadata_document = templatefile("${path.module}/auth0-saml-metadata.xml.tpl", {
    domain      = var.auth0_domain
    certificate = var.auth0_cert
    client_id   = auth0_client.aws.id
  })
}
