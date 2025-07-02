variable "project_id" {
  description = "The GCP project ID where PAM entitlement is applied"
  type        = string
}

variable "org_id" {
  description = "The GCP organization ID"
  type        = string
}

variable "entitlements" {
  type = map(object({
    requesters = list(string)
    approvers  = list(string)
    roles = list(object({
      role                 = string
      condition_expression = optional(string)
    }))
  }))
}
