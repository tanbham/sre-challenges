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
