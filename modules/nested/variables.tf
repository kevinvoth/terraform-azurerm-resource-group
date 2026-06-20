
variable "resource_group_name" {
  description = "Resource group name."
  type        = string
}

variable "location" {
  description = "Azure region to use."
  type        = string
}

variable "tags" {
  description = "Tags for the resource group."
  type        = map(string)
}
