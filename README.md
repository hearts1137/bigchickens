# bigchickens
![bigchickens](https://github.com/user-attachments/assets/9fbab409-1752-4fb2-ab48-1636fbe73db1)
Project based on docker compose running on a RHEL 8 EC2 t3a.medium in AWS. All latest containers and an emphasis on security.
Create the RHEL 8 EC2 and add the following user-data
```
dnf clean all && dnf makecache
dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
dnf -y update --nobest
dnf install -y dos2unix git vim mlocate docker-ce docker-ce-cli containerd.io docker-compose-plugin
updatedb
systemctl enable docker
systemctl reboot
```
Once system is back up, login and sudo to root. Create the file /etc/docker/daemon.json
```
{
  "debug" : true,
  "default-address-pools" : [
    {
      "base" : "192.168.46.0/24",
      "size" : 24
    }
  ]
}
```
To start the stack on reboot create the following file /etc/systemd/system/bigchickens.service
```
[Unit]
Description=bigchickens
After=docker.service
Requires=docker.service

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/bin/bash -c "docker compose -f /home/ec2-user/bigchickens/docker-compose.yml up --detach"
ExecStop=/bin/bash -c "docker compose -f /home/ec2-user/bigchickens/docker-compose.yml stop"

[Install]
WantedBy=multi-user.target
```
Lazydocker is a cool TUI to look over the docker environment
https://github.com/jesseduffield/lazydocker
```
chmod +x lazydocker
```
To get your own Let's Encrypt Certificate you need to run the following after you verify your AWS security group is open to 0.0.0.0/0 on port 80 for the duration of the cert capture. Set it back to something secure when done gathering the cert and private key.
```
sudo su -
certbot certonly --standalone --noninteractive --agree-tos --no-eff-email --cert-name bigchickens.net -d bigchickens.net -d www.bigchickens.net -m info@bigchickens.net
cp /etc/letsencrypt/live/bigchickens.net/fullchain.pem /home/ec2/bigchickens/nginx/ssl/
cp /etc/letsencrypt/live/bigchickens.net/privkey.pem /home/ec2/bigchickens/nginx/ssl/
```
You are not ready to start the docker compose stack
```
sudo su -
cd /home/ec2-user/bigchickens/
docker compose up
```
Watch the logs for errors and tweak as necessary. When it is running properly enable the system service
```
systemctl enable bigchickens
systemctl start bigchickens
systemctl status bigchickens
docker ps
```
Copy the social login NextCloud app to the apps directory
```
sudo su -
cd /home/ec2-user/bigchickens
cp -R sociallogin 
Some helpful commands while testing to clean the environment
```
rm -rf logs/ mariadb/ nextcloud/
docker system prune --all --volumes
```
