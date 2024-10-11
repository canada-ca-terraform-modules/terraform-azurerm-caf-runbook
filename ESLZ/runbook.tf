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
    automation_account_name = "example"
    # job_schedules ={   # Optional schedule for runbook and the schedules need to be defined in automation account
    #   daily={
    #     parameters    = {param1: "value1", param2: 2} #optional parameters for runbook
    #     run_on = null
    #   }
    #   monthly={
    #     parameters    = {param1: "value1", param2: 2}
    #     run_on = null
    #   }
    # }
    userDefinedString = each.key
    runbook= each.value
    resource_groups = local.resource_groups_all
}