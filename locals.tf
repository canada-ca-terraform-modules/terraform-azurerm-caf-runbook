locals {
  resource_group_name = strcontains(var.runbook.resource_group, "/resourceGroups/") ? regex("[^\\/]+$", var.runbook.resource_group) :  var.resource_groups[var.runbook.resource_group].name
}