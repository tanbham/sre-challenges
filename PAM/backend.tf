terraform {
  backend "gcs" {
    bucket = "bkt-common-srv-terraform-app-infra-state-as1"
    prefix = "terraform/mc-nonprod/mc-std-svc-uat/pam/state"
  }
}
