![bigchickens](https://github.com/user-attachments/assets/9fbab409-1752-4fb2-ab48-1636fbe73db1)
# NextCloud, Keycloak, Nginx, MariaDB and Docker
Use the user-data section when deploying an EC2 instance
You are not ready to start the docker compose stack
```
sudo su -
cd /home/ec2-user/bigchickens/
docker compose up
```
Watch the logs for errors and tweak as necessary. When it is running properly enable the system service
```
sudo su -
systemctl enable bigchickens
systemctl start bigchickens
systemctl status bigchickens
docker ps
```
# TO DO LIST
1. Send all docker container logs to S3 log bucket
2. Code clean up of keycloak ~~so not to use start-dev,~~ ~~use postgres as database engine~~
3. Use postgres for both keycloak and nextcloud, eliminating mariaDB
4. ~~Develop procedure to export keycloak users inclusive of usernames and passwords~~
5. Create amd configure NextCloud keycloak realm that works with NextCloud SocialLogin app settings for authentication and authorization
6. Code review of nginx.conf for security best practices
7. More I will think of later
