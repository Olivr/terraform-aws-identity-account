# Identity account

An "identity" AWS account setup using Cognito as an identity provider in AWS IAM.

## Features

- **Pure Terraform script with no third-party wrapper - easy to apprehend and evolve**
- Costs **\$0** per month
- Setup a Cognito user pool to serve as an identity provider (users and groups)
- Setup a Auth0 application to serve as a versatile SSO middleware
- Configure an AWS IAM identity provider to login to AWS using Auth0
- Setup IAM roles, groups and users

## Costs

This setup costs **\$0** per month as it falls in the AWS and Auth0 free-tiers.

> This is an informative cost. We cannot be held responsible if more costs are incurred to your account as a result of using this script.

## Pre-requisites

- [ ] [Terraform CLI](https://learn.hashicorp.com/terraform/getting-started/install.html)
- [ ] [AWS access key ID/secret](https://console.aws.amazon.com/iam/home#/security_credentials)
- [ ] [Auth0 API credentials](#how-to-get-auth0-api-credentials)
- [ ] [Terraform Cloud team API key](#backend)

## Usage

Click on the button

[![use this template](https://raw.githubusercontent.com/olivr-com/defaults/master/docs/images/usetemplate.png)](https://github.com/olivr-templates/infra-identity/generate)

- Setup your [backend](#backend)

- Define your [variables](#variables)

- Initialize Terraform `terraform init`

- Run Terraform `terraform plan`

- If it looks good, run Terraform `terraform apply`

> If there are any errors due to timeouts or other weird stuff, try to run again `terraform apply`, most of the time, it will fix the problem

- Create your console users in [Cognito](https://console.aws.amazon.com/cognito/home?region=us-east-1), add them to the correct group and give them the signin URL (`terraform output aws_signin_url`)

- Your programmatic users should be created in IAM or, even better, added to the `_var_aws_iam_users.auto.tfvars.json`.
  You can see their access keys by running `terraform output iam_users_with_roles` (look for _access_key_secret_decrypt_command_ values to show the secrets)

<!-- auto-terraform-backend -->
## Backend

This script is pre-configured to use the Terraform Cloud backend.

1. Edit the backend settings in `backend.tf`

2. Add a [GitHub secret](https://help.github.com/en/actions/configuring-and-managing-workflows/creating-and-storing-encrypted-secrets) called `TF_API_TOKEN` with a [Terraform Cloud team token](https://www.terraform.io/docs/cloud/users-teams-organizations/api-tokens.html#team-api-tokens) as its value

> Don't forget to set the environment variables or any other required variable in your Terraform Cloud workspace

<!-- auto-terraform-backend -->

## Variables

### Examples

There are a set of `_var_XYZ.auto.tfvars.json` and `_variables.auto.tfvars` to serve as example values for the various variables. They are automatically loaded when a Terraform plan/apply is run.

You can also set/overwrite the values in these files in your Terraform Cloud workspace variables.

> Read more about [Terraform variables](https://www.terraform.io/docs/configuration/variables.html)

<!-- auto-environment-variables -->
### Environment variables

#### Using an .env file for your local environment

1. Copy the example env file `cp .env-example .env && chmod +x .env`

2. Edit `.env` with your values

3. Load the environment variables `. ./.env`

<!-- auto-environment-variables -->

<!-- auto-terraform-env -->
#### AWS

> You can use `AWS_PROFILE` instead of `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`

- `AWS_DEFAULT_REGION`
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`

#### Auth0

- `AUTH0_CLIENT_ID`
- `AUTH0_CLIENT_SECRET`
<!-- auto-terraform-env -->

<!-- auto-terraform-variables -->
### Input Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| namespace | Namespace for naming resources (eg. `ac` for Acme) | `string` | n/a | yes |
| environment | Environment (eg. dev, prod, staging) | `string` | n/a | yes |
| attributes | List of attributes (eg. internal, public) | `list(string)` | `null` | no |
| pgp\_key | PGP key in plain text or using the format `keybase:username` to encrypt user keys and passwords | `string` | `null` | no |
| aws\_assume\_role\_arn | AWS role arn to assume when running this script (if any) | `string` | `null` | no |
| aws\_iam\_roles | AWS roles to create. If you set the value `cognito` in `assumable_by_federated`, it will be replaced by the newly created Cognito instance, eg. `{ MyRole = { assumable_by_federated = ["cognito"] } }`. See [\_var\_aws\_iam\_roles.auto.tfvars.json](\_var\_aws\_iam\_roles.auto.tfvars.json) for the format. | `map(map(list(string)))` | `{}` | no |
| aws\_iam\_groups | AWS groups to create. It should be specified using a map of groups and their attributes. See [\_var\_aws\_iam\_groups.auto.tfvars.json](\_var\_aws\_iam\_groups.auto.tfvars.json) for the format. | `map(map(list(string)))` | `{}` | no |
| aws\_iam\_users | AWS users to create. You can specify a simple list, eg. `["user-1", ...]` or a map of users and their groups. See [\_var\_aws\_iam\_users.auto.tfvars.json](\_var\_aws\_iam\_users.auto.tfvars.json) for the format. | `any` | `{}` | no |
| aws\_cognito\_custom\_domain | Cognito custom domain name. To use this, you must also specify `aws_cognito_custom_domain_certificate_arn`. | `string` | `null` | no |
| aws\_cognito\_custom\_domain\_certificate\_arn | ARN of an issued ACM certificate for the Cognito custom domain name. | `string` | `null` | no |
| aws\_cognito\_groups | Cognito groups to create. See [\_var\_aws\_cognito\_groups.auto.tfvars.json](\_var\_aws\_cognito\_groups.auto.tfvars.json) for the format. | `map(map(string))` | `{}` | no |
| aws\_cognito\_user\_fields | User profile fields to add to your Cognito user pool, eg. email, birthdate, twitter. See [\_var\_aws\_cognito\_user\_fields.auto.tfvars.json](\_var\_aws\_cognito\_user\_fields.auto.tfvars.json) for the format. | `map` | `{}` | no |
| aws\_cognito\_allowed\_callback\_urls | List of URLs that Cognito clients can redirect to. | `list(string)` | `[]` | no |
| aws\_cognito\_allowed\_logout\_urls | List of URLs that Cognito clients can redirect to after logout (any url added here also need to be added in callback if making use of `redirect_uri`). | `list(string)` | `[]` | no |
| tfe\_organization | Terraform Cloud organization name. | `string` | `null` | no |
| tfe\_workspace | Terraform Cloud workspace name. | `string` | `null` | no |
| auth0\_domain | Auth0 domain. | `string` | n/a | yes |
| auth0\_cert | Auth0 certificate. Can be found at `https://YOUR-AUTH0-DOMAIN/pem`. | `string` | n/a | yes |

### Outputs

| Name | Description |
|------|-------------|
| iam\_roles | List of IAM roles that were created |
| iam\_users\_with\_roles | List of IAM users that were created along with their roles and encrypted access key secrets |
| cognito\_domain\_alias | CNAME alias to use to finalize configuration of your custom cognito domain (if any) |
| aws\_signin\_url | URL your Cognito users should use to signin to the AWS Console |

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

:closed_lock_with_key: Join us on Keybase chat: [/team/olivr](https://keybase.io/team/olivr)

Or you can use our Reddit community: [/r/olivr](https://www.reddit.com/r/olivr/)

<!-- auto-support -->

<!-- auto-contribute -->

## Contributing

All contributions are welcome! Please see the [docs/CONTRIBUTING.md](docs/CONTRIBUTING.md)

<!-- auto-contribute -->

<!-- auto-license -->
## License

This project is licensed under the Apache 2.0 License - see the [LICENSE](LICENSE) file for details

<!-- auto-license -->

<!-- auto-about-org -->

## About olivr

[Olivr](https://olivr.com) is an AI co-founder for your startup.

<!-- auto-about-org -->
