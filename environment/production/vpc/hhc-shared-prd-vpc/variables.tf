variable "vpc" {
  description = "The name of the Virtual Private Cloud (VPC) to configure."
  type        = string
}

variable "subnet_iam_admin_role" {
  description = "The id of the role to use for subnetwork IAM administrative permissions (ex. projects/{{project}}/roles/{{role_id}})"
  type        = string
  default     = ""
}
