## Check service if active
```bash
#!/bin/bash

service=$1
output=$(systemctl is-active $service)

if [[ $output == "active" ]];then
  echo "Service $service is active"
else
  echo "Service $service is inactive"
fi 
````
