output "environment_account_ids" {
  sensitive = true
  value = {
    for key, account in aws_organizations_account.accounts :
    key => account.id
  }
  description = "Map of account keys and their IDs (e.g. { account_name => 1234567890 })"
}

output "environment_nuke_accounts" {
  sensitive = true
  value = local.applications.nuke_accounts[*].name
  description = "List of autonuke account names."
}

output "environment_rebuild_after_nuke_accounts" {
  sensitive = true
  value = local.applications.rebuild_after_nuke_accounts[*].name
  description = "List of rebuild-after-autonuke account names."
}

output "environment_nuke_blacklist_accounts" {
  sensitive = true
  value = local.applications.blacklist_nuke_accounts[*].name
  description = "List of account names blacklisted from autonuke."
}

output "modernisation_platform_core_ou_id" {
  sensitive = true
  value     = aws_organizations_organizational_unit.platforms-and-architecture-modernisation-platform-core.id
}

output "modernisation_platform_member_ou_id" {
  sensitive = true
  value     = aws_organizations_organizational_unit.platforms-and-architecture-modernisation-platform-member.id
}

output "modernisation_platform_member_unrestricted_ou_id" {
  sensitive = true
  value     = aws_organizations_organizational_unit.platforms-and-architecture-modernisation-platform-member-unrestricted.id
}
