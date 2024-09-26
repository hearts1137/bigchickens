#/bin/bash
docker exec --user root keycloak /bin/bash -c "/opt/keycloak/bin/kc.sh export --dir /tmp --users same_file"
docker cp keycloak:/tmp/nextcloud-users-0.json .