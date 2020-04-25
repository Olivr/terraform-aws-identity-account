/**
 * Generic Variables
 */

variable "organization_name" {
  type        = string
  description = "Organization name"
}

/**
 * AWS Variables
 */

variable "aws_profile" {
  type        = string
  description = "Locally configured AWS profile name"
  default     = "default"
}

variable "aws_default_region" {
  type        = string
  description = "AWS Default Region"
  default     = "us-east-1"
}

variable "aws_account_id" {
  type        = string
  description = "AWS Account ID"
}

variable "aws_role_name" {
  type        = string
  description = "AWS Role Name"
}

/**
 * Terraform Cloud Variables
 */

variable "tfe_organization" {
  type        = string
  description = "Terraform Cloud organization name"
}

variable "tfe_workspace" {
  type        = string
  description = "Terraform Cloud workspace name"
}

/**
 * Local Variables
 */

locals {
  tags = {
    Automation            = "true"
    Terraform             = "true"
    TerraformOrganization = var.tfe_organization
    TerraformWorkspace    = var.tfe_workspace
  }
}
