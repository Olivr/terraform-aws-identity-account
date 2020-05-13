/**
 * Generic
 * This is used for naming and tagging resources, change as you wish
 */

namespace   = "ot"
environment = "prod"
attributes  = ["internal"]
// We added this attribute to differentiate this setup from another
// Cognito/Auth0 setup for external customers


/**
 * Security
 */

pgp_key = "keybase:YOUR-KEYBASE-USERNAME"


/**
 * Terraform Cloud
 */

tfe_organization = "olivr-templates"
tfe_workspace    = "identity"


/**
 * AWS
 * You should be using an IAM user from the root account.
 * This is the role it has to assume to make modifications in your identity sub-account.
 */

aws_assume_role_arn = "arn:aws:iam::YOUR-IDENTITY-ACCOUNT-ID:role/OrganizationAccountAccessRole"

/**
 * Auth0
 */

auth0_domain = "YOUR-AUTH0-DOMAIN"

// Certificate for your domain can be found on https://YOUR-AUTH0-DOMAIN/pem
auth0_cert = <<EOF
MIIDETCCAfmgAwIBAgILb2Kn3zL1nWyKMA0GCSqGSIb3DQEBCwUAMCYxJDAiBgNV
BAMTG3Rlc3RpbmctdGVycmFmb3JtLmF1dGgwLmNvbTAeFw0yMDA1MDMwNzIzNTNa
Fw0zNDAxMTAwNzIzNTNaMCYxJDAiBgNVBAMTG3Rlc3RpbmctdGVycmFmb3JtLmF1
dGgwLmNvbTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMs/y99MpTtm
Kfz6yVv/UTk2Xmw6vE2bP0L9mFqGy4UcJSeg5ivSTNXF1mTzXDEfr8MZgLrZy72z
5lrZFc8E8PdqewKDvO0GUzKsU2NMZeTUSLaMtv1zva5Oecm+gcNWhY874Fa8IBB7
dFRb0UmF8PSdqurD7EVUOM05l1rTEEwVK/6g7hALOqUVIm1tZDaS+WXxh44JEipV
9ry/OL+mbj63asg0NrYt8+53zc+JB2LEcYhasSXlqbZsPF6v6mT3Q8n1oJiQf8IA
3/TOpzqLpn2+sDsd448g2fZommjtWwb6pf1LDqXo0E7hpY2gvXNGU+5NbJe10syj
EcAOtesOHqcCAwEAAaNCMEAwDwYDVR0TAQH/BAUwAwEB/zAdBgNVHQ4EFgQUNcJ9
9Yo1MyvrTP56xRCA47tQaMQwDgYDVR0PAQH/BAZDAgKEMA0GCSqGSIb3DQEBCwUA
A4IBAQBx2BXJaUBihMgflcUGf5w4659a2Y2GZJ4BXrlkPqzT3YfX3Mr31Kwr7Vqv
Xwkm/eaZX/gImdWUp9b1tXNgSY95enibCiyDWwZNIxvmixXAbulw0tJET7F+mKK2
RhnGA93hwGvd0imyVYxDwEDOEnaEGW7wpBtWsFrKkRQMS7rV7cPENjpmKNieU2M8
ZOVr836+oYQNvfLZ/Sdk5TA+WfZhXBIhNlyJMk62cK6mLSZHn/GkwRmygK2OMvkg
vptGE08WRs0zyQqIBIngIT9VwoKOo5JfVJGQpXmEnQEevEObyl4NOdO/p6h85IzS
pFr8UMz7O5GfvVyv4ed56Cnf4f3L
EOF
