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

## Using awk utility to extract details from user_activity.log file
```bash
#!/bin/bash

# NF is the number of fields in the current record (line).
# $(NF) represents the value of the last field in the current line.

# Syntax : awk '{print $1}' file.txt, -F is not specified then default delimter is space, NF mean each filed in input file separated by delimter
echo "Extracting unique Usernames"
awk '{
  for(i=1; i<=NF; i++){
    if($i ~ /^user/ ){
      print $i
    }
  }
}' user_activity.log

# 192.162.1.0  here we can directly use . so we use \. , [0-9]+ Matches one or more digits (0-9)
echo "Extracting unique IP Address"
awk '{
  for(i=1; i<=NF; i++){
    if($i ~ /^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+/){
      print $i
    }
  }
}' user_activity.log

echo "Extracting the status code 403 and 404, i.e failed and status code 200, i.e success"
awk '
BEGIN{
  print "Inside begin"
  failedrequest = 0
  successrequest = 0
}
{
  if($(NF) == "403" || $(NF) == "404"){
    failedrequest++
  }
  if($(NF) == "200"){
    successrequest++
  }
}
END{
  print "Failed request count is:" failedrequest
  print "Success request count is:" successrequest
}' user_activity.log
```
