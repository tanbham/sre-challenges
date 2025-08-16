project_id = "enter-project-id"
org_id     = "enter-org-id"

entitlements = {
  "computeinstanceadmin-entitlement" = {
    requesters = ["group:gcp-your-grp@domain.com", "group:gcp-your-grp1@domain.com"]
    approvers  = ["user:tanmay.bhambure@domain.com"]
    roles = [
      {
        role = "roles/compute.instanceAdmin.v1"
      },
      {
        role = "roles/compute.admin"
      },
      {
        role = "roles/compute.viewer"
      }
    ]
  },
  "containeradmin-entitlement" = {
    requesters = ["group:gcp-your-grp@domain.com", "group:gcp-your-grp1@domain.com"]
    approvers  = ["user:tanmay.bhambure@domain.com"]
    roles = [
      {
        role = "roles/container.admin"
      },
      {
        role = "roles/container.clusterAdmin"
      },
      {
        role = "roles/gkehub.admin"
      }
    ]
  },
  "storageadmin-entitlement" = {
    requesters = ["group:gcp-your-grp@domain.com", "group:gcp-your-grp1@domain.com"]
    approvers  = ["user:tanmay.bhambure@domain.com"]
    roles = [
      {
        role = "roles/storage.admin"
      }
    ]
  },
  "sqladmin-entitlement" = {
    requesters = ["group:gcp-your-grp@domain.com", "group:gcp-your-grp1@domain.com"]
    approvers  = ["user:tanmay.bhambure@domain.com"]
    roles = [
      {
        role = "roles/cloudsql.admin"
      },
      {
        role = "roles/cloudsql.editor"
      }
    ]
  },

  "monitoringadmin-entitlement" = {
    requesters = ["group:gcp-your-grp@domain.com", "group:gcp-your-grp1@domain.com"]
    approvers  = ["user:tanmay.bhambure@domain.com"]
    roles = [
      {
        role = "roles/monitoring.admin"
      },
      {
        role = "roles/logging.viewer"
      }
    ]
  },
  "bigqueryadmin-entitlement" = {
    requesters = ["group:gcp-your-grp@domain.com", "group:gcp-your-grp1@domain.com"]
    approvers  = ["user:tanmay.bhambure@domain.com"]
    roles = [
      {
        role = "roles/bigquery.admin"
      }
    ]
  },
  "cloudrunfunctionadmin-entitlement" = {
    requesters = ["group:gcp-your-grp@domain.com", "group:gcp-your-grp1@domain.com"]
    approvers  = ["user:tanmay.bhambure@domain.com"]
    roles = [
      {
        role = "roles/cloudfunctions.admin"
      },
      {
        role = "roles/cloudfunctions.developer"
      },
      {
        role = "roles/cloudfunctions.invoker"
      }
    ]
  },
  "cloudscheduleradmin-entitlement" = {
    requesters = ["group:gcp-your-grp@domain.com", "group:gcp-your-grp1@domain.com"]
    approvers  = ["user:tanmay.bhambure@domain.com"]
    roles = [
      {
        role = "roles/cloudscheduler.admin"
      }
    ]
  },
  "datastore-entitlement" = {
    requesters = ["group:gcp-your-grp@domain.com", "group:gcp-your-grp1@domain.com"]
    approvers  = ["user:tanmay.bhambure@domain.com"]
    roles = [
      {
        role = "roles/datastore.indexAdmin"
      },
      {
        role = "roles/datastore.importExportAdmin"
      },
      {
        role = "roles/datastore.owner"
      },
      {
        role = "roles/datastore.user"
      }
    ]
  },
  "appengine-entitlement" = {
    requesters = ["group:gcp-your-grp@domain.com", "group:gcp-your-grp1@domain.com"]
    approvers  = ["user:tanmay.bhambure@domain.com"]
    roles = [
      {
        role = "roles/appengine.appAdmin"
      },
    ]
  },
  "bigtableadmin-entitlement" = {
    requesters = ["group:gcp-your-grp@domain.com", "group:gcp-your-grp1@domain.com"]
    approvers  = ["user:tanmay.bhambure@domain.com"]
    roles = [
      {
        role = "roles/bigtable.admin"
      }
    ]
  },
  "secretmanager-entitlement" = {
    requesters = ["group:gcp-your-grp@domain.com", "group:gcp-your-grp1@domain.com"]
    approvers  = ["user:tanmay.bhambure@domain.com"]
    roles = [
      {
        role = "roles/secretmanager.admin"
      }
    ]
  },
  "cloudsupporteditor-entitlement" = {
    requesters = ["group:gcp-your-grp@domain.com", "group:gcp-your-grp1@domain.com"]
    approvers  = ["user:tanmay.bhambure@domain.com"]
    roles = [
      {
        role = "roles/secretmanager.admin"
      }
    ]
  },
  "resourcemanageraccess-entitlement" = {
    requesters = ["group:gcp-your-grp@domain.com", "group:gcp-your-grp1@domain.com"]
    approvers  = ["user:tanmay.bhambure@domain.com"]
    roles = [
      {
        role = "roles/resourcemanager.projectIamAdmin"
      }
    ]
  },
  "pubsubadmin-entitlement" = {
    requesters = ["group:gcp-your-grp@domain.com", "group:gcp-your-grp1@domain.com"]
    approvers  = ["user:tanmay.bhambure@domain.com"]
    roles = [
      {
        role = "roles/pubsub.admin"
      }
    ]
  },
  "servicedirectoryandusage-entitlement" = {
    requesters = ["group:gcp-your-grp@domain.com", "group:gcp-your-grp1@domain.com"]
    approvers  = ["user:tanmay.bhambure@domain.com"]
    roles = [
      {
        role = "roles/servicedirectory.pscAuthorizedService"
      },
      {
        role = "roles/serviceusage.serviceUsageAdmin"
      }
    ]
  },
  "eventarcadmin-entitlement" = {
    requesters = ["group:gcp-your-grp@domain.com", "group:gcp-your-grp1@domain.com"]
    approvers  = ["user:tanmay.bhambure@domain.com"]
    roles = [
      {
        role = "roles/run.admin"
      },
      {
        role = "roles/eventarc.admin"
      }
    ]
  },
  "computenetworkadmin-entitlement" = {
    requesters = ["group:gcp-your-grp@domain.com", "group:gcp-your-grp1@domain.com"]
    approvers  = ["user:tanmay.bhambure@domain.com"]
    roles = [
      {
        role = "roles/compute.loadBalancerAdmin"
      },
      {
        role = "roles/compute.networkAdmin"
      },
      {
        role = "roles/compute.networkUser"
      }
    ]
  },
  "securtiycompliance-entitlement" = {
    requesters = ["group:gcp-your-grp@domain.com", "group:gcp-your-grp1@domain.com"]
    approvers  = ["user:tanmay.bhambure@domain.com"]
    roles = [
      {
        role = "roles/chronicle.globalDataAccess"
      },
      {
        role = "roles/meshconfig.admin"
      },
      {
        role = "roles/privilegedaccessmanager.admin"
      },
      {
        role = "roles/recommender.firestoredatabasereliabilityAdmin"
      }
    ]
  },
  "iapaccess-entitlement" = {
    requesters = ["group:gcp-your-grp@domain.com", "group:gcp-your-grp1@domain.com"]
    approvers  = ["user:tanmay.bhambure@domain.com"]
    roles = [
      {
        role = "roles/iap.admin"
      },
      {
        role = "roles/iap.tunnelDestGroupEditor"
      },
      {
        role = "roles/iap.tunnelResourceAccessor"
      }
    ]
  },
  "osconfigadmin-entitlement" = {
    requesters = ["group:gcp-your-grp@domain.com", "group:gcp-your-grp1@domain.com"]
    approvers  = ["user:tanmay.bhambure@domain.com"]
    roles = [
      {
        role = "roles/osconfig.guestPolicyAdmin"
      },
      {
        role = "roles/osconfig.guestPolicyEditor"
      },
      {
        role = "roles/osconfig.guestPolicyViewer"
      }
    ]
  },
  "iam-serviceaccount-entitlement" = {
    requesters = ["group:gcp-your-grp@domain.com", "group:gcp-your-grp1@domain.com"]
    approvers  = ["user:tanmay.bhambure@domain.com"]
    roles = [
      {
        role = "roles/iam.roleAdmin"
      },
      {
        role = "roles/iam.serviceAccountAdmin"
      },
      {
        role = "roles/iam.serviceAccountKeyAdmin"
      },
      {
        role = "roles/iam.serviceAccountOpenIdTokenCreator"
      },
      {
        role = "roles/iam.serviceAccountTokenCreator"
      },
      {
        role = "roles/iam.serviceAccountUser"
      }
    ]
  },
  "computeosadminlogin-entitlement" = {
    requesters = ["group:gcp-your-grp@domain.com", "group:gcp-your-grp1@domain.com"]
    approvers  = ["user:tanmay.bhambure@domain.com"]
    roles = [
      {
        role = "roles/compute.osAdminLogin"
      },
      {
        role = "roles/compute.osLogin"
      }
    ]
  }
}
