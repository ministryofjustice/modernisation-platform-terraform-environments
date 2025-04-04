locals {
  definitions = [
    for file in fileset(var.environment_directory, "*.json") : merge({
      name = replace(file, ".json", "")
    }, jsondecode(file("${var.environment_directory}/${file}")))
  ]

  applications = {
    organization_units = [
      for application in local.definitions : {
        application_name = application.name
        type             = application.account-type
      }
    ]

    accounts = flatten([
      for application in local.definitions : [
        for environment in application.environments : {
          name    = "${application.name}-${environment.name}"
          part_of = application.name
          tags = merge(application.tags, {
            is-production    = (environment.name == "production") ? true : false
            environment-name = environment.name
          })
        }
      ]
    ])

    nuke_accounts = flatten([
      for application in local.definitions : [
        for environment in application.environments :
        "${application.name}-${environment.name}"
        if application.account-type == "member"
        && environment.name == "development"
        && contains([for a in try(environment.access, []) : try(a.level, "undefined")], "sandbox")
        && try(environment.nuke, "include") != "exclude"
      ]
    ])

    rebuild_after_nuke_accounts = flatten([
      for application in local.definitions : [
        for environment in application.environments :
        "${application.name}-${environment.name}"
        if application.account-type == "member"
        && environment.name == "development"
        && contains([for a in try(environment.access, []) : try(a.level, "undefined")], "sandbox")
        && try(environment.nuke, "include") == "rebuild"
      ]
    ])

    blocklist_nuke_accounts = flatten([
      for application in local.definitions : [
        for environment in application.environments :
        "${application.name}-${environment.name}"
        if environment.name == "production" || environment.name == "preproduction" || startswith(application.name, "core")
      ]
    ])
  }
}

# Generate a random string to use for an email address for each account
resource "random_string" "email-address" {
  for_each = {
    for account in local.applications.accounts : account.name => account
  }

  length  = 16
  special = false
  upper   = false
}

# # There are more OUs within the Modernisation Platform Core, but they are managed elsewhere
# See: https://github.com/ministryofjustice/modernisation-platform
resource "aws_organizations_organizational_unit" "platforms-and-architecture-modernisation-platform-core" {
  name      = "Modernisation Platform Core"
  parent_id = var.environment_parent_organisation_id
}

# There are more OUs within the Modernisation Platform Member, but they are managed elsewhere
# See: https://github.com/ministryofjustice/modernisation-platform
resource "aws_organizations_organizational_unit" "platforms-and-architecture-modernisation-platform-member" {
  name      = "Modernisation Platform Member"
  parent_id = var.environment_parent_organisation_id
}

# There are more OUs within the Modernisation Platform Member Unrestricted, but they are managed elsewhere
# See: https://github.com/ministryofjustice/modernisation-platform
resource "aws_organizations_organizational_unit" "platforms-and-architecture-modernisation-platform-member-unrestricted" {
  name      = "Modernisation Platform Member Unrestricted"
  parent_id = var.environment_parent_organisation_id
}

# Create each application an Organizational Unit
resource "aws_organizations_organizational_unit" "applications" {
  for_each = { for idx, query in local.applications.organization_units : query.application_name => query }

  name      = "${var.environment_prefix}-${each.value.application_name}"
  parent_id = each.value.type == "core" ? aws_organizations_organizational_unit.platforms-and-architecture-modernisation-platform-core.id : each.value.type == "member" ? aws_organizations_organizational_unit.platforms-and-architecture-modernisation-platform-member.id : aws_organizations_organizational_unit.platforms-and-architecture-modernisation-platform-member-unrestricted.id
}


# Create each application's environments an account within their own Organizational Unit
resource "aws_organizations_account" "accounts" {
  for_each = {
    for account in local.applications.accounts : account.name => merge(account, {
      email = "aws+${random_string.email-address[account.name].result}@digital.justice.gov.uk"
    })
  }
  name                       = each.value.name
  email                      = each.value.email
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.applications[each.value.part_of].id

  tags = each.value.tags

  # Changing the name or email forces a replacement of the account,
  # which means the AWS account will be detached from the organisation,
  # so we want to ignore any of those changes
  lifecycle {
    ignore_changes = [name, email, iam_user_access_to_billing]
  }
}
