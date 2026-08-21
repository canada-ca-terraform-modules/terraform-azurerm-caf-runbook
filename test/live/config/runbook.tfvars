# config/runbook.tfvars
# Tracked, ready-to-run fixture for the test/live harness - one representative
# real-usage instance, not a dormant "_" template.

env = "livetest"

runbook = {
  resource_group = "livetest"
  log_verbose    = true
  log_progress   = true
  description    = "terraform-azurerm-caf-runbook live-test harness"
  runbook_type   = "PowerShell"

  datafile = {
    file_path = "./runbook/runbook.ps1"
  }

  tags = {
    purpose = "module-live-test"
  }
}
