module "entitlement" {
  source          = "GoogleCloudPlatform/pam/google"
  version         = "~> 2.0"
  organization_id = var.org_id
  parent_id       = var.project_id

  for_each = var.entitlements

  entitlement_id         = each.key
  parent_type            = "project"
  entitlement_requesters = each.value.requesters
  entitlement_approvers  = each.value.approvers
  role_bindings          = each.value.roles
}
