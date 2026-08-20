runbooks = {

  runbook1 = {
    resource_group = "Project"
    log_verbose    = false
    log_progress   = false
    description    = "Description of Runbook"
    runbook_type   = "PowerShell"

    # Optional: Override the auto-generated runbook name (default: {env4}-{userDefinedString7})
    # name = "existing-runbook-name"

    # Phase 1: ignored by pre-5.0.1 module (no such argument existed)
    # Phase 2: wired through by v1.0.0 -> new in azurerm >= 4.x
    # runtime_environment_name = "existing-runtime-environment"

    # Phase 1: ignored by pre-5.0.1 module (no such argument existed)
    # Phase 2: wired through by v1.0.0 -> Possible values are 0 (None), 9 (Basic), 15 (Detailed)
    # log_activity_trace_level = 0

    # Optional: per-runbook tags, merged over (and taking priority over) var.tags
    # tags = {
    #   costCenter = "1234"
    # }

    datafile = {
      file_path = "./runbook/runbook.ps1"
    }
    # publish_content_link = {
    #     uri     = "https://example.com/runbook.ps1"
    #     version = "1.0"
    #     # hash is Optional - omit entirely if not needed
    #     hash = {
    #         algorithm = "SHA256"
    #         value     = "abc123hashvalue"
    # }
    # }

    # draft ={
    #     edit_mode_enabled = true
    #     output_types      = ["String", "Error"]
    #     parameters ={
    #       param1 = {
    #         key       = "param1"
    #         type      = "String"
    #         mandatory = true
    #         position  = 1
    #       }
    #       param2 = {
    #         key       = "param2"
    #         type      = "Int"
    #         mandatory = false
    #         position  = 2
    #       }
    #      }
    #    content_link ={
    #       uri     = "https://example.com/runbook.ps1"
    #       version = "1.0"
    #       # hash is Optional - omit entirely if not needed
    #       hash = {
    #         algorithm = "SHA256"
    #         value     = "abc123hashvalue"
    #        }
    #     }
    # }


  }
}