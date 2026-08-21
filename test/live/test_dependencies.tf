# test_dependencies.tf
# Self-contained dependency resources, owned entirely by this harness.
#
# terraform-azurerm-caf-runbook does not create its own Automation Account -
# azurerm_automation_runbook.automation_account_name is a plain string that
# must reference an Automation Account that already exists in the same
# resource group. A dedicated throwaway RG + Automation Account here needs
# only Contributor on the sandbox subscription and can never collide with or
# affect any production runbook.

resource "azurerm_resource_group" "live_test" {
  # PR-number suffix keeps two concurrently open PRs against this module from
  # colliding on the same sandbox resource group (or automation account).
  name     = "${var.env}-caf-runbook-live-test-${var.pr_number}-rg"
  location = var.location

  # pr-number tag: lets the nightly orphan sweeper find this RG by tag and
  # match it back to a PR, independent of naming convention.
  # repository tag: the sandbox subscription is shared across module repos,
  # so the sweeper must scope its `pr-number` matches to only this repo's
  # own PRs - otherwise a PR number collision across repos could
  # misclassify (or destroy) another repo's live resource group.
  tags = {
    "pr-number"  = var.pr_number
    "repository" = var.repository
  }
}

resource "azurerm_automation_account" "live_test" {
  name                = "${var.env}-caf-runbook-live-test-${var.pr_number}-aa"
  location            = azurerm_resource_group.live_test.location
  resource_group_name = azurerm_resource_group.live_test.name
  sku_name            = "Basic"

  tags = {
    "pr-number"  = var.pr_number
    "repository" = var.repository
  }
}

locals {
  # terraform-azurerm-caf-runbook's runbook.resource_group is a key into
  # var.resource_groups, resolved to {name} by the module's own locals.tf.
  resource_groups = {
    livetest = { name = azurerm_resource_group.live_test.name }
  }
}
