variable "runbooks" {
  type = any
  default = {}
  description = "Value for run books. This is a collection of values as defined in runbook.tfvars"
}

module "runbook" {
    for_each = var.runbooks
    source = "github.com/canada-ca-terraform-modules/terraform-azurerm-caf-runbook"
    location= var.location
    env = var.env
    group = var.group
    project = var.project
    userDefinedString = each.key
    runbook= each.value
    resource_groups = local.resource_groups_all
}