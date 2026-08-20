# tests/runbook.tftest.hcl
mock_provider "azurerm" {}
mock_provider "local" {}

variables {
  location                = "canadacentral"
  env                     = "Dev"
  group                   = "test"
  project                 = "test"
  userDefinedString       = "test"
  automation_account_name = "aa-test"
  tags                    = { environment = "test" }
  resource_groups = {
    rg-test = { name = "rg-test", location = "canadacentral" }
  }
}

run "naming_convention" {
  command = plan
  variables {
    runbook = {
      resource_group = "rg-test"
      log_verbose    = false
      log_progress   = false
      description    = "Test runbook"
      runbook_type   = "PowerShell"
      datafile       = { file_path = "./tests/fixtures/runbook.ps1" }
    }
  }
  assert {
    condition     = azurerm_automation_runbook.runbook.name == "Dev-test"
    error_message = "Name must be built from {env4}-{userDefinedString7} when no override is supplied"
  }
  assert {
    condition     = azurerm_automation_runbook.runbook.resource_group_name == "rg-test"
    error_message = "resource_group_name must resolve to the named resource group's name"
  }
}

run "default_values" {
  command = plan
  variables {
    runbook = {
      resource_group = "rg-test"
      runbook_type   = "PowerShell"
      datafile       = { file_path = "./tests/fixtures/runbook.ps1" }
    }
  }
  assert {
    condition     = azurerm_automation_runbook.runbook.log_verbose == false
    error_message = "log_verbose must default to false when omitted"
  }
  assert {
    condition     = azurerm_automation_runbook.runbook.log_progress == false
    error_message = "log_progress must default to false when omitted"
  }
  assert {
    condition     = azurerm_automation_runbook.runbook.description == null
    error_message = "description must be null when omitted, not error"
  }
}

run "name_override" {
  command = plan
  variables {
    runbook = {
      name           = "existing-runbook-name"
      resource_group = "rg-test"
      runbook_type   = "PowerShell"
      datafile       = { file_path = "./tests/fixtures/runbook.ps1" }
    }
  }
  assert {
    condition     = azurerm_automation_runbook.runbook.name == "existing-runbook-name"
    error_message = "Explicit runbook.name override must take priority over the generated name"
  }
}

run "tags_applied" {
  command = plan
  variables {
    runbook = {
      resource_group = "rg-test"
      runbook_type   = "PowerShell"
      datafile       = { file_path = "./tests/fixtures/runbook.ps1" }
    }
  }
  assert {
    condition     = azurerm_automation_runbook.runbook.tags["environment"] == "test"
    error_message = "tags variable must be applied to the runbook resource"
  }
}

run "custom_tags_merged" {
  command = plan
  variables {
    runbook = {
      resource_group = "rg-test"
      runbook_type   = "PowerShell"
      datafile       = { file_path = "./tests/fixtures/runbook.ps1" }
      tags           = { costCenter = "1234" }
    }
  }
  assert {
    condition     = azurerm_automation_runbook.runbook.tags["environment"] == "test"
    error_message = "var.tags must still be present when runbook.tags is also supplied"
  }
  assert {
    condition     = azurerm_automation_runbook.runbook.tags["costCenter"] == "1234"
    error_message = "runbook.tags must be merged over var.tags"
  }
}

run "runtime_environment_name" {
  command = plan
  variables {
    runbook = {
      resource_group           = "rg-test"
      runbook_type             = "PowerShell"
      runtime_environment_name = "existing-runtime-environment"
      datafile                 = { file_path = "./tests/fixtures/runbook.ps1" }
    }
  }
  assert {
    condition     = azurerm_automation_runbook.runbook.runtime_environment_name == "existing-runtime-environment"
    error_message = "runtime_environment_name must be passed through when supplied"
  }
}

run "log_activity_trace_level" {
  command = plan
  variables {
    runbook = {
      resource_group           = "rg-test"
      runbook_type             = "PowerShell"
      log_activity_trace_level = 9
      datafile                 = { file_path = "./tests/fixtures/runbook.ps1" }
    }
  }
  assert {
    condition     = azurerm_automation_runbook.runbook.log_activity_trace_level == 9
    error_message = "log_activity_trace_level must be passed through when supplied"
  }
}

