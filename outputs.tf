output "environment_account_ids" {
  sensitive = true
  value = {
    for key, account in aws_organizations_account.accounts :
    key => account.id
  }
  description = "Map of account keys and their IDs (e.g. { account_name => 1234567890 })"
}
