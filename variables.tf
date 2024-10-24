variable "location" {
  description = "Azure location for the VM"
  type = string
  default = "canadacentral"
}

variable "tags" {
  description = "Tags that will be applied to every associated VM resource"
  type = map(string)
  default = {}
}

variable "env" {
  description = "(Required) 4 character string defining the environment name prefix for the VM"
  type = string
  default =  "dev"
}

variable "group" {
  description = "(Required) Character string defining the group for the target subscription"
  type = string
  default = "test"
}

variable "project" {
  description = "(Required) Character string defining the project for the target subscription"
  type = string
  default = "test"
}

variable "userDefinedString" {
  description = "(Required) User defined portion value for the name of the VM."
  type = string
  default= "test"
}


variable "automation_account_name" {
  description = "(Required) Name of automation account."
  type        = string
  default     = null
}

variable "job_schedules" {
  description = "Map of job schedules with their parameters and settings."
  type = map(object({
    parameters = map(any)  # Allow `parameters` to hold complex nested structures
    run_on     = string
  }))
  default = {}
}

variable "runbook" {
  description = "(Required) Runbook configuration."
  type        = any
  default     = null
}

variable "resource_groups" {
  description = "(Required) Resource group object for the VM"
  type = any
  default = {}
}





