locals {
  name_prefix = "${var.tags["Service"]}-${var.tags["Environment"]}-${var.tags["RegionAlias"]}"
  cluster     = "${var.tags["Service"]}-${var.tags["Environment"]}-${var.tags["RegionAlias"]}-cluster"
}