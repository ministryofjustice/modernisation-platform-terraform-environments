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

## Inputs

|                Name                |                           Description                           |  Type  | Default | Required |
| :--------------------------------: | :-------------------------------------------------------------: | :----: | :-----: | -------- |
|       environment_directory        |           Directory path for environment definitions            | string |   n/a   | yes      |
| environment_parent_organisation_id | Organisation ID for newly configured environments to sit within | string |   n/a   | yes      |
|         environment_prefix         |        Prefix for all new environment and account names         | string |   n/a   | yes      |

## Outputs

| Name                    | Description                                | Sensitive |
| ----------------------- | ------------------------------------------ | --------- |
| environment_account_ids | Account IDs for the newly created accounts | yes       |

## Looking for issues?

If you're looking to raise an issue with this module, please create a new issue in the [Modernisation Platform repository](https://github.com/ministryofjustice/modernisation-platform/issues).
