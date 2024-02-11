#!/data/data/com.termux/files/usr/bin/bash

if [ ! "$HOME" = "/data/data/com.termux/files/home" ]; then
	echo -e "\033[1;31m      FAIL:    \033[0;37mYou are not using the Termux application!"
	echo -e "\033[1;31m      ERRO:    \033[0;37mVocê não está usando o aplicativo Termux!"
	exit 1
fi

if [ ! "${1,,}" = "enus" ] && [ ! "${1,,}" = "ptbr" ]; then
	echo -e "\033[1;31m      FAIL:    \033[0;37mYou need to indicate the language: \033[1;36mbash quick-install.sh ptbr"
	echo -e "\033[1;31m      ERRO:    \033[0;37mVocê precisa indicar o idioma: \033[1;36mbash quick-install.sh ptbr"
	exit 1
fi

question=false
while true; do
	if [ ! -w "$EXTERNAL_STORAGE" ]; then
		if [ "$question" = "false" ]; then
			echo -e "\033[1;33m      INFO:    \033[0;37mYou need to allow access to external memory!!"
			echo -e "\033[1;33m      INFO:    \033[0;37mVocê precisa permitir o acesso à memória externa!"
			question=true
			sleep 1
		fi
		
		rm -rf $HOME/storage
		termux-setup-storage
	else
		break
	fi
	
	sleep 1
done

dpkg -r termux-pawn-enus termux-pawn-ptbr &> /dev/null
machine=$(uname -m)

case "$machine" in
	"armv7l" | "armv8l" | "armhf")
		wget -q --no-check-certificate "https://github.com/pawn-team/Termux-Pawn/releases/download/$machine/termux-pawn-${1,,}_3.10.10_arm.deb"
		dpkg -i "termux-pawn-${1,,}_3.10.10_arm.deb" &> /dev/null
		;;
	
	"aarch64")
		wget -q --no-check-certificate "https://github.com/pawn-team/Termux-Pawn/releases/download/aarch64/termux-pawn-${1,,}_3.10.10_aarch64.deb"
		dpkg -i "termux-pawn-${1,,}_3.10.10_aarch64.deb" &> /dev/null
		;;
	
	*)
		echo -e "\033[1;31m      FAIL:    \033[0;37mYour machine is not compatible!"
		echo -e "\033[1;31m      ERRO:    \033[0;37mSua máquina não é compatível!"
		exit 1
		;;
esac

rm termux-pawn-*.deb

mkdir -p $EXTERNAL_STORAGE/Termux-Pawn
git clone -q https://github.com/pawn-lang/samp-stdlib
git clone -q https://github.com/pawn-lang/pawn-stdlib
mv samp-stdlib/*.inc $EXTERNAL_STORAGE/Termux-Pawn
mv pawn-stdlib/*.inc $EXTERNAL_STORAGE/Termux-Pawn
rm -rf samp-stdlib pawn-stdlib

mkdir $PREFIX/Termux-Pawn
echo "-Z+ -;+ -(+ -E+ -d3 -O0 -R+" > $PREFIX/Termux-Pawn/pawn.cfg

commands=$(curl -s https://raw.githubusercontent.com/pawn-team/Termux-Pawn/DeviceWhite/termux-pawn.sh)
echo "$commands" > $PREFIX/etc/profile.d/termux-pawn.sh

clear
echo -e "\n\033[1;33m>> \033[1;37mOpen the terminal again to update packages"
echo -e "\n\033[1;33m>> \033[1;37mAbra o terminal novamente para atualizar os pacotes"
bash -c "sleep 1 && kill -9 $PPID" & exit
