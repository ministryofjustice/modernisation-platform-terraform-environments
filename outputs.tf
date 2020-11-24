output "environment_account_ids" {
  sensitive = true
  value = {
    for key, account in aws_organizations_account.accounts :
    key => account.id
  }
}
