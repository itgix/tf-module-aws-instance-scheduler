variable "start_time" {
  type        = string
  description = "Cronjob time for the instances start"
}

variable "stop_time" {
  type        = string
  description = "Cronjob time for the instances stop"
}

variable "timezone" {
  type        = string
  description = "Time zone"
}

variable "name_suffix" {
  description = "Optional suffix appended to every resource name. Required when the module is deployed more than once in the same account, because the IAM role and policy names are account-global. Empty keeps the original names."
  type        = string
  default     = ""
}
