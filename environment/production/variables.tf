variable "project" {
  description = "Projects list to add the IAM policies/bindings"
  default     = ""
  type        = string
}

variable "project_apis" {
  description = "The list of apis to activate within the project"
  type        = list(string)
  default     = []
}

variable "project_bindings" {
  description = "Map of role (key) and list of members (value) to add the IAM policies/bindings"
  type        = map(list(string))
  default     = {}
}

variable "project_conditional_bindings" {
  description = "List of maps of role and respective conditions, and the members to add the IAM policies/bindings"
  type = list(object({
    role        = string
    title       = string
    description = string
    expression  = string
    members     = list(string)
  }))
  default = []
}

variable "dns" {
  description = "The DNS zones and records that are needed. The keys are the names of the DNS zones."
  type        = map(any)
}

variable "custom_roles" {
  description = "List of maps of custom role definitions."
  type        = any
  default     = {}
}


variable "int_dns_recordsets" {
  type = list(object({
    name    = string
    type    = string
    ttl     = number
    records = list(string)
  }))
  description = "List of DNS record objects to manage, in the standard terraform dns structure."
  default     = []
}

variable "subnetworks_zscaler_prod" {
  description = "Map of region (key) to zScaler prod subnetwork information"
  type = map(object({
    name    = string
    project = string
  }))
}

variable "subnetworks_zscaler_nonprod" {
  description = "Map of region (key) to zScaler nonprod subnetwork information"
  type = map(object({
    name    = string
    project = string
  }))
}
variable "entitlements" {
  description = "values for the entitlements to be created in the project"
  type = list(object({
    name_suffix          = string
    max_request_duration = string
    eligible_users       = list(string)
    roles = list(object({
      role                 = string
      condition_expression = optional(string)
    }))
    admin_email_recipients     = optional(list(string))
    approval_workflow_required = optional(bool, true)
    approval_workflow = optional(object({
      require_approver_justification = bool
      approvers                      = string
      approver_email_recipients      = list(string)
    }))
  }))
}
