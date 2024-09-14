# bigchickens
![bigchickens](https://github.com/user-attachments/assets/9fbab409-1752-4fb2-ab48-1636fbe73db1)
Project based on docker compose running on a RHEL 8 EC2 t3a.medium in AWS. All latest containers and an emphasis on security.
Create the RHEL 8 EC2 and add the following user-data
```
dnf clean all && dnf makecache
dnf -y update --nobest
dnf update -y platform-python-pip.noarch --best --allowerasing
dnf install -y dos2unix git vim
dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
dnf -y install docker-ce docker-ce-cli containerd.io docker-compose-plugin
dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
dnf update
dnf install -y certbot
systemctl enable docker
systemctl reboot
```
Once system is back up login, sudo to root and create the file /etc/docker/daemon.json
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
Tostart the stack on reboot creat the following file in /etc/systemd/system/project.service
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
