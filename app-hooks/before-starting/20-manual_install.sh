#NC_MANUAL_APPS_PATH - (string) path where any apps that are to be deployed "manually" are located, default /tmp/apps
if [ -z ${NC_MANUAL_APPS_PATH+x} ];
then
	NC_MANUAL_APPS_PATH=/tmp/apps
fi

# This expects unzipped/untarred folders of the appname and appname.conf with config values
for app in `ls ${NC_MANUAL_APPS_PATH}`;
do
	if [ -d ${NC_MANUAL_APPS_PATH}/${app} ];
	then
		echo "Manual install app - ${app}"
		cp -r ${NC_MANUAL_APPS_PATH}/${app} apps/
		./occ app:enable ${app}
	fi
done
