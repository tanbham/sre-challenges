project_id = "prj-uat-svc-mc-std6b"
org_id     = "775945612141"

entitlements = {
  "entitlement-1" = {
    requesters = ["user:faisal.Makki@domain.com", "group:gcp-mc-cld-devops@domain.com"]
    approvers  = ["user:tanmay.bhambure@nw18.com"]
    roles = [
      {
        role = "roles/storage.admin"
      },
      {
        role = "roles/compute.admin"
      }
    ]
  },
   "entitlement-2" = {
     requesters = ["user:faisal.Makki@domain.com"]
     approvers  = ["user:tanmay.bhambure@domain.com"]
     roles = [
       {
         role = "roles/bigquery.admin"
       }
     ]
   }
}
