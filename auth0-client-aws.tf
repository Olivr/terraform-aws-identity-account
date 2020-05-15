/**
 * Create AWS SSO client
 */

resource "auth0_client" "aws" {
  //tfsec:ignore:GEN003
  token_endpoint_auth_method         = "client_secret_post"
  name                                = "AWS SSO"
  is_token_endpoint_ip_header_trusted = false
  is_first_party                      = true
  oidc_conformant                     = true
  sso_disabled                        = false
  cross_origin_auth                   = false
  callbacks                           = ["https://signin.aws.amazon.com/saml"]
  app_type                            = "regular_web"
  grant_types = [
    "authorization_code",
    "refresh_token"
  ]

  addons {
    samlp {
      audience = "https://signin.aws.amazon.com/saml"
      mappings = {
        email = "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress"
        name  = "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name"
      }
      create_upn_claim                   = false
      passthrough_claims_with_no_mapping = false
      map_unknown_claims_as_is           = false
      map_identities                     = false
      name_identifier_format             = "urn:oasis:names:tc:SAML:2.0:nameid-format:persistent"
      name_identifier_probes = [
        "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress"
      ]
    }
  }
}

/*
 * Create rules to use AWS roles specified in Cognito groups when logging in (authorization)
 */

resource "auth0_rule" "aws_role_mapping" {
  name    = "aws-role-mapping"
  enabled = true
  script  = <<-EOF
  function (user, context, callback) {

    user.awsRole = user['cognito:preferred_role'] + ",${aws_iam_saml_provider.auth0.arn}";
    user.awsRoleSessionName = user.name;

    context.samlConfiguration.mappings = {
      'https://aws.amazon.com/SAML/Attributes/Role': 'awsRole',
      'https://aws.amazon.com/SAML/Attributes/RoleSessionName': 'awsRoleSessionName'
    };

    callback(null, user, context);

  }
EOF
}
