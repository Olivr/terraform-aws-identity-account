provider "auth0" {
  domain = var.auth0_domain
}

provider "aws" {
  assume_role {
    role_arn = var.aws_assume_role_arn
  }
}
