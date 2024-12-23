# Challenge: Multi-Service Reverse Proxy with Nginx

![image](https://github.com/user-attachments/assets/2ba849e3-79a1-4562-afbe-8c43bb899bfe)


## **Service Setup:**  
Install and run Grafana, Jenkins,  nginix locally or using Docker AND  
## **Nginx Reverse Proxy:**  
Configure Nginx to route requests:  
https://grafana.local → Grafana (with Basic Authtication).  
https://jenkins.local → Jenkins (with Basic Authentication).  

**Steps:**
```bash
docker pull grafana/grafana
docker pull jenkins/jenkins:lts-jdk17
docker pull ubuntu/nginx

docker run -d --name=grafana -p 3000:3000 grafana/grafana
docker run -d --name=jenkins -p 8080:8080 -p 50000:50000 --restart=on-failure -v jenkins_home:/var/jenkins_home jenkins/jenkins:lts-jdk17
docker run -d --name=nginx -e TZ=UTC -p 8081:80 ubuntu/nginx:latest

http://localhost:8080/	- jenkins
http://localhost:3000/	- grafana
http://localhost:8081/	- nginx
````
Add below domains to hosts file in WSL(is using WSL) as well in Windows, just to have a domain for our applications  
```bash
127.0.0.1   grafana.local
127.0.0.1   jenkins.local

http://grafana.local:3000/		- grafana
http://jenkins.local:8080/		- jenkins
http://localhost:8081/			- nginx

docker exec -it nginx ping grafana
docker exec -it nginx ping jenkins
**[ping failed]**
```
Even though all the containers are on the same Docker network (bridge, check network id below, same for all containers), Nginx inside the container is unable to resolve the container names (grafana, jenkins). This is because the default bridge network doesn't support container name resolution by default  
```bash
docker inspect nginx
 "Networks": {
                "bridge": {
                    "IPAMConfig": null,
                    "Links": null,
                    "Aliases": null,
                    "MacAddress": "02:42:ac:11:00:04",
                    "DriverOpts": null,
                    "NetworkID": "c13ccfef94ccb841670b36d9c60e682ffea3021b1fe8922b2c80f68c1f856bab",
                    "EndpointID": "573db995df0c27926f418d12727a1d139029fda1bd617ddb490b5e9a0d550554",
                    "Gateway": "172.17.0.1",
                    "IPAddress": "172.17.0.4",
                    "IPPrefixLen": 16,
                    "IPv6Gateway": "",
                    "GlobalIPv6Address": "",
                    "GlobalIPv6PrefixLen": 0,
                    "DNSNames": null
                }
			}
docker inspect jenkins
 "Networks": {
                "bridge": {
                    "IPAMConfig": null,
                    "Links": null,
                    "Aliases": null,
                    "MacAddress": "02:42:ac:11:00:03",
                    "DriverOpts": null,
                    "NetworkID": "c13ccfef94ccb841670b36d9c60e682ffea3021b1fe8922b2c80f68c1f856bab",
                    "EndpointID": "6f2fdf2050ad70d44e80851bf7a793de4da46c70d2aed05921d0ea5ac2bee8b4",
                    "Gateway": "172.17.0.1",
                    "IPAddress": "172.17.0.3",
                    "IPPrefixLen": 16,
                    "IPv6Gateway": "",
                    "GlobalIPv6Address": "",
                    "GlobalIPv6PrefixLen": 0,
                    "DNSNames": null
                }
			}
docker inspect grafana
"Networks": {
                "bridge": {
                    "IPAMConfig": null,
                    "Links": null,
                    "Aliases": null,
                    "MacAddress": "02:42:ac:11:00:02",
                    "DriverOpts": null,
                    "NetworkID": "c13ccfef94ccb841670b36d9c60e682ffea3021b1fe8922b2c80f68c1f856bab",
                    "EndpointID": "99565f597c9565543d0640d15e90eb81b4fafe06854fe8eab3bc87354b778f3e",
                    "Gateway": "172.17.0.1",
                    "IPAddress": "172.17.0.2",
                    "IPPrefixLen": 16,
                    "IPv6Gateway": "",
                    "GlobalIPv6Address": "",
                    "GlobalIPv6PrefixLen": 0,
                    "DNSNames": null
                }
			}
```
Hence, add all the containers to the custom network  
```bash
docker network create my-network
docker network connect my-network nginx
docker network connect my-network jenkins
docker network connect my-network grafana

docker exec -it nginx ping grafana
PING grafana (172.18.0.4) 56(84) bytes of data.
64 bytes from grafana.my-network (172.18.0.4): icmp_seq=1 ttl=64 time=7.28 ms

docker exec -it nginx ping jenkin
PING jenkins (172.18.0.3) 56(84) bytes of data.
64 bytes from jenkins.my-network (172.18.0.3): icmp_seq=1 ttl=64 time=20.5 ms
```
**Configure nginx to route the request to domains of jenkins and grafana**  
Steps:  
/etc/nginx/sites-enabled/default --> edit the default file in nginx container as below  
```bash
server {
        listen 80;
        server_name grafana.local;

        location / {
          proxy_pass http://grafana:3000;
          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;
        }
}
server {
        listen 80;
        server_name jenkins.local;

        location / {
          proxy_pass http://jenkins:8080;
          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;
        }
}
```
Check the syntax  
```bash
nginx -t
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful
```
Reload nginx for the changes to get applied  
```bash
service nginx reload
```
Test the below URLS now :  
```bash
http://grafana.local:8081/
http://jenkins.local:8081/
```
Understanding the Flow:
```bash
http://grafana.local:8081/
	- browser resolves to IP address as per entries in hosts file
	- resolved to 127.0.0.1:8081
		|
		|
request goes to nginx container port 8081 --> 80 [application port]
		|
		|
configuration of nginx  explaination:
	- listen 80;                                  #nginx listens on port 80
	- server_name grafana.local;                  #checks for the server grafana.local
	- proxy_pass http://grafana:3000;             #routes the request to grafana container running on port 3000
	- proxy_set_header Host $host;                #$host in incoming request is host info (grafana.local), backend Grafana knows from which domain req came in
	- proxy_set_header X-Real-IP $remote_addr;    #IP address of client making the request
	- proxy_set_header X-Forwarded-Proto $scheme;  #$scheme contains info about whether  the incoming request in http or https
		|
		|
http://grafana.local:8081/
	- Grafana receives requests
	- Sends the response back to nginx server
		|
		|
127.0.0.1:8081
		|
	- nginx sends the response back to browser
```
## **Include Basic Authentication for Jenkins and  Grafana**
```bash
apt-get install apache2-utils
htpasswd -c /etc/nginx/.htpasswd admin
````
Add below lines in both the server sections of nginx config, reload the nginx to apply the changes
```bash
auth_basic "Restricted Content";
auth_basic_user_file /etc/nginx/.htpasswd;
````
![image](https://github.com/user-attachments/assets/4c19b5b0-5542-4eb3-bf3a-ae4281024609)  
![image](https://github.com/user-attachments/assets/c54370b2-f61b-4601-9b58-757bbda8421a)

## **Enable SSL:**
- Generate and configure a self-signed SSL certificate for HTTPS access.  
- Redirect all HTTP traffic to HTTPS.

**Steps**
Inside current nginx container, create a self-signed cert
```bash
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt

root@284b8fa67c4b:/etc/ssl/certs#
-rw-r--r-- 1 root root   1480 Dec 22 15:11  nginx-selfsigned.crt
root@284b8fa67c4b:/etc/ssl/private#
-rw------- 1 root root 1704 Dec 22 15:10 nginx-selfsigned.key
```` 
Issue : Nginx listens on port 443 for SSL, hence need to create a new container with 443 exposed  
```bash
docker commit 284b8fa67c4b nginx-new   #commit id of already running container
docker images
docker run -d --name=nginx-new-cont -e TZ=UTC -p 80:80 -p 443:443 --network=my-network nginx-new:latest
````
Issue: #now the certs are in WSL, but we are testing from local machine, so copy the cert in windows and installed them  
```bash
cp /root/nginx-selfsigned.crt /mnt/c/Users/Tanmay/Desktop/
#install the certs and test the URLs
http:jenkins.local:80 --redirects to ---> https:jenkins.local:80
http:grafana.local:80 --redirects to ---> https:grafana.local:80
````
![image](https://github.com/user-attachments/assets/7eccb787-a22b-45fa-87a5-0cdc96fee650)
![image](https://github.com/user-attachments/assets/f6875753-f22f-4824-a30d-9fa9a12af50f)


