if [ -z ${NC_DEFAULT_QUOTA+x} ];
then
	NC_DEFAULT_QUOTA='0 B'
fi
./occ config:app:set files default_quota --value "${NC_DEFAULT_QUOTA}"

if [ -z ${NC_THEME_BACKGROUND_IMAGE+x} ];
then
	NC_THEME_BACKGROUND_IMAGE=/tmp/theming/background
fi
if [ -z ${NC_THEME_LOGO_IMAGE+x} ];
then
	NC_THEME_LOGO_IMAGE=/tmp/theming/logo
fi
if [ -z ${NC_THEME_LOGO_HEADER_IMAGE+x} ];
then
	NC_THEME_LOGO_HEADER_IMAGE=/tmp/theming/logoheader
fi
if [ -z ${NC_THEME_FAVICON+x} ];
then
	NC_THEME_FAVICON=/tmp/theming/favicon
fi
if [ -z ${NC_APP_ID+x} ];
then
	NC_APP_ID=$(./occ config:system:get instanceid)
fi

image_dir=/var/www/html/data/appdata_${NC_APP_ID}/theming/global/images/
if [ ! -d ${image_dir} ];
then
	mkdir -p ${image_dir}
fi

if [ -z ${NC_THEME_NAME+x} ];
then
	echo "NC_THEME_NAME is not set not changing";
else
	./occ theming:config name "${NC_THEME_NAME}"
fi

if [ -z ${NC_THEME_SLOGAN+x} ];
then
	echo "NC_THEME_SLOGAN is not set not changing";
else
	./occ theming:config slogan "${NC_THEME_SLOGAN}"
fi

if [ -z ${NC_THEME_URL+x} ];
then
	echo "NC_THEME_URL is not set not changing";
else
	./occ theming:config url "${NC_THEME_URL}"
fi

if [ -z ${NC_THEME_PRIMARY_COLOR+x} ];
then
	echo "NC_THEME_PRIMARY_COLOR is not set not changing";
else
	./occ theming:config primary_color "${NC_THEME_PRIMARY_COLOR}"
fi

if [ -f ${NC_THEME_BACKGROUND_IMAGE} ];
then
	echo "Setting a background image"
	bg_mime=$(file --mime-type -b ${NC_THEME_BACKGROUND_IMAGE})
	cp ${NC_THEME_BACKGROUND_IMAGE} ${image_dir}/background
	./occ config:app:set theming backgroundMime --value "${bg_mime}"
elif [ -z ${NC_THEME_BACKGROUND_COLOR+x} ];
then
	echo "Setting background color"
	./occ config:app:set theming backgroundMime --value 'backgroundColor'
	./occ config:app:set theming background_color --value "${NC_THEME_BACKGROUND_COLOR}"
else
	echo "No change to background"
fi

if [ -f ${NC_THEME_LOGO_IMAGE} ];
then
	echo "Setting a logo image"
	logo_mime=$(file --mime-type -b ${NC_THEME_LOGO_IMAGE})
	cp ${NC_THEME_LOGO_IMAGE} ${image_dir}/logo
	./occ config:app:set theming logoMime --value "${logo_mime}"
else
	echo "No change to logo"
fi

if [ -f ${NC_THEME_LOGO_HEADER_IMAGE} ];
then
	echo "Setting a header logo image"
	logo_header_mime=$(file --mime-type -b ${NC_THEME_LOGO_HEADER_IMAGE})
	cp ${NC_THEME_LOGO_HEADER_IMAGE} ${image_dir}/logoheader
	./occ config:app:set theming logoheaderMime --value "${logo_header_mime}"
else
	echo "No change to header logo"
fi

if [ -f ${NC_THEME_FAVICON} ];
then
	echo "Setting a favicon"
	favicon_mime=$(file --mime-type -b ${NC_THEME_FAVICON})
	cp ${NC_THEME_FAVICON} ${image_dir}/favicon
	./occ config:app:set theming faviconMime --value "${favicon_mime}"
else
	echo "No change to favicon"
fi

if [ -z ${NC_THEME_DISABLE_USER_THEMING+x} ];
then
	echo "NC_THEME_DISABLE_USER_THEMING is not set not changing";
else
	./occ theming:config disable-user-theming "${NC_THEME_DISABLE_USER_THEMING}"
fi
