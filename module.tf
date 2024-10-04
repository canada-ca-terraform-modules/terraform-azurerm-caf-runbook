data "local_file" "runbook_script" {
  count    = try(var.runbook.datafile, null) == null ? 0 : 1
  filename = var.runbook.datafile.file_path
}

resource "azurerm_automation_runbook" "runbook" {
  name                    = local.runbook-name
  location                = var.location
  resource_group_name     = local.resource_group_name
  automation_account_name = var.runbook.automation_account_name
  log_verbose             = try(var.runbook.log_verbose, false)
  log_progress            = try(var.runbook.log_progress, false)
  description             = var.runbook.description
  runbook_type            = var.runbook.runbook_type

  content = try(data.local_file.runbook_script[0].content, null)  

  dynamic "publish_content_link" {
    for_each = try(var.runbook.publish_content_link, null) != null ? [1] : []
    content {
      uri     = var.runbook.publish_content_link.uri
      version = try(var.runbook.publish_content_link.version, null)
      hash {
        algorithm = var.runbook.publish_content_link.hash.algorithm
        value     = var.runbook.publish_content_link.hash.value
      }
    }
  }

  dynamic "draft" {
    for_each = try(var.runbook.draft, null) != null ? [1] : []
    content {
      edit_mode_enabled = try(var.runbook.draft.edit_mode_enabled, false)
      content_link {
          uri     = var.runbook.draft.content_link.uri
          version = try(var.runbook.draft.content_link.version, null)
        dynamic "hash" {
          for_each = try(var.runbook.draft.hash, [])
          content {
            algorithm = var.runbook.draft.content_link.hash.algorithm
            value     = var.runbook.draft.content_link.hash.value
          }
        }
      }
      output_types      = try(var.runbook.draft.output_types, "")

      # Nested dynamic block for parameters list
      dynamic "parameters" {
        for_each = try(var.runbook.draft.parameters, {})  # Iterate through the list of parameters
        content {
          key       = try(parameters.value.key, null)      # Use the dynamic value for the parameter key
          type      = try(parameters.value.type, null)     # Parameter type (string, int, etc.)
          mandatory = try(parameters.value.mandatory, false)
          position  = try(parameters.value.position, 0)  # Position of the parameter
        }
      }
    }
  }

  dynamic "job_schedule" {
    for_each = try(var.runbook.job_schedules,{})
    content {
      schedule_name = job_schedule.key
      parameters    = try(job_schedule.parameters, null)
      run_on        = try(job_schedule.run_on, null)
    }
  }
}
