#!/data/data/com.termux/files/usr/bin/bash

# Define prefixos de saída para mensagens
ERROR="\033[1;31m[ \033[1;37m- \033[1;31m] \033[1;33m"
ALERT="\033[1;33m[ \033[1;37m- \033[1;33m] \033[1;36m"
NORMAL="\033[1;32m[ \033[1;37m- \033[1;32m] \033[1;34m"

# Verifica a versão do terminal Termux
if [ ! "$TERMUX_VERSION" = "0.118.0" ]; then
	echo -e "$ERROR Você precisa instalar instalar o Termux v0.118.0!"
	exit 1
fi


# Verificar permissão de acesso a memória externa
echo -e "$NORMAL Verificando acesso a memória externa..."
while true; do
	if [ ! -w "/sdcard" ]; then
		termux-setup-storage
		sleep 1
	else
		break
	fi
done


# Verificando arquitetura do dispositivo
MACHINE=$(uname -m)
echo -e "$NORMAL Sua arquitetura é: \033[0;37m$MACHINE\n"

BINARY_NAME="arm"
if [ "$MACHINE" = "aarch64" ]; then
	BINARY_NAME="aarch64"
fi


# Baixando os arquivos binários
echo -en "$ALERT Deseja baixar o compilador traduzido? \033[1;37m[ y | N ]"
read result

if [ "$result" = "y" ] || [ "$result" = "Y" ]; then
	wget -q "https://github.com/pawn-team/Termux-Pawn/releases/download/${MACHINE}/termux-pawn-ptbr_3.10.10_${BINARY_NAME}.deb" -O $HOME/termux-pawn.deb
else
	wget -q "https://github.com/pawn-team/Termux-Pawn/releases/download/${MACHINE}/termux-pawn-enus_3.10.10_${BINARY_NAME}.deb" -O $HOME/termux-pawn.deb
fi


# Verificando a integridade dos binários
AARCH64_PTBR="50c35bdf45165b333648cc498f4d414003eba6802485811d54a77a1b28123ea2"
AARCH64_ENUS="ac2dc1477437d424e5ce39d2a588db568a3be3613b13bb2862c170e9c9535f04"

ARMV8_PTBR="1595a31e02969a0c23c402ed3af3332784d8b9b55749c05b0443e564f0f6fca6"
ARMV8_ENUS="724389b253b1c67caf26655dc5398ba124e7f8a063c220b38915fc2231ff806a"

ARMV7_PTBR="0dfad8c568b4422d4b6d349bcda9b869206c6a2e46853209bfb97dd2249d5cb8"
ARMV7_ENUS="ff84ada07034a56b8cd4e127e8b72ef6cf86606b3bd49f8df7f79c13bb7b50af"

ARMHF_PTBR="729339afb85df9d9e030e92f2b48940bade545ba97d320f497a016bf58faea8c"
ARMHF_ENUS="d9a7c061c01459da8e29f20a3baae187db9e723c88500d6436ad6e48edbcf563"

CHECKSUM=$(sha256sum $HOME/termux-pawn.deb | awk '{print $1}')

case "$CHECKSUM" in
	"$AARCH64_PTBR" | "$AARCH64_ENUS" | "$ARMV8_PTBR" | "$ARMV8_ENUS" | "$ARMV7_PTBR" | "$ARMV7_ENUS" | "$ARMHF_PTBR" | "$ARMHF_ENUS")
		echo -e "$NORMAL Download concluído sem falhas!"
		;;
	
	*)
		echo -e "$ERROR Download concluído com falhas, não foi possivel completar a instalação!"
		exit 1
		;;
esac


# Instalando os arquivos binários
echo -e "$NORMAL Instalando os binários baixados"

dpkg -r termux-pawn-ptbr termux-pawn-enus &> /dev/null
dpkg -i $HOME/termux-pawn.deb &> /dev/null
rm -rf $HOME/termux-pawn.deb

echo "-Z+ -d3 -;+ -(+ -R+ -E+ -i:/sdcard/Pawn" > $PATH/pawn.cfg
echo "alias pawncc='pawncc @$PATH/pawn.cfg'" > $PREFIX/etc/termux-pawn.sh
echo "alias termux-pawn-remove='unalias pawncc && unalias termux-pawn-remove && dpkg -r termux-pawn-enus termux-pawn-ptbr &> /dev/null && rm -rf $PREFIX/etc/termux-pawn.sh'" >> $PREFIX/etc/termux-pawn.sh
echo "source $PREFIX/etc/termux-pawn.sh &> /dev/null" >> $PREFIX/etc/profile


# Baixando as bibliotecas
echo -en "\n$ALERT Deseja instalar includes para o Open.MP? \033[1;37m[ y | N ]"
read result

mkdir -p "/sdcard/Pawn"
rm -rf $HOME/omp-stdlib $HOME/pawn-stdlib $HOME/samp-stdlib

if [ "$result" = "y" ] || [ "$result" = "Y" ]; then
	git clone -q https://github.com/openmultiplayer/omp-stdlib $HOME/omp-stdlib 
	mv $HOME/omp-stdlib/*.inc /sdcard/Pawn
else
	git clone -q https://github.com/pawn-lang/samp-stdlib $HOME/samp-stdlib 
	git clone -q https://github.com/pawn-lang/pawn-stdlib $HOME/pawn-stdlib 
	mv $HOME/samp-stdlib/*.inc /sdcard/Pawn
	mv $HOME/pawn-stdlib/*.inc /sdcard/Pawn
fi

echo -e "$NORMAL Biblioteca Padrão instalada com sucesso!"


# Exibe dicas
echo -e "\n\n\033[1;33m>>>> DICAS:"
echo -e "\n\033[1;33m>> \033[1;37mAdicione suas includes na pasta: /sdcard/Pawn"
echo -e "\n\033[1;33m>> \033[1;37mVocê pode criar uma configuração para seu gamemode, utilize: cp -r \$PATH/pawn.cfg \$PWD"
echo -e "\n\033[1;33m>> \033[1;37mPara desinstalar, utilize: \033[1;36mtermux-pawn-remove"
echo -e "\n\033[1;33m>> \033[1;37mVocê pode enviar sugestões e reportar problemas para o email: devicewhite@proton.me\n\n\033[0;37m"
