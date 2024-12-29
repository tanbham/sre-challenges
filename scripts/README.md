## Check service if active
```bash
#!/bin/bash

echo "Enter the service name"
read service

output=$(systemctl is-active $service)

if [[ $output == "active" ]];then
  echo "Service $service is active"
else
  echo "Service $service is inactive, starting the service"
  systemctl start $service
fi 
````

## Read json payload and output bucket details in python
```bash
import json
from datetime import datetime

def print_bucket_details(inputdata):
    for i in range(len(inputdata["buckets"])):
        print(f"Bucket name: {inputdata['buckets'][i]['name']}")
        print(f"Region: {inputdata['buckets'][i]['region']}")
        print(f"Size: {inputdata['buckets'][i]['sizeGB']}")
        print(f"Versioning: {inputdata['buckets'][i]['versioning']}")
        print(f"Policy type: ")
        for p in inputdata["buckets"][i]["policies"]:
            print(f"{p['type']}")
        print("-----------------------------------------------------")

def print_bucket_greaterthan80gb(inputdata):
    current_date = datetime.now().date()
    for i in range(len(inputdata["buckets"])):
        bucket_size = inputdata["buckets"][i]["sizeGB"]
        bucket_date = inputdata["buckets"][i]["createdOn"]
        bucket_date_object = datetime.strptime(bucket_date, "%Y-%m-%d").date()
        diff_date = (current_date - bucket_date_object).days

        if(bucket_size > 80 and diff_date > 20):
            print(f"Bucket name: {inputdata['buckets'][i]['name']} is having a size greater than 80gb and older than 20 days")


#file details
filepath = "buckets.json"

print("Testing the print function")
print("Datetime both using datetime.now() :", datetime.now())
print(f"Datetime both using datetime.now() : {datetime.now()}")
print(f"Date only using datetime.now().date() : {datetime.now().date()}")

#parse the file using json module
with open(filepath, "r") as inputfile:
        inputdata = json.load(inputfile)

#call the  function
#print_bucket_details(inputdata)
print_bucket_greaterthan80gb(inputdata)
```
