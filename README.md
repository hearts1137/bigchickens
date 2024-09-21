![bigchickens](https://github.com/user-attachments/assets/9fbab409-1752-4fb2-ab48-1636fbe73db1)
# NextCloud, Keycloak, Nginx, MariaDB and Docker
Using the user-data section when deploying an EC2 instance
```
#!/bin/bash
# Allow password logins
sed -i 's/^[ \t#]*PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config
systemctl reload sshd
echo "HostKeyAlgorithms ssh-ed25519,ecdsa-sha2-nistp256,ecdsa-sha2-nistp384,rsa-sha2-512,rsa-sha2-256,ssh-rsa" >> /etc/ssh/sshd_config
update-crypto-policies --set default

# clean and make dnf cache and install/upgrade all rhel8 packages
dnf clean all && dnf makecache
dnf -y update
dnf install -y dos2unix git vim
dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
dnf -y install docker-ce docker-ce-cli containerd.io docker-compose-plugin
dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
dnf update
dnf install -y certbot

# enable docker to start at boot
systemctl enable docker

# selinux disable
sed -i 's/enforcing/disabled/g' /etc/selinux/config

# disable FIPS
fips-mode-setup --disable

# ipv6 off
cat <<EOF >> /etc/sysctl.d/99-local-network.conf
################################################################################
# Local NetworkManager settings and server tuning                              #
################################################################################
#
kernel.randomize_va_space=2
net.ipv4.ip_forward=1
net.ipv4.conf.all.send_redirects=0
net.ipv4.conf.default.send_redirects=0
net.ipv4.conf.default.accept_redirects=0
net.ipv4.conf.all.accept_redirects=0
net.ipv4.conf.default.accept_source_route=0
net.ipv4.icmp_echo_ignore_broadcasts=1
net.ipv4.conf.all.accept_source_route=0
net.ipv6.conf.all.accept_source_route=0
net.ipv6.conf.all.disable_ipv6=1
net.ipv6.conf.default.disable_ipv6=1
EOF

#add /usr/local/bin tp $PATH when using sudo -i
echo "export PATH=$PATH:/usr/local/bin" >> /etc/profile.d/sh.local


## update the open file handles limit for all users
cat <<EOF >> /etc/security/limits.conf
* hard    maxlogins     20
* hard nofile 1000000
* soft nofile 100000
EOF

#create project directory
mkdir /home/ec2-user/bigchickens/

#create cleanup file
cat <<EOF >> /home/ec2-user/bigchickens/clean.sh
yes | docker system prune --all --volumes
rm -rf logs/ mariadb/ nextcloud/
chown -R ec2-user:ec2-user /home/ec2-user/
EOF

#make cleanup file executable
chmod +x /home/ec2-user/bigchickens/clean.sh

# modify docker
cat <<EOF >> /etc/docker/daemon.json
{
  "hosts": ["unix:///var/run/docker.sock", "tcp://0.0.0.0:2375"],
  "debug" : true,
  "default-address-pools" : [{ "base" : "192.168.46.0/16", "size" : 24}]
}
EOF

#apply docker tweaks
cp /lib/systemd/system/docker.service /etc/systemd/system/
sed -i 's/\ -H\ fd:\/\///g' /etc/systemd/system/docker.service
systemctl daemon-reload
systemctl restart docker

#create systemd service for docker compose project
cat <<EOF >> /etc/systemd/system/bigchickens.service
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
EOF

#REBOOT the system
systemctl reboot
```
Lazydocker is a cool TUI to look over the docker environment
https://github.com/jesseduffield/lazydocker
```
sudo su -
cd /home/ec2-user/bigchickens/
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
sudo su -
systemctl enable bigchickens
systemctl start bigchickens
systemctl status bigchickens
docker ps
```
Copy the social login NextCloud app to the apps directory
https://apps.nextcloud.com/apps/sociallogin
```
sudo su -
cd /home/ec2-user/bigchickens
cp -R sociallogin
```
Support topic I started on NextCloud support forums
---
https://help.nextcloud.com/t/occ-disable-and-remove-apps-at-docker-compose-startup/204048/3
---
# TO DO LIST
1. Send all docker container logs to S3 log bucket
2. Code clean up of keycloak ~~so not to use start-dev,~~ use mariadb as database engine
3. Develop procedure to export keycloak users inclusive of usernames and passwords
4. ~~Create amd configure NextCloud keycloak realm that works with NextCloud SocialLogin app settings for authentication and authorization~~
5. Code review of nginx.conf for security best practices
6. More I will think of later
