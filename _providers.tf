// Providers
provider "aws" {
  region              = var.aws_default_region
  allowed_account_ids = [var.aws_account_id]
  profile             = var.aws_profile

  assume_role {
    role_arn = "arn:aws:iam::${var.aws_account_id}:role/${var.aws_role_name}"
  }
}

terraform {
  required_providers {
    aws = "~> 2.58"
  }
}
