
output "yaml_files" {
  description = "List of YAML files."
  value       = local.input_files
}

output "input_configs" {
  description = "Parsed configurations from YAML files."
  value       = local.input_configs
}

output "rgs" {
  description = "List of parsed YAML configurations."
  value       =    { for rg in local.rgs : rg.name => rg } 
}

output "resource_group_ids" {
  description = "List of resource group IDs."
  value       = module.resource_groups
}
