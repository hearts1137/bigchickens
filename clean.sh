yes | docker system prune --all --volumes
rm -rf logs/ mariadb/ nextcloud/ postgres_data/ logs/
chown -R ec2-user:ec2-user /home/ec2-user/
