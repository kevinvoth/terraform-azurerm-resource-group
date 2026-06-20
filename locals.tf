
locals {
  input_files = fileset("${path.root}/config/rg", "*.yaml")

  input_configs = [for file in local.input_files : yamldecode(file("${path.root}/config/rg/${file}"))]

  rgs = flatten([for config in local.input_configs : try(config["resource_groups"], [])])
}
