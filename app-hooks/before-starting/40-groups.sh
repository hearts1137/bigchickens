#NC_GROUPS - (string) space separated list of desired group names
if [ -z ${NC_GROUPS+x} ];
then
	echo "NC_GROUPS not set not creating groups"
else
	for nc_group in ${NC_GROUPS};
	do
		./occ group:add ${nc_group}
	done
	exit 0
fi
