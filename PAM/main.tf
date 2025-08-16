module "entitlement" {
#google module for PAM entitlement has hardcode value of max_request_duration as 1hr
#downloaded the module locally and modified the max_request_duration to 1 day
# source          = "GoogleCloudPlatform/pam/google"
# version         = "~> 2.0"
  source = "../modules/custom-pam"
  organization_id = var.org_id
  parent_id       = var.project_id

  for_each = var.entitlements

  entitlement_id         = each.key
  #change parent_type to folder/organization based on requirement
  parent_type            = "project"     
  entitlement_requesters = each.value.requesters
  entitlement_approvers  = each.value.approvers
  role_bindings          = each.value.roles
}
