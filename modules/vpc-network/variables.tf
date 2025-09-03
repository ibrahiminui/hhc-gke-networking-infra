variable "name" {
  description = "Name of the resource. Provided by the client when the resource is created. The name must be 1-63 characters long, and comply with RFC1035. Specifically, the name must be 1-63 characters long and match the regular expression [a-z]([-a-z0-9]*[a-z0-9])? which means the first character must be a lowercase letter, and all following characters must be a dash, lowercase letter, or digit, except the last character, which cannot be a dash."
  type        = string
}

variable "project_id" {
  description = "The ID of the project in which the resource belongs."
  default     = "hhc-global-gke"
  type        = string
}


variable "subnets" {
  description = "The subnets that are to be created as part of the VPC."
  type = list(
    object({
      name : string
      secondary_ranges : map(string)
      subnet_flow_logs : bool
      subnet_iam_admins : optional(list(string), [])
      subnet_ip : string
      subnet_private_access : bool
      subnet_region : string

  }))
}



variable "firewall_rules" {
  description = "List of custom rule definitions (refer to variables file for syntax)."
  type        = any
}



