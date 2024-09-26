# NC_DEFAULT_APP - (string) comma separated list of app names or a single app name.
if [ -z ${NC_DEFAULT_APP+x} ];
then
	echo "NC_DEFAULT_APP not set not doing anything"
else
	./occ config:system:set defaultapp --value "${NC_DEFAULT_APP}"
fi
