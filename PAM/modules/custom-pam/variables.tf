variable "parent_id" {
  type        = string
  description = "The ID of organization, folder, or project to create the entitlement in"
}

variable "parent_type" {
  type        = string
  description = "Parent type. Can be organization, folder, or project to create the entitlement in"
}

variable "organization_id" {
  description = "Organization id"
  type        = string
}

variable "entitlement_requesters" {
  type        = list(string)
  description = "Required List of users, groups, service accounts or domains who can request grants using this entitlement. Can be one or more of Google Account email, Google Group, Service account or Google Workspace domain"
}

variable "entitlement_approvers" {
  type        = list(string)
  description = "List of users, groups or domain who can approve this entitlement. Can be one or more of Google Account email, Google Group or Google Workspace domain. Required if auto_approve_entitlement is false (default)"
  default     = []
}

variable "entitlement_approval_notification_recipients" {
  type        = list(string)
  description = "List of email addresses to be notified when a request is granted"
  default     = []
}

variable "entitlement_availability_notification_recipients" {
  type        = list(string)
  description = "List of email addresses to be notified when a entitlement is created. These email addresses will receive an email about availability of the entitlement"
  default     = []
}

variable "role_bindings" {
  type = list(object({
    role                 = string
    condition_expression = optional(string)
  }))
  description = "The maximum amount of time for which access would be granted for a request. A requester can choose to ask for access for less than this duration but never more"
}

variable "requester_justification" {
  type        = bool
  description = "If the requester is required to provide a justification"
  default     = true
}

variable "require_approver_justification" {
  type        = bool
  description = "Do the approvers need to provide a justification for their actions"
  default     = true
}

variable "max_request_duration_hours" {
  type        = number
  description = "The maximum amount of time for which access would be granted for a request. A requester can choose to ask for access for less than this duration but never more"
  default     = 1
}

variable "location" {
  type        = string
  description = "The region of the Entitlement resource"
  default     = "global"
}

variable "entitlement_id" {
  type        = string
  description = "The ID to use for this Entitlement. This will become the last part of the resource name. This value should be 4-63 characters. This value should be unique among all other Entitlements under the specified parent"
  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{3,62}$", var.entitlement_id))
    error_message = "ERROR: entitlement_id must contain only Letters(lowercase), number, hyphen and should be 4-63 characters"
  }
}

variable "grant_service_agent_permissions" {
  type        = bool
  description = "Whether or not to grant roles/privilegedaccessmanager.serviceAgent role to PAM service account"
  default     = false
}

variable "auto_approve_entitlement" {
  type        = bool
  description = "Whether or not to auto approve the entitlement. If true, entitlement will be auto approved without any manual approval"
  default     = false
}
