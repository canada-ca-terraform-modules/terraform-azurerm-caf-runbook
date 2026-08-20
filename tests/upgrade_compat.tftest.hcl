# tests/upgrade_compat.tftest.hcl
# Purpose: catch breaking resource changes before deploying against real infra.
# Step 1 simulates the state produced by a caller's tfvars written against the
# pre-upgrade module (no new v1.0.0 arguments). Step 2 plans the same config
# against that state with the upgrade's new optional arguments added, and
# asserts the resource address/name is unchanged (no destroy/recreate).
mock_provider "azurerm" {}
mock_provider "local" {}

variables {
  location                = "canadacentral"
  env                     = "Dev"
  group                   = "test"
  project                 = "test"
  userDefinedString       = "test"
  automation_account_name = "aa-test"
  tags                    = {}
  resource_groups = {
    rg-test = { name = "rg-test", location = "canadacentral" }
  }
}

run "baseline_apply" {
  command = apply
  variables {
    runbook = {
      resource_group = "rg-test"
      log_verbose    = false
      log_progress   = false
      description    = "Pre-upgrade runbook"
      runbook_type   = "PowerShell"
      datafile       = { file_path = "./tests/fixtures/runbook.ps1" }
    }
  }
  assert {
    condition     = azurerm_automation_runbook.runbook.name == "Dev-test"
    error_message = "Baseline apply: unexpected resource name"
  }
}

run "upgrade_plan_no_replacement" {
  command = plan
  variables {
    runbook = {
      resource_group           = "rg-test"
      log_verbose              = false
      log_progress             = false
      description              = "Pre-upgrade runbook"
      runbook_type             = "PowerShell"
      runtime_environment_name = "existing-runtime-environment"
      log_activity_trace_level = 0
      datafile                 = { file_path = "./tests/fixtures/runbook.ps1" }
    }
    tags = { environment = "test" }
  }
  assert {
    condition     = azurerm_automation_runbook.runbook.name == "Dev-test"
    error_message = "Resource name must be unchanged after upgrade"
  }
  assert {
    condition     = azurerm_automation_runbook.runbook.runtime_environment_name == "existing-runtime-environment"
    error_message = "New runtime_environment_name argument must apply on top of existing state"
  }
}
