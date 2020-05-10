/**
 * Create G Suite SSO client
 */

resource "auth0_client" "gsuite" {
  //tfsec:ignore:GEN003
  token_endpoint_auth_method          = "client_secret_post"
  name                                = "G Suite SSO"
  is_token_endpoint_ip_header_trusted = false
  is_first_party                      = true
  oidc_conformant                     = true
  sso_disabled                        = false
  cross_origin_auth                   = false
  app_type                            = "regular_web"
  callbacks                           = ["https://www.google.com/a/please.com/acs"]
  allowed_logout_urls                 = ["${local.aws_cognito_auth_url}/logout"]
  grant_types = [
    "authorization_code",
    "implicit",
    "refresh_token",
    "client_credentials"
  ]
  jwt_configuration {
    alg = "RS256"
  }

  addons {
    samlp {
      audience = "https://www.google.com/a/please.com/acs"
      mappings = {
        nickname = "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name"
      }
      create_upn_claim                   = false
      passthrough_claims_with_no_mapping = false
      map_unknown_claims_as_is           = false
      map_identities                     = false
      signature_algorithm                = "rsa-sha256"
      digest_algorithm                   = "sha256"

      name_identifier_format = "urn:oasis:names:tc:SAML:2.0:nameid-format:email"
      name_identifier_probes = [
        "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress"
      ]
    }
  }
}
