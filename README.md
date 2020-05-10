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

<!-- auto-terraform-environment-variables -->

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

<!-- auto-terraform-environment-variables -->

<!-- auto-terraform-variables -->

### Input Variables

| Name                                      | Description                                                                                                                                                                                             | Type                     | Default | Required |
| ----------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------ | ------- | :------: |
| namespace                                 | Namespace for naming resources (eg. `ac` for Acme)                                                                                                                                                      | `string`                 | n/a     |   yes    |
| environment                               | Environment (eg. dev, prod, staging)                                                                                                                                                                    | `string`                 | n/a     |   yes    |
| attributes                                | List of attributes (eg. internal, public)                                                                                                                                                               | `list(string)`           | `null`  |    no    |
| pgp_key                                   | PGP key in plain text or using the format `keybase:username` to encrypt user keys and passwords                                                                                                         | `string`                 | `null`  |    no    |
| aws_assume_role_arn                       | AWS role arn to assume when running this script (if any)                                                                                                                                                | `string`                 | `null`  |    no    |
| aws_iam_roles                             | AWS roles to create. If you set the value `cognito` in `assumable_by_federated`, it will be replaced by the newly created Cognito instance, eg. `{ MyRole = { assumable_by_federated = ["cognito"] } }` | `map(map(list(string)))` | `{}`    |    no    |
| aws_iam_groups                            | AWS groups to create. It should be specified using a map of groups and their attributes, eg. `{ MyGroup = { policies = ["arn:xxx", ...], assume_roles = ["arn:xxx", ...] }, ...}`                       | `map(map(list(string)))` | `{}`    |    no    |
| aws_iam_users                             | AWS users to create. You can specify a simple list, eg. `["user-1", ...]` or a map of users and their groups, eg. `{ user-1 = ["MyGroup", ...], ...}`.                                                  | `any`                    | `{}`    |    no    |
| aws_cognito_custom_domain                 | Cognito custom domain name. To use this, you must also specify `aws_cognito_custom_domain_certificate_arn`.                                                                                             | `string`                 | `null`  |    no    |
| aws_cognito_custom_domain_certificate_arn | ARN of an issued ACM certificate for the Cognito custom domain name.                                                                                                                                    | `string`                 | `null`  |    no    |
| aws_cognito_groups                        | n/a                                                                                                                                                                                                     | `map(map(string))`       | `{}`    |    no    |
| aws_cognito_user_fields                   | User profile fields to add to your Cognito user pool, eg. email, birthdate, twitter                                                                                                                     | `map`                    | `{}`    |    no    |
| aws_cognito_allowed_callback_urls         | List of URLs that Cognito clients can redirect to.                                                                                                                                                      | `list(string)`           | `[]`    |    no    |
| aws_cognito_allowed_logout_urls           | List of URLs that Cognito clients can redirect to after logout (any url added here also need to be added in callback if making use of `redirect_uri`).                                                  | `list(string)`           | `[]`    |    no    |
| tfe_organization                          | Terraform Cloud organization name                                                                                                                                                                       | `string`                 | `null`  |    no    |
| tfe_workspace                             | Terraform Cloud workspace name                                                                                                                                                                          | `string`                 | `null`  |    no    |
| auth0_domain                              | Auth0 domain                                                                                                                                                                                            | `string`                 | n/a     |   yes    |
| auth0_cert                                | Auth0 certificate. Can be found at <https://>`YOUR AUTH0 DOMAIN`/pem                                                                                                                                    | `string`                 | n/a     |   yes    |

### Outputs

| Name                 | Description                                                                         |
| -------------------- | ----------------------------------------------------------------------------------- |
| iam_roles            | n/a                                                                                 |
| iam_users_with_roles | n/a                                                                                 |
| cognito_domain_alias | CNAME alias to use to finalize configuration of your custom cognito domain (if any) |
| aws_signin_url       | n/a                                                                                 |

<!-- auto-terraform-variables -->

## How to get Auth0 API credentials

1. From [your dashboard](https://manage.auth0.com/dashboard), go to APIs > Auth0 Management API > API Explorer

2. Click on **Create & authorize test application**

3. Click on the "Machine to Machine Applications" tab

4. Click on "API Explorer Application"

5. Copy the Domain, Client ID, Secret

> Change the name to "Terraform" so you remember what this application is about

<!-- auto-support -->

## Support

Create a new issue on this GitHub repository.

<!-- auto-support -->

<!-- auto-contribute -->

## Contributing

All contributions are welcome! Please see the [docs/CONTRIBUTING.md](docs/CONTRIBUTING.md)

<!-- auto-contribute -->

<!-- auto-license -->

## License

This project is licensed under the Apache 2.0 License - see the LICENSE file for details

<!-- auto-license -->

<!-- auto-about-org -->

## About olivr

[Olivr](https://olivr.com) is an AI co-founder for your startup.

<!-- auto-about-org -->
