enabled_apps=$(./occ app:list --enabled | awk '{ if (NR!=1) { print substr($2, 1, length($2)-1); }}')
disabled_apps=$(./occ app:list --disabled | awk '{ if (NR!=1) { print substr($2, 1, length($2)-1); }}')

# These apps ship and can't be removed
min_apps="files cloud_federation_api dav federatedfilesharing lookup_server_connector provisioning_api oauth2 settings theming twofactor_backupcodes viewer workflowengine"

# These apps are wanted and may or may not be enabled/installed
if [ -z ${NC_WANTED_APPS+x} ];
then
	NC_WANTED_APPS="admin_audit"
fi

combined_list="${min_apps} ${NC_WANTED_APPS}"

# doesn't work in sh :(
#to_be_removed=($(comm -3 <(printf "%s\n" "${enabled_apps}" | sort)  <(printf "%s\n" "${combined_list}" | sort)))

contains() {
	for x in $1;
	do
		if [ "${x}" = "$2" ];
		then
			echo 0
			exit
		fi
	done
	echo 1
}

for enabled_app in ${enabled_apps};
do
	disable=$(contains "${combined_list}" "${enabled_app}")

	if [ "${disable}" -eq 1 ];
	then
		echo "Disabling app - ${enabled_app}"
		./occ app:disable ${enabled_app}
	else
		echo "Not disabling app - ${enabled_app}"
	fi
done

for wanted_app in ${NC_WANTED_APPS};
do
	enable=$(contains "${disabled_apps}" "${wanted_app}")

	if [ "${enable}" -eq 0 ];
	then
		echo "Enabling app - ${wanted_app}"
		./occ app:enable ${wanted_app}
	else
		needs_install=$(contains "${enabled_apps}" "${wanted_app}")

		if [ "${needs_install}" -eq 1 ];
		then
			echo "Wanted app - ${wanted_app} needs manual install"
		else
			echo "Wanted app - ${wanted_app} already enabled"
		fi
	fi
done
