variable "name" {
  description = "Name of the resource. Provided by the client when the resource is created. The name must be 1-63 characters long, and comply with RFC1035. Specifically, the name must be 1-63 characters long and match the regular expression [a-z]([-a-z0-9]*[a-z0-9])? which means the first character must be a lowercase letter, and all following characters must be a dash, lowercase letter, or digit, except the last character, which cannot be a dash."
  type        = string
}

variable "project" {
  description = "The ID of the project in which the resource belongs."
  default     = "dbk-global-networking"
  type        = string
}

variable "global_addresses" {
  description = "Represents a Global Address resource."
  type        = list(any)

  default = []
}

variable "service_peerings" {
  description = "The service peerings that are to be created as part of the VPC."
  type        = list(any)

  default = []
}

variable "vpc_peerings" {
  description = "The vpc peerings that are to be created as part of the VPC."
  type        = list(any)

  default = []
}

variable "vpc_access_connectors" {
  description = "The vpc access connectors that are to be created as part of the VPC."
  type        = list(any)

  default = []
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
      subnet_purpose : string
      subnet_region : string
      subnet_role : string
      subnet_users : list(string)
  }))
}

variable "subnet_iam_admin_role" {
  description = "The id of the role to use for subnetwork IAM administrative permissions (ex. projects/{{project}}/roles/{{role_id}})"
  type        = string
  default     = ""
}

variable "firewall_rules" {
  description = "List of custom rule definitions (refer to variables file for syntax)."
  type        = any
}

variable "routes" {
  description = "List of custom route definitions"
  type        = list(any)

  default = []
}

variable "service_connection_policies" {
  description = "List of service connection policies"
  type        = list(any)

  default = []
}
