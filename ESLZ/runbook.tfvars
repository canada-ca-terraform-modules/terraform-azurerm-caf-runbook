runbooks = {

    runbook1={
        resource_group          = "Project"
        log_verbose             = false
        log_progress            = false
        description             = "Description of Runbook"
        runbook_type            = "PowerShell"

        datafile={
            file_path ="./runbook/runbook.ps1"
        }
        # publish_content_link = {
        #     uri     = "https://example.com/runbook.ps1"
        #     version = "1.0"
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
        #       hash = {
        #         algorithm = "SHA256"
        #         value     = "abc123hashvalue"
        #        }
        #     }
        # }


    }
}