provider "aws" {}

locals {
  applications = flatten([
    for type in var.environment_types : [
      for application in fileset("${var.environment_directory}/${type}", "*.json") : {
        application = jsondecode(file("${var.environment_directory}/${type}/${application}"))
        namespace   = type
      }
    ]
  ])
  application_ous = {
    for definition in local.applications :
    definition.application.name => definition.namespace
  }
  application_envs = flatten([
    for definition in local.applications : [
      for env in definition.application.environments : {
        definition = definition
        namespace  = env
      }
    ]
  ])
  application_envs_accounts = {
    for account in local.application_envs :
    "${account.definition.application.name}-${account.namespace}" => account
  }
}

# Create environment type organisation units
resource "aws_organizations_organizational_unit" "types" {
  for_each  = toset(var.environment_types)
  name      = "${var.environment_prefix}-${each.value}"
  parent_id = var.environment_parent_organisation_id
}

# Create application organisation units
resource "aws_organizations_organizational_unit" "applications" {
  for_each  = local.application_ous
  name      = "${var.environment_prefix}-${each.key}-${each.value}"
  parent_id = aws_organizations_organizational_unit.types[each.value].id
}

# Create application accounts in their respective OUs
resource "aws_organizations_account" "accounts" {
  for_each                   = local.application_envs_accounts
  name                       = each.key
  email                      = "aws+mp+${each.key}@digital.justice.gov.uk"
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.applications[each.value.definition.application.name].id
  tags                       = each.value.definition.application.tags
}
