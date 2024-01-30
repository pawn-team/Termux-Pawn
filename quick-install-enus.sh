#!/data/data/com.termux/files/usr/bin/bash

# Define o diretorio principal
root="/data/data/com.termux/files/home"

# Install necessary packages
pkg i -y git wget &> /dev/null

# Define output prefixes for messages
prefix_ok="\033[1;32m[ \033[1;37m+ \033[1;32m]"
prefix_no="\033[1;31m[ \033[1;37m- \033[1;31m]"

# Check write permission for internal storage
if [ ! -w "/sdcard" ]; then
	echo -e "${prefix_no} \033[0;33mUnable to access internal storage."
	echo -e "${prefix_no} \033[0;33mUse the command: \033[0;37mtermux-setup-storage"
	exit 1
else
	mkdir -p /sdcard/Pawn
fi

# Ask user if they want to download includes for Open.MP
echo -e "${prefix_ok} \033[1;36mDo you want to download includes for \033[1;37mOpen.MP\033[1;36m?"
echo -n -e "${prefix_ok} \033[1;36mType \033[1;37mYES \033[1;36mor \033[1;37mNO\033[1;36m: \033[0;37m"
read option

# Download and move includes based on user's choice
if [ "$option" = "YES" ] || [ "$option" = "yes" ]; then
	# Download and move Open.MP includes
	echo -e "${prefix_ok} \033[0;34mDownloading omp-stdlib..."
	git clone -q https://github.com/openmultiplayer/omp-stdlib $root/omp-stdlib

	# Check if download was successful
	if [ ! -w "${root}/omp-stdlib" ]; then
		echo -e "${prefix_no} \033[0;33mDownload incomplete!"
		exit 1
	else
		echo -e "${prefix_ok} \033[0;34momp-stdlib downloaded successfully..."
		mv $root/omp-stdlib/*.inc /sdcard/Pawn
		rm -rf $root/omp-stdlib
	fi
else
	# Download and move Pawn standard library includes
	echo -e "${prefix_ok} \033[0;34mDownloading pawn-stdlib..."
	git clone -q https://github.com/pawn-lang/pawn-stdlib $root/pawn-stdlib

	# Check if download was successful
	if [ ! -w "${root}/pawn-stdlib" ]; then
		echo -e "${prefix_no} \033[0;33mDownload incomplete!"
		exit 1
	else
		echo -e "${prefix_ok} \033[0;34mpawn-stdlib downloaded successfully..."
		mv $root/pawn-stdlib/*.inc /sdcard/Pawn
		rm -rf $root/pawn-stdlib
	fi

	# Download and move SAMP includes
	echo -e "${prefix_ok} \033[0;34mDownloading samp-stdlib..."
	git clone -q https://github.com/pawn-lang/samp-stdlib $root/samp-stdlib

	# Check if download was successful
	if [ ! -w "${root}/samp-stdlib" ]; then
		echo -e "${prefix_no} \033[0;33mDownload incomplete!"
		exit 1
	else
		echo -e "${prefix_ok} \033[0;34msamp-stdlib downloaded successfully..."
		mv $root/samp-stdlib/*.inc /sdcard/Pawn
		rm -rf $root/samp-stdlib
	fi
fi

# Remove previous versions of the Pawn compiler
dpkg -r termux-pawn-enus termux-pawn-ptbr &> /dev/null

# Download English version of the compiler
echo -e "${prefix_ok} \033[0;33mDownloading English pawn compiler..."
wget -q "https://github.com/pawn-team/Termux-Pawn/releases/download/$(uname -m)/termux-pawn-enus_3.10.10_$(uname -m).deb" -O $root/termux-pawn.deb

# Check if download was successful
if [ ! -w "${root}/termux-pawn.deb" ]; then
	echo -e "${prefix_no} \033[0;33mDownload incomplete!"
	exit 1
else
	# Install the downloaded compiler
	echo -e "${prefix_ok} \033[0;34mCompiler downloaded successfully..."
	dpkg -i $root/termux-pawn.deb &> /dev/null
fi

rm -rf $root/termux-pawn.deb
echo -e "${prefix_ok} \033[0;34mTo uninstall, use: \033[0;37mdpkg -r termux-pawn-enus"

# Set up pawn.cfg and alias
echo "-Z+ -;+ -E+ -R+ -(+ -d3 -i:/sdcard/Pawn" > $PREFIX/bin/pawn.cfg

text_alias="alias pawncc='pawncc @$PREFIX/bin/pawn.cfg'"
profile_path="${PREFIX}/etc/profile"

# Check if the alias already exists in the profile
if grep -q "$text_alias" "$profile_path"; then
	# Remove the existing alias
	grep -v "$text_alias" "$profile_path" > .profile
	mv .profile $profile_path
fi

# Add the new alias to the profile
echo ${text_alias} >> $profile_path

# Display tips
echo -e "\n\n\033[1;33m>>>> TIPS:"
echo -e "\n\033[1;33m>> \033[1;37mAdd your includes to the folder: /sdcard/Pawn"
echo -e "\n\033[1;33m>> \033[1;37mYou can create a configuration for your gamemode using: cp -r \$PREFIX/bin/pawn.cfg \$PWD"
echo -e "\n\033[1;33m>> \033[1;37mFeel free to send suggestions and report issues to the email: devicewhite@proton.me\n\n"