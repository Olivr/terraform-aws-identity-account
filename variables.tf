/**
 * Generic Variables
 */

variable "namespace" {
  type        = string
  description = "Namespace for naming resources (eg. `ac` for Acme)"
}

variable "environment" {
  type        = string
  description = "Environment (eg. dev, prod, staging)"
}

variable "attributes" {
  type        = list(string)
  description = "List of attributes (eg. internal, public)"
  default     = null
}


/**
 * Security
 */

variable "pgp_key" {
  type        = string
  description = "PGP key in plain text or using the format `keybase:username` to encrypt user keys and passwords"
  default     = null
}


/**
 * AWS Variables
 */

variable "aws_assume_role_arn" {
  type        = string
  description = "AWS role arn to assume when running this script (if any)"
  default     = null
}


/**
 * AWS IAM Variables
 */

variable "aws_iam_roles" {
  type        = map(map(list(string)))
  description = "AWS roles to create. If you set the value `cognito` in `assumable_by_federated`, it will be replaced by the newly created Cognito instance, eg. `{ MyRole = { assumable_by_federated = [\"cognito\"] } }`. See [_var_aws_iam_roles.auto.tfvars.json](_var_aws_iam_roles.auto.tfvars.json) for the format."
  default     = {}
}

variable "aws_iam_groups" {
  type        = map(map(list(string)))
  description = "AWS groups to create. It should be specified using a map of groups and their attributes. See [_var_aws_iam_groups.auto.tfvars.json](_var_aws_iam_groups.auto.tfvars.json) for the format."
  default     = {}
}

variable "aws_iam_users" {
  type        = any
  description = "AWS users to create. You can specify a simple list, eg. `[\"user-1\", ...]` or a map of users and their groups. See [_var_aws_iam_users.auto.tfvars.json](_var_aws_iam_users.auto.tfvars.json) for the format."
  default     = {}
}


/**
 * AWS Cognito Variables
 */

variable "aws_cognito_custom_domain" {
  type        = string
  description = "Cognito custom domain name. To use this, you must also specify `aws_cognito_custom_domain_certificate_arn`."
  default     = null
}

variable "aws_cognito_custom_domain_certificate_arn" {
  type        = string
  description = "ARN of an issued ACM certificate for the Cognito custom domain name."
  default     = null
}

variable "aws_cognito_groups" {
  type        = map(map(string))
  description = "Cognito groups to create. See [_var_aws_cognito_groups.auto.tfvars.json](_var_aws_cognito_groups.auto.tfvars.json) for the format."
  default     = {}
}

variable "aws_cognito_user_fields" {
  description = "User profile fields to add to your Cognito user pool, eg. email, birthdate, twitter. See [_var_aws_cognito_user_fields.auto.tfvars.json](_var_aws_cognito_user_fields.auto.tfvars.json) for the format."
  default     = {}
}

variable "aws_cognito_allowed_callback_urls" {
  type        = list(string)
  description = "List of URLs that Cognito clients can redirect to."
  default     = []
}

variable "aws_cognito_allowed_logout_urls" {
  type        = list(string)
  description = "List of URLs that Cognito clients can redirect to after logout (any url added here also need to be added in callback if making use of `redirect_uri`)."
  default     = []
}


/**
 * Terraform Cloud Variables
 */

variable "tfe_organization" {
  type        = string
  description = "Terraform Cloud organization name."
  default     = null
}

variable "tfe_workspace" {
  type        = string
  description = "Terraform Cloud workspace name."
  default     = null
}


/**
 * Auth0 Variables
 */

variable "auth0_domain" {
  type        = string
  description = "Auth0 domain."
}

variable "auth0_cert" {
  type        = string
  description = "Auth0 certificate. Can be found at `https://YOUR-AUTH0-DOMAIN/pem`."
}
