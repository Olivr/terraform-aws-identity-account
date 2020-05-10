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

<!-- auto-terraform-variables -->

## How to get Auth0 API credentials

1. From [your dashboard](https://manage.auth0.com/dashboard), go to APIs > Auth0 Management API > API Explorer

2. Click on **Create & authorize test application**

3. Click on the "Machine to Machine Applications" tab

4. Click on "API Explorer Application"

5. Copy the Domain, Client ID, Secret

> Change the name to "Terraform" so you remember what this application is about

<!-- auto-about-olivr -->

## About olivr

[Olivr](https://olivr.com) is an AI co-founder for your startup.

<!-- auto-about-olivr -->