run "publish_content_link_without_hash" {
  command = plan
  variables {
    runbook = {
      resource_group = "rg-test"
      runbook_type   = "PowerShell"
      publish_content_link = {
        uri     = "https://example.com/runbook.ps1"
        version = "1.0"
      }
    }
  }
  assert {
    condition     = azurerm_automation_runbook.runbook.publish_content_link[0].uri == "https://example.com/runbook.ps1"
    error_message = "publish_content_link must render without a hash block"
  }
}

run "publish_content_link_with_hash" {
  command = plan
  variables {
    runbook = {
      resource_group = "rg-test"
      runbook_type   = "PowerShell"
      publish_content_link = {
        uri     = "https://example.com/runbook.ps1"
        version = "1.0"
        hash = {
          algorithm = "SHA256"
          value     = "abc123hashvalue"
        }
      }
    }
  }
  assert {
    condition     = tolist(azurerm_automation_runbook.runbook.publish_content_link[0].hash)[0].algorithm == "SHA256"
    error_message = "publish_content_link.hash must render when supplied"
  }
}

run "draft_without_hash" {
  command = plan
  variables {
    runbook = {
      resource_group = "rg-test"
      runbook_type   = "PowerShell"
      draft = {
        edit_mode_enabled = true
        output_types      = ["String", "Error"]
        content_link = {
          uri     = "https://example.com/runbook.ps1"
          version = "1.0"
        }
      }
    }
  }
  assert {
    condition     = azurerm_automation_runbook.runbook.draft[0].content_link[0].uri == "https://example.com/runbook.ps1"
    error_message = "draft.content_link must render without a hash block"
  }
}

run "draft_with_hash" {
  command = plan
  variables {
    runbook = {
      resource_group = "rg-test"
      runbook_type   = "PowerShell"
      draft = {
        edit_mode_enabled = true
        output_types      = ["String", "Error"]
        content_link = {
          uri     = "https://example.com/runbook.ps1"
          version = "1.0"
          hash = {
            algorithm = "SHA256"
            value     = "abc123hashvalue"
          }
        }
        parameters = {
          param1 = {
            key       = "param1"
            type      = "String"
            mandatory = true
            position  = 1
          }
        }
      }
    }
  }
  assert {
    condition     = tolist(azurerm_automation_runbook.runbook.draft[0].content_link[0].hash)[0].algorithm == "SHA256"
    error_message = "draft.content_link.hash must render when supplied"
  }
  assert {
    condition     = length(azurerm_automation_runbook.runbook.draft[0].parameters) == 1
    error_message = "draft.parameters must render one block per map entry"
  }
}

run "job_schedule" {
  command = plan
  variables {
    runbook = {
      resource_group = "rg-test"
      runbook_type   = "PowerShell"
      datafile       = { file_path = "./tests/fixtures/runbook.ps1" }
    }
    job_schedules = {
      daily = {
        parameters = { param1 = "value1", param2 = 2 }
        run_on     = "hybrid-worker-group"
      }
    }
  }
  assert {
    condition     = azurerm_automation_job_schedule.job_schedule["daily"].schedule_name == "daily"
    error_message = "job_schedule schedule_name must match the job_schedules map key"
  }
  assert {
    condition     = azurerm_automation_job_schedule.job_schedule["daily"].runbook_name == "Dev-test"
    error_message = "job_schedule runbook_name must match the runbook resource's name"
  }
  assert {
    condition     = azurerm_automation_job_schedule.job_schedule["daily"].run_on == "hybrid-worker-group"
    error_message = "job_schedule run_on must be passed through when supplied"
  }
}

run "job_schedule_default_run_on" {
  command = plan
  variables {
    runbook = {
      resource_group = "rg-test"
      runbook_type   = "PowerShell"
      datafile       = { file_path = "./tests/fixtures/runbook.ps1" }
    }
    job_schedules = {
      monthly = {
        parameters = { param1 = "value1" }
        run_on     = null
      }
    }
  }
  assert {
    condition     = azurerm_automation_job_schedule.job_schedule["monthly"].run_on == null
    error_message = "job_schedule run_on must be null when omitted"
  }
}
