variable "vpc" {
  description = "The name of the Virtual Private Cloud (VPC) to configure."
  default     = "hhc-shared-prd-vpc"
  type        = string
}


variable "project_id" {
  description = "The ID of the project in which the resource belongs."
  default     = "hhc-global-gke"
  type        = string
}