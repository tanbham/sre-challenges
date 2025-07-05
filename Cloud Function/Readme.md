# 🧹 GCP Cloud SQL On-Demand Backup Cleanup Function

This project provides a **Google Cloud Function (Gen 2)** that automatically deletes **on-demand Cloud SQL backups** older than a configured age. It is scheduled using **Cloud Scheduler** and supports multiple Cloud SQL instances via a simple `instances.txt` file.

---
## 📌 Features

- Reads list of Cloud SQL instances from a file.
- Uses Google Cloud SQL Admin API to:
  - List backup runs
  - Identify backups older than 30 days (customizable)
  - Delete old **ON_DEMAND** backups
- Deployed as a Gen2 Cloud Function with Python 3.10
- Triggered via HTTP using **Cloud Scheduler**
- Lightweight, serverless, cost-efficient

---
## 🗂️ Project Structure  
```
cleanup/db_backup_cleanup/
│
├── main.py # Cloud Function entrypoint
├── requirements.txt # Python dependencies
├── instances.txt # List of Cloud SQL instance names (one per line)
└── README.md # You're reading it
```
---
## Deploy Cloud Function
```
gcloud functions deploy ${functionName} \
--gen2 --runtime python310 --entry-point=${entryPoint}\
--source=. \
--trigger-http --project={$project} --region=asia-south1 \
--service-account={$serviceAccount}
```
IAM roles binded to service account: Cloud SQL Admin, Cloud SQL Client, Cloud SQL Instance User
