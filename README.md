# Identity account

This terraform script provisions an AWS Cognito user pool as the single source of truth to manage internal users of your company (employees, partners, consultants, etc.)

## Features

- Pure Terraform script (no third-party wrapper/CLI)
- Setup a Cognito user pool to serve as the authorization layer (users database)
- Setup a Auth0 application to serve as the authentication layer (login)
- Configure AWS SSO to login to AWS using your newly configured authorization and authentication layers

## Pre-requisites

- [ ] [Terraform CLI](https://learn.hashicorp.com/terraform/getting-started/install.html)
- [ ] [AWS access key](https://console.aws.amazon.com/iam/home#/security_credentials)
- [ ] [Auth0](#)

## Usage

1. Clone this repo.

2. You can specify a [variable file](#variables-file) or just continue below and answer the Terraform prompts for variables.

3. Initialize Terraform wuth `terraform init`

4. Run Terraform with `terraform apply`

> If there are any errors due to timeouts or other weird stuff, try to run again `terraform apply`

## Variables file

Here is an example `terraform.tfvars` file

```hcl
/**
 * General variables
 */

organization_name = "acme"

/**
 * AWS Variables
 */

aws_profile        = "acme" // This profile was initiated when I installed the AWS Cli
aws_default_region = "us-east-1"
aws_account_id     = "11111111"
aws_role_name      = "OrganizationAccountAccessRole"


/**
 * Terraform Cloud Variables
 */

tfe_organization = "acme"
tfe_workspace    = "audit"
```
