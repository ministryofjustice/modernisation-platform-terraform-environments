# modernisation-platform-terraform-environments

[![repo standards badge](https://img.shields.io/badge/dynamic/json?color=blue&style=for-the-badge&logo=github&label=MoJ%20Compliant&query=%24.result&url=https%3A%2F%2Foperations-engineering-reports.cloud-platform.service.justice.gov.uk%2Fapi%2Fv1%2Fcompliant_public_repositories%2Fmodernisation-platform-terraform-environments)](https://operations-engineering-reports.cloud-platform.service.justice.gov.uk/public-github-repositories.html#modernisation-platform-terraform-environments "Link to report")

This repository holds a Terraform module that creates organisational units and accounts for environments.

## Usage

```
module "environments" {
  source                             = "github.com/ministryofjustice/modernisation-platform-terraform-environments"
  environment_directory              = "./environments"
  environment_parent_organisation_id = "ou-123456789"
  environment_prefix                 = "modernisation-platform"
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.47.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.47.0 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 3.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_organizations_account.accounts](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_account) | resource |
| [aws_organizations_organizational_unit.applications](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_organizational_unit) | resource |
| [aws_organizations_organizational_unit.platforms-and-architecture-modernisation-platform-core](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_organizational_unit) | resource |
| [aws_organizations_organizational_unit.platforms-and-architecture-modernisation-platform-member](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_organizational_unit) | resource |
| [aws_organizations_organizational_unit.platforms-and-architecture-modernisation-platform-member-unrestricted](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_organizational_unit) | resource |
| [random_string.email-address](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment_directory"></a> [environment\_directory](#input\_environment\_directory) | Directory path for environment definitions | `string` | n/a | yes |
| <a name="input_environment_parent_organisation_id"></a> [environment\_parent\_organisation\_id](#input\_environment\_parent\_organisation\_id) | Organisation ID for newly configured environments to sit within | `string` | n/a | yes |
| <a name="input_environment_prefix"></a> [environment\_prefix](#input\_environment\_prefix) | Prefix for all new environment and account names | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_environment_account_ids"></a> [environment\_account\_ids](#output\_environment\_account\_ids) | Map of account keys and their IDs (e.g. { account\_name => 1234567890 }) |
| <a name="output_environment_nuke_accounts"></a> [environment\_nuke\_accounts](#output\_environment\_nuke\_accounts) | List of autonuke account names. |
| <a name="output_environment_nuke_blocklist_accounts"></a> [environment\_nuke\_blocklist\_accounts](#output\_environment\_nuke\_blocklist\_accounts) | List of account names blocklisted from autonuke. |
| <a name="output_environment_rebuild_after_nuke_accounts"></a> [environment\_rebuild\_after\_nuke\_accounts](#output\_environment\_rebuild\_after\_nuke\_accounts) | List of rebuild-after-autonuke account names. |
| <a name="output_modernisation_platform_core_ou_id"></a> [modernisation\_platform\_core\_ou\_id](#output\_modernisation\_platform\_core\_ou\_id) | n/a |
| <a name="output_modernisation_platform_member_ou_id"></a> [modernisation\_platform\_member\_ou\_id](#output\_modernisation\_platform\_member\_ou\_id) | n/a |
| <a name="output_modernisation_platform_member_unrestricted_ou_id"></a> [modernisation\_platform\_member\_unrestricted\_ou\_id](#output\_modernisation\_platform\_member\_unrestricted\_ou\_id) | n/a |

<!-- END_TF_DOCS -->

## Looking for issues?

If you're looking to raise an issue with this module, please create a new issue in the [Modernisation Platform repository](https://github.com/ministryofjustice/modernisation-platform/issues).
