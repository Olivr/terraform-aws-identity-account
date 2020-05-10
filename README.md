# Identity account

An "identity" AWS account setup using Cognito as an identity provider in AWS IAM.

## Features

- **Pure Terraform script with no third-party wrapper - easy to apprehend and evolve**
- Setup a Cognito user pool to serve as an identity provider (users and groups)
- Setup a Auth0 application to serve as a versatile SSO middleware
- Configure an AWS IAM identity provider to login to AWS using Auth0
- Setup IAM roles, groups and users

## Pre-requisites

- [ ] [Terraform CLI](https://learn.hashicorp.com/terraform/getting-started/install.html)
- [ ] [AWS access key ID/secret](https://console.aws.amazon.com/iam/home#/security_credentials)
- [ ] [Auth0 API credentials](#how-to-get-auth0-api-credentials)

## Usage

1. Clone this repo.

2. Define your [variables](#variables)

3. Initialize Terraform `terraform init`

4. Run Terraform `terraform apply`

> If there are any errors due to timeouts or other weird stuff, try to run again `terraform apply`, most of the time, it will fix the problem

## Variables

<!-- terraform-env-docs -->

### Environment variables

First, you need to set the environment variables.

> If you want, you can [use an .env file](#using-an-env-file)

#### AWS

> You can use `AWS_PROFILE` instead of `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`

- `AWS_DEFAULT_REGION`
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`

#### Auth0

- `AUTH0_CLIENT_ID`
- `AUTH0_CLIENT_SECRET`

#### Using an .env file

1. Copy the example env file `cp .env-example .env && chmod +x .env`

2. Edit `.env` with your values

3. Load the environment variables `. ./.env`

<!-- terraform-env-docs -->

<!-- terraform-docs -->

### Input Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| namespace | Namespace for naming resources (eg. `ac` for Acme) | `string` | n/a | yes |
| environment | Environment (eg. dev, prod, staging) | `string` | n/a | yes |
| attributes | List of attributes (eg. internal, public) | `list(string)` | `null` | no |
| pgp\_key | PGP key in plain text or using the format `keybase:username` to encrypt user keys and passwords | `string` | `null` | no |
| aws\_assume\_role\_arn | AWS role arn to assume when running this script (if any) | `string` | `null` | no |
| aws\_iam\_roles | AWS roles to create. If you set the value `cognito` in `assumable_by_federated`, it will be replaced by the newly created Cognito instance, eg. `{ MyRole = { assumable_by_federated = ["cognito"] } }` | `map(map(list(string)))` | `{}` | no |
| aws\_iam\_groups | AWS groups to create. It should be specified using a map of groups and their attributes, eg. `{ MyGroup = { policies = ["arn:xxx", ...], assume_roles = ["arn:xxx", ...] }, ...}` | `map(map(list(string)))` | `{}` | no |
| aws\_iam\_users | AWS users to create. You can specify a simple list, eg. `["user-1", ...]` or a map of users and their groups, eg. `{ user-1 = ["MyGroup", ...], ...}`. | `any` | `{}` | no |
| aws\_cognito\_custom\_domain | Cognito custom domain name. To use this, you must also specify `aws_cognito_custom_domain_certificate_arn`. | `string` | `null` | no |
| aws\_cognito\_custom\_domain\_certificate\_arn | ARN of an issued ACM certificate for the Cognito custom domain name. | `string` | `null` | no |
| aws\_cognito\_groups | n/a | `map(map(string))` | `{}` | no |
| aws\_cognito\_user\_fields | User profile fields to add to your Cognito user pool, eg. email, birthdate, twitter | `map` | `{}` | no |
| aws\_cognito\_allowed\_callback\_urls | List of URLs that Cognito clients can redirect to. | `list(string)` | `[]` | no |
| aws\_cognito\_allowed\_logout\_urls | List of URLs that Cognito clients can redirect to after logout (any url added here also need to be added in callback if making use of `redirect_uri`). | `list(string)` | `[]` | no |
| tfe\_organization | Terraform Cloud organization name | `string` | `null` | no |
| tfe\_workspace | Terraform Cloud workspace name | `string` | `null` | no |
| auth0\_domain | Auth0 domain | `string` | n/a | yes |
| auth0\_cert | Auth0 certificate. Can be found at https://`YOUR AUTH0 DOMAIN`/pem | `string` | n/a | yes |

### Outputs

| Name | Description |
|------|-------------|
| iam\_roles | n/a |
| iam\_users\_with\_roles | n/a |
| cognito\_domain\_alias | CNAME alias to use to finalize configuration of your custom cognito domain (if any) |
| aws\_signin\_url | n/a |

<!-- terraform-docs -->

## How to get Auth0 API credentials

1. From [your dashboard](https://manage.auth0.com/dashboard), go to APIs > Auth0 Management API > API Explorer

2. Click on **Create & authorize test application**

3. Click on the "Machine to Machine Applications" tab

4. Click on "API Explorer Application"

5. Copy the Domain, Client ID, Secret

> Change the name to "Terraform" so you remember what this application is about
