# The following can probably be done better with modern shells, but the shell used during docker bring up is very limited
# and it is better to have a simple script that is more compatible
#
# Using this needs to be done with great care as a mistake can bork your setup
# To allow basic fixing two actions are supported add_update and delete
#
# Adds:
# NC_CONFIGS - (string) space separated list of config values formatted as action##key##value
#	actions: 	add_update requires a value otherwise the value will be set to empty string.
#			delete requires a key only
# NC_CONFIGS_DONT_ECHO_CONFIG - (anything) if set config.php will not be printed

if [ -z ${NC_CONFIGS+x} ];
then
	echo "No additional config values provided in NC_CONFIGS"
else
	echo "Found configuration values in NC_CONFIGS, attemtping to apply"

	if [ -z ${NC_CONFIGS_DONT_ECHO_CONFIG+x} ];
	then
		echo "Current config"
		cat config/config.php
	fi

	for config in ${NC_CONFIGS};
	do
		action=$(echo ${config} | awk 'BEGIN { FS="##" }{ print $1; }')
		key=$(echo ${config} | awk 'BEGIN { FS="##" }{ print $2; }')

		if [ "${action}" = "add_update" ];
		then
			val=$(echo ${config} | awk 'BEGIN { FS="##" }{ print $3; }')
			echo "Setting key: ${key} to: ${val}"
			./occ config:system:set "${key}" --value "${val}"
		elif [ "${action}" = "delete" ];
		then
			echo "Removing ${key}"
			./occ config:system:delete "${key}"
		fi
	done

	if [ -z ${NC_CONFIGS_DONT_ECHO_CONFIG+x} ];
	then
		echo "New config"
		cat config/config.php
	fi
fi
