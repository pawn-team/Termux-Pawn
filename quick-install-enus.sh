#!/data/data/com.termux/files/usr/bin/bash

# Define output prefixes for messages
ERROR="\033[1;31m[ \033[1;37m- \033[1;31m] \033[1;33m"
ALERT="\033[1;33m[ \033[1;37m- \033[1;33m] \033[1;36m"
NORMAL="\033[1;32m[ \033[1;37m- \033[1;32m] \033[1;34m"


# Check Termux version
if [ ! "$TERMUX_VERSION" = "0.118.0" ]; then
	echo -e "$ERROR You need to install Termux v0.118.0!"
	exit 1
fi


# Check external storage access permission
echo -e "$NORMAL Checking external storage access..."
while true; do
	if [ ! -w "/sdcard" ]; then
		termux-setup-storage
		sleep 1
	else
		break
	fi
done


# Check device architecture
MACHINE=$(uname -m)
echo -e "$NORMAL Your architecture is: \033[0;37m$MACHINE\n"

BINARY_NAME="arm"
if [ "$MACHINE" = "aarch64" ]; then
	BINARY_NAME="aarch64"
fi


# Download binary files
wget -q "https://github.com/pawn-team/Termux-Pawn/releases/download/${MACHINE}/termux-pawn-enus_3.10.10_${BINARY_NAME}.deb" -O $HOME/termux-pawn.deb

# Check binary integrity
AARCH64_ENUS="ac2dc1477437d424e5ce39d2a588db568a3be3613b13bb2862c170e9c9535f04"
ARMV8_ENUS="724389b253b1c67caf26655dc5398ba124e7f8a063c220b38915fc2231ff806a"
ARMV7_ENUS="ff84ada07034a56b8cd4e127e8b72ef6cf86606b3bd49f8df7f79c13bb7b50af"
ARMHF_ENUS="d9a7c061c01459da8e29f20a3baae187db9e723c88500d6436ad6e48edbcf563"

CHECKSUM=$(sha256sum $HOME/termux-pawn.deb | awk '{print $1}')

case "$CHECKSUM" in
	"$AARCH64_ENUS" | "$ARMV8_ENUS" | "$ARMV7_ENUS" | "$ARMHF_ENUS")
		echo -e "$NORMAL Download completed without fail!"
		;;
	
	*)
		echo -e "$ERROR Download completed with failure, unable to complete installation!"
		exit 1
		;;
esac


# Install binary files
echo -e "$NORMAL Installing downloaded binaries"

dpkg -r termux-pawn-ptbr termux-pawn-enus &> /dev/null
dpkg -i $HOME/termux-pawn.deb &> /dev/null

echo "-Z+ -d3 -;+ -(+ -R+ -E+ -i:/sdcard/Pawn" > $PATH/pawn.cfg
echo "alias pawncc='pawncc @$PATH/pawn.cfg'" > $PREFIX/etc/termux-pawn.sh
echo "alias termux-pawn-remove='unalias pawncc && unalias termux-pawn-remove && dpkg -r termux-pawn-enus termux-pawn-ptbr &> /dev/null && rm -rf $PREFIX/etc/termux-pawn.sh'" >> $PREFIX/etc/termux-pawn.sh
echo "source $PREFIX/etc/termux-pawn.sh &> /dev/null" >> $PREFIX/etc/profile


# Download libraries
echo -en "\n$ALERT Do you want to install includes for Open.MP? \033[1;37m[ y | N ]"
read result

mkdir -p "/sdcard/Pawn"
rm -rf $HOME/*-stdlib

if [ "$result" = "y" ] || [ "$result" = "Y" ]; then
	git clone -q https://github.com/openmultiplayer/omp-stdlib $HOME/omp-stdlib 
	mv $HOME/omp-stdlib/*.inc /sdcard/Pawn
else
	git clone -q https://github.com/pawn-lang/samp-stdlib $HOME/samp-stdlib 
	git clone -q https://github.com/pawn-lang/pawn-stdlib $HOME/pawn-stdlib 
	mv $HOME/samp-stdlib/*.inc /sdcard/Pawn
	mv $HOME/pawn-stdlib/*.inc /sdcard/Pawn
fi

echo -e "$NORMAL Standard Library installed successfully!"


# Display tips
echo -e "\n\n\033[1;33m>>>> TIPS:"
echo -e "\n\033[1;33m>> \033[1;37mAdd your includes in the folder: /sdcard/Pawn"
echo -e "\n\033[1;33m>> \033[1;37mYou can create a configuration for your gamemode using: cp -r \$PATH/pawn.cfg \$PWD"
echo -e "\n\033[1;33m>> \033[1;37mTo uninstall, use: \033[1;36mtermux-pawn-remove"
echo -e "\n\033[1;33m>> \033[1;37mYou can send suggestions and report issues to the email: devicewhite@proton.me\n\n\033[0;37m"