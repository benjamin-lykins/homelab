// This data block fetches the SSH public keys from a specified GitHub account.
// The URL is constructed using the `github_account` variable, which should be
// provided elsewhere in the configuration. The keys are retrieved from the
// GitHub user's public keys endpoint.

# data "http" "key" {
#   url = "https://github.com/${var.github_account}.keys"
# }