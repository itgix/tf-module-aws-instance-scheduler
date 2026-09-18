locals {
  # Empty suffix keeps the names identical to deployments made before name_suffix existed.
  suffix = var.name_suffix == "" ? "" : "-${var.name_suffix}"
}
