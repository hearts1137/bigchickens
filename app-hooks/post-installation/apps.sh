./occ app:disable activity
./occ app:disable bruteforcesettings
./occ app:disable circles
./occ app:disable comments
./occ app:disable contactsinteraction
./occ app:disable dashboard
./occ app:disable encryption
./occ app:disable federation
./occ app:disable files_downloadlimit
./occ app:disable files_reminders
./occ app:disable files_sharing
./occ app:disable files_trashbin
./occ app:disable files_versions
./occ app:disable nextcloud_announcements
./occ app:disable notifications
./occ app:disable privacy
./occ app:disable recommendations
./occ app:disable related_resources
./occ app:disable sharebymail
./occ app:disable support
./occ app:disable survey_client
./occ app:disable suspicious_login
./occ app:disable systemtags
./occ app:disable twofactor_backupcodes
./occ app:disable twofactor_totp
./occ app:disable updatenotification
./occ app:disable user_ldap
./occ app:disable user_status
./occ app:disable weather_status
cp -R /tmp/sociallogin /var/www/html/apps/
./occ app:install sociallogin
./occ app:remove activity
./occ app:remove bruteforcesettings
./occ app:remove circles
./occ app:remove comments
./occ app:remove contactsinteraction
./occ app:remove dashboard
./occ app:remove encryption
./occ app:remove federation
./occ app:remove files_downloadlimit
./occ app:remove files_reminders
./occ app:remove files_sharing
./occ app:remove files_trashbin
./occ app:remove files_versions
./occ app:remove nextcloud_announcements
./occ app:remove notifications
./occ app:remove privacy
./occ app:remove recommendations
./occ app:remove related_resources
./occ app:remove sharebymail
./occ app:remove support
./occ app:remove survey_client
./occ app:remove suspicious_login
./occ app:remove systemtags
./occ app:remove twofactor_backupcodes
./occ app:remove twofactor_totp
./occ app:remove updatenotification
./occ app:remove user_ldap
./occ app:remove user_status
./occ app:remove weather_status
./occ app:enable sociallogin
./occ app:enable filesexternal
./occ app:enable admin_audit