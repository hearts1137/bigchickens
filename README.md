# bigchickens
![bigchickens](https://github.com/user-attachments/assets/9fbab409-1752-4fb2-ab48-1636fbe73db1)
Project based on docker compose running on a RHEL 8 EC2 t3a.medium in AWS. All latest containers and an emphasis on security.
Create the RHEL 8 EC2 and add the following user-data
```
dnf clean all && dnf makecache
dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
dnf -y update --nobest
dnf install -y dos2unix git vim docker-ce docker-ce-cli containerd.io docker-compose-plugin
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
SOme helpful commands while testing to clean the environment
```
rm -rf logs/ mariadb/ nextcloud/
docker system prune --all --volumes
```
