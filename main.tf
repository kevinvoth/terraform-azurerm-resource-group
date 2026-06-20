

module "resource_groups" {
  for_each            = { for rg in local.rgs : rg.name => rg }
  source              = "./modules/nested"
  resource_group_name = each.key
  location            = each.value.location
  tags                = each.value.tags
}
