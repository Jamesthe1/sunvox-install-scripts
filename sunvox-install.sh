#!/bin/bash

COL_AQUA='\x1b[96m'
COL_RED='\x1b[31m'
COL_RST='\x1b[0m'

PREFIX="${COL_AQUA}[sunvox-install]${COL_RST}"

# Check if we are root first
USR=`whoami`
if [ "$USR" != "root" ]; then
	DOAS=`which doas`
	SUDO=`which sudo`
	if [ "$DOAS" != "" ]; then
		TOROOT=$DOAS
	elif [ "$SUDO" != "" ]; then
		TOROOT=$SUDO
	else
		# Redirect to stderr (2)
		>&2 echo -e "${PREFIX} ${COL_RED}No suitable privilege elevator installed!${COL_RST}"
		exit 1
	fi
	echo -e "${PREFIX} Using privilege elevator ${TOROOT}"
fi

echo -e "${PREFIX} Downloading SunVox..."
wget -q -O sunvox.zip https://warmplace.ru/soft/sunvox/sunvox-2.1c.zip
echo -e "${PREFIX} Extracting SunVox..."
unzip -q sunvox.zip -d . && rm sunvox.zip
cd ./sunvox/sunvox
ls . | grep -Po '^((?!linux_x86_64).)*$' | xargs rm -r
echo -e "${PREFIX} Arranging files..."
# Use wildcard because you cannot move a folder into its parent
mv linux_x86_64/* . && rmdir ./linux_x86_64
wget -q https://warmplace.ru/soft/sunvox/images/icon.png
cd - > /dev/null

echo -e "${PREFIX} Installing SunVox..."
INSTALL_CMD='mv ./sunvox/sunvox /usr/bin/sunvox'
ADD_DESKTOP='cp sunvox.desktop /usr/share/applications'
# Checking if the variable is unset
if [ -z ${TOROOT+x} ]; then
	$INSTALL_CMD
	$ADD_DESKTOP
else
	$TOROOT $INSTALL_CMD
	$TOROOT $ADD_DESKTOP
fi
echo -e "${PREFIX} Installation complete. You may move the leftover sunvox folder into your Documents, or elsewhere."
