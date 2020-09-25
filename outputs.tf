output "environment_account_ids" {
  sensitive = true
  value = {
    for account in aws_organizations_account.accounts:
      account.name => account.id
  }
}
