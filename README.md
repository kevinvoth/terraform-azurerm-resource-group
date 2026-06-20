# terraform-azurerm-resource-group

This Terraform module creates Azure Resource Groups from YAML configuration files.

**Overview**

- Reads all `*.yaml` files from the `config/rg` directory at the root module (uses `fileset("${path.root}/config/rg", "*.yaml")`).
- Each YAML file may contain a top-level `resource_groups` list describing one or more resource groups to create.
- For each entry the module provisions an `azurerm_resource_group` via the nested module at `modules/nested`.

**Requirements**

- Terraform >= 1.6.0
- Provider: `azurerm` ~> 4.0

**How it works**

- The root module collects YAML files and decodes them with `yamldecode()` into `local.input_configs`.
- It extracts `resource_groups` from each decoded file and flattens them into `local.rgs`.
- A `for_each` module block (`module "resource_groups"`) instantiates the nested module for every RG in `local.rgs`.

**YAML config format**

Place files named `*.yaml` under the root module directory `config/rg/` (the module uses `${path.root}/config/rg`). Example file `config/rg/example.yaml`:

```yaml
resource_groups:
	- name: my-resource-group
		location: eastus
		tags:
			environment: dev
			owner: team

	- name: another-rg
		location: westus2
		tags:
			environment: prod
```

Each `resource_groups` entry must include:
- `name` (string) — resource group name
- `location` (string) — Azure region
- `tags` (map) — map of tag keys/values

**Usage (root module)**

Minimal example that calls this module from your root configuration (assumes the `config/rg/*.yaml` files exist in the root):

```hcl
module "resource_groups" {
	source = "../module/terraform-azurerm-resource-group"
}
```

If you reference this module from a remote source (registry or VCS), set `source` appropriately.

**Outputs**

- `yaml_files`: list — list of YAML file names discovered under `config/rg`.
- `input_configs`: list — decoded YAML documents.
- `rgs`: map(object) — mapping of resource-group name => object (the parsed RG data).
- `resource_group_ids`: map — the `module.resource_groups` collection (each entry exposes the nested module outputs, e.g. `module.resource_groups["my-resource-group"].resource_group_id`).

**Accessing created RG IDs**

To get the ID of a specific resource group created by the module:

```hcl
module.resource_groups["my-resource-group"].resource_group_id
```

**Notes & Caveats**

- The module expects YAML files under the root module `config/rg/` (because it uses `${path.root}`), not relative to the module source directory.
- All fields (`name`, `location`, `tags`) are required per entry because the nested module's variables are required (no defaults).
- Keep `*.tfstate` and sensitive values out of version control and configure a remote backend for shared usage.

**Provider / Versions**

See `versions.tf` in this module for the required Terraform and provider versions.

**Example quick steps**

1. Add this module to your root `main.tf` with `source` pointing to this module.
2. Create one or more YAML files under `config/rg/` (see example above).
3. Run:

```bash
terraform init
terraform plan
terraform apply
```

**License**

No license is specified in this repository; add a license file if you intend to publish or share.
