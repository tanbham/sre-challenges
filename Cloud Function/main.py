import os
from datetime import datetime, timedelta, timezone
from googleapiclient import discovery

##entrypoint for the Cloud Function
def db_backup_cleanup(request):
    try:
        #PROJECT_ID is set to the environment variable or defaults to "prj-uat-svc-mc-std6b"
        project_id = os.environ.get("PROJECT_ID", "prj-prod-svc-mc-std77")
        results = {}
        
        # Define cutoff
        cutoff_date = datetime.now(timezone.utc) - timedelta(days=180)

        #Open the file "instances.txt" to read instance IDs
        with open("instances.txt", "r") as f:
            instance_ids = [line.strip() for line in f if line.strip()]

        service = discovery.build("sqladmin", "v1")

        for instance_id in instance_ids:
            old_on_demand_backups = []
            deleted_backups = []

            #build the sqladmin object to list the backups of the instance ids
            request_backups = service.backupRuns().list(project=project_id, instance=instance_id)
            
            #while loop is used for pagination bcs the request_backups.execute() only captures latest 20 backups
            while request_backups is not None:
                response = request_backups.execute()
                for backup in response.get("items", []):
                    if backup.get("type") == "ON_DEMAND":
                        backup_time = datetime.fromisoformat(backup["startTime"].replace("Z", "+00:00"))
                        if backup_time < cutoff_date:
                            old_on_demand_backups.append((backup["id"], backup["startTime"]))
                            #logic to delete the backup
                            backup_id = backup["id"]
                            service.backupRuns().delete(project=project_id, instance=instance_id, id=backup_id).execute()
                            deleted_backups.append((backup["id"], backup["startTime"]))
                request_backups = service.backupRuns().list_next(previous_request=request_backups, previous_response=response)

            print(f"Old On-Demand Backup for instance {instance_id}: {old_on_demand_backups}")
            print(f"Deleted backups for instance {instance_id}: {deleted_backups}")            
            results[instance_id] = old_on_demand_backups
        return results, 200

    except Exception as e:
        return {"error": str(e)}, 500
