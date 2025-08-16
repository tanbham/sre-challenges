terraform {
  required_version = ">= 1.3"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 6.5, < 7"
    }
  }
  provider_meta "google" {
    module_name = "blueprints/terraform/terraform-google-pam/v2.1.0"
  }
}
