# Challenge: Setting Up a Secure Web Application Architecture on Google Cloud
Task is to deploy Python Flask Application and MQSQL database on different VM instances ensuring secure communication using private and public subnets. We will configure NAT (Network Address Translation) for internet access while keeping your database secured in a private network.

## Step 1: Create a VPC with two subnets [private and public]
![image](https://github.com/user-attachments/assets/d17f6cd5-e4f7-49f4-aeb3-3ad86e504e0f)

- private subnet range : 192.168.2.0/24 with Private Google Access Enabled

![image](https://github.com/user-attachments/assets/dc11aae4-b205-4326-823d-c370d1f5b781)

- public subnet range : 192.168.1.0/24 with Private Google Access Disabled
  
![image](https://github.com/user-attachments/assets/64b2b73a-f89a-4361-abb7-45d99b08398e)

## Step 2: Create a NAT gateway for private subnet
- NAT gateway is needed for the instances in private subnet to communicate to internet to download certain packages.
- We need to map the NAT gateway to private subnet so that the outgoing traffic from private instances will route via NAT gateway to the internet

![image](https://github.com/user-attachments/assets/6ca86d40-5c73-4f02-bcda-5010dd6812d1)

## Step 3: Create Routes in VPC
- **Public Subnet:** Needs a route to the Internet Gateway so it can communicate with the internet.  
- **Private Subnet:** Needs a route to the NAT Gateway to allow it to access the internet for outbound traffic from private instances.  
- **Instance tags are must to specifiy, otherwise the route will be applicable for all the instances in VPC network**  
- Instance tags can be network tag specified during VM creation
- By default 3 defaults routes gets created for communication between the subnets and one directly to the internet

![image](https://github.com/user-attachments/assets/2fc8b34a-62ac-4fff-8895-39e443fbd7f7)

- The route for the instances having network tag as "private-network-tag" [The VM is located in private-subnet of network my-vpc] has next hop as "Default internet gateway"
- In GCP, there is no option to  explicitly select next hop as "NAT Gatway" so we have to select as "Default internet gateway"
- Outbound traffic from all instances in private-subnet will go via NAT Gateway bcs we have already created a NAT gateway and mapped to the private-subnet

## Flow
- VM in Private Subnet: When a VM in the private subnet generates outbound traffic, it is destined for the Internet (0.0.0.0/0).
- Route Evaluation: The route for 0.0.0.0/0 applies, and GCP looks for the Next hop:
  - The route for 0.0.0.0/0 points to the Default Internet Gateway.
  - Because the NAT Gateway is linked to the private subnet, GCP automatically routes the traffic from the private subnet to the NAT Gateway, which handles the translation of private IP addresses to public IP addresses

## Step 4: Create GCE instances in public and private subnets

![image](https://github.com/user-attachments/assets/a6527e21-ccf3-4a32-b065-9a0a7de00d12)

- Make sure to configure network tags while creating VMs, these tags will be refered in routes and well as in fireall rules in VPC network.

## Step 5: Create firewall rules in VPC network
- Create a firewall rule in VPC network to allow traffic **ONLY from public instance's private IP [where flask application resides] to private instance [where MQSQL database is running on port 3306]**
- This way we are securing the database in private instance.

![image](https://github.com/user-attachments/assets/59b3b154-a843-49b5-ba32-cd8a55d7c48d)

## Step 6: Install MQSQL Database on private instance and configure python flask app on public instance
Reference link : https://docs.vultr.com/how-to-install-mysql-on-debian-12

```bash
CREATE DATABASE testdb;
CREATE USER 'admin'@'192.168.2.2' IDENTIFIED BY 'admin';
GRANT ALL PRIVILEGES ON testdb TO 'admin'@'192.168.2.2';
FLUSH PRIVILEGES;
```

```bash
import mysql.connector
from flask import Flask

app = Flask(__name__)

@app.route('/')
def index():
    try:
        conn = mysql.connector.connect(
            host="192.168.2.2",
            user="admin",
            password="admin",
            database="testdb"
        )
        return "Connected to the database"
    except mysql.connector.Error as err:
        return f"Error connecting to database: {err}"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=3306)
```



