locals {
  definitions = [
    for file in fileset(var.environment_directory, "*.json") : merge({
      name = replace(file, ".json", "")
    }, jsondecode(file("${var.environment_directory}/${file}")))
  ]
  applications = {
    organization_units = [
      for application in local.definitions : application.name
    ]
    accounts = flatten([
      for application in local.definitions : [
        for environment in application.environments : {
          name    = "${application.name}-${environment}"
          part_of = application.name
          tags = merge(application.tags, {
            is-production    = (environment == "production") ? true : false
            environment-name = environment
          })
        }
      ]
    ])
  }
}

# Create each application an Organizational Unit
resource "aws_organizations_organizational_unit" "applications" {
  for_each  = toset(local.applications.organization_units)
  name      = "${var.environment_prefix}-${each.value}"
  parent_id = var.environment_parent_organisation_id
}

# Create each application's environments an account within their own Organizational Unit
resource "aws_organizations_account" "accounts" {
  for_each = {
    for account in local.applications.accounts : account.name => account
  }
  name                       = each.value.name
  email                      = "aws+mp+${each.value.name}@digital.justice.gov.uk"
  iam_user_access_to_billing = "ALLOW"
  parent_id                  = aws_organizations_organizational_unit.applications[each.value.part_of].id
  tags                       = each.value.tags

  # Changing the name or email forces a replacement of the account,
  # which means the AWS account will be detached from the organisation,
  # so we want to ignore any of those changes
  lifecycle {
    ignore_changes = [name, email]
  }
}
