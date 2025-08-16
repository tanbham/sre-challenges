# GCP Privileged Access Manager (PAM) Entitlement Setup with Terraform

This repository provides Terraform code to configure **Privileged Access Manager (PAM)** entitlements in Google Cloud Platform (GCP).  
The configuration supports **project**, **folder**, and **organization** level entitlements with custom durations and roles.

---

## Overview

PAM in GCP helps control and manage **temporary elevated access** to GCP resources.  
This Terraform setup:
- Creates entitlements for different GCP services (Compute, GKE, BigQuery, etc.).
- Allows multiple requesters and approvers per entitlement.
- Supports both custom roles and predefined roles.
- Can apply entitlements at **project**, **folder**, or **organization** level.
- Uses a customized PAM module to extend the `max_request_duration` to **1 day**.

---

## Repository Structure

├── main.tf # Main Terraform configuration for entitlements  
├── variables.tf # Variable definitions  
├── terraform.tfvars # Example variable values (entitlements list)  
├── backend.tf # GCS backend configuration  
└── modules/  
└── custom-pam/ # Customized PAM Terraform module  


---

## Prerequisites

Before running Terraform:
1. **Install Terraform**
2. **Install gcloud CLI**
3. Ensure you have:
   - Owner/Editor permissions in the target project/folder/organization.
   - `roles/privilegedaccessmanager.admin` IAM role assigned.
4. Create a **GCS bucket** for Terraform state storage.

---

## Configuration

### Backend Setup (`backend.tf`)
Set your GCS bucket name and folder path:
```hcl
terraform {
  backend "gcs" {
    bucket = "your-bucket-name"
    prefix = "terraform/pam/state"
  }
}
