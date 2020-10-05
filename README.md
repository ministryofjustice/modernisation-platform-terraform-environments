# modernisation-platform-terraform-environments

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
|:----------------------------------:|:---------------------------------------------------------------:|:------:|:-------:|----------|
|        environment_directory       |            Directory path for environment definitions           | string |   n/a   | yes      |
| environment_parent_organisation_id | Organisation ID for newly configured environments to sit within | string |   n/a   | yes      |
|         environment_prefix         |         Prefix for all new environment and account names        | string |   n/a   | yes      |

## Outputs
| Name                    | Description                                | Sensitive |
|-------------------------|--------------------------------------------|-----------|
| environment_account_ids | Account IDs for the newly created accounts | Yes       |

## Looking for issues?
If you're looking to raise an issue with this module, please create a new issue in the [Modernisation Platform repository](https://github.com/ministryofjustice/modernisation-platform/issues).
