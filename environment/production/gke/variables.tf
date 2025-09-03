variable "project" {
  description = "The GCP project you want to manage"
  type        = string
}

variable "environment" {
  description = "Which environment is being configured."
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

variable "dns_records" {
  type = list(object({
    name    = string
    type    = string
    ttl     = number
    records = list(string)
  }))
  description = "List of DNS record objects to manage, in the standard terraform dns structure."
  default     = []
}

##GKE log filters
variable "log_sink_bucket_filter" {
  description = "	The filter to be applied when exporting logs to Logging Bucket.."
  type        = string
  default     = "resource.type=k8s_container NOT resource.labels.namespace_name=kube-system NOT logName:(clouderrorreporting)"
}

variable "log_sink_pubsub_filter" {
  description = "	The filter to be applied when exporting logs to Splunk.."
  type        = string
  default     = "resource.type=k8s_container NOT resource.labels.namespace_name=kube-system NOT logName:(clouderrorreporting) NOT textPayload:(DEBUG) NOT severity=(DEBUG)"
}

variable "log_sink_shared_observ_filter" {
  description = "	The filter to be applied when exporting logs from shared-prd to Observ"
  type        = string
  default     = ""
}

variable "service_mappings" {
  description = "CNAME mappings to services"
  default     = {}
  type        = map(any)
}

variable "audit_based_log_metric" {
  description = "audit based log metrics"
  type        = map(any)
}

#variables used in secrets.tf for secrets
variable "secrets" {
  description = "List of secret names"
  type        = map(any)
}

# GCS buckets
variable "buckets_info" {
  description = "Map of storage name and location"
  default     = {}
}


variable "log_based_metrics" {
  description = "logbased metric to support counter, with label(s), DISTRIBUTION metrics"
  type        = any
}
