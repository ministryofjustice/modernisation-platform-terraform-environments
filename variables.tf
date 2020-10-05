variable "environment_directory" {
  description = "Directory path for environment definitions"
  type        = string
}

variable "environment_parent_organisation_id" {
  description = "Organisation ID for newly configured environments to sit within"
  type        = string
}

variable "environment_prefix" {
  description = "Prefix for all new environment and account names"
  type        = string
}
