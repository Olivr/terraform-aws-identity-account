terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "olivr-templates"

    workspaces {
      name = "identity"
    }
  }
}
