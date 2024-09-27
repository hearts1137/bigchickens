# The following should run after groups/users are created that are mentioned in the config which is about to be imported.
# NC_FILES_EXTERNAL_CONFIG_PATH - (string) path where the json config dump can be found.
# json can be generated with ./occ files_external:export or edited from a file generated like that.
if [ ! -z ${NC_FILES_EXTERNAL_CONFIG_PATH+x} ];
then
	# Verify that files_external is installed
	files_external_installed=$(./occ app:list --enabled | grep -c files_external)

	if [ ${files_external_installed} -eq 1 ];
	then
		if [ -f ${NC_FILES_EXTERNAL_CONFIG_PATH} ];
		then
			echo "Attempting files_external import"
			./occ files_external:import "${NC_FILES_EXTERNAL_CONFIG_PATH}"
			echo "import return: $?"
		fi
	else
		echo "Error - files_external is not enabled, can't import a config for it"
	fi
fi
