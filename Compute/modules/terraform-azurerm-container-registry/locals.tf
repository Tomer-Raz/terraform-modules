locals {
  name_prefix = "${var.name_convention.region}${var.name_convention.name}${var.name_convention.env}${var.name_convention.cmdb_infra}${var.name_convention.cmdb_project}"
}