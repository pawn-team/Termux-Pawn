


#!/data/data/com.termux/files/usr/bin/bash

# Define o diretorio principal
root="/data/data/com.termux/files/home"

# Define prefixos de saída para mensagens
prefix_ok="\033[1;32m[ \033[1;37m+ \033[1;32m]"
prefix_no="\033[1;31m[ \033[1;37m- \033[1;31m]"

# Instala os repositórios necessários
echo -e "${prefix_ok} \033[0;34mInstalando novos repositórios... \033[0;37m0%"
pkg i -y x11-repo tur-repo &> /dev/null

# Atualiza o ambiente do Termux
echo -e "${prefix_ok} \033[0;34mAtualizando o ambiente atual... \033[0;37m10%"
pkg update -y &> /dev/null
pkg upgrade -y &> /dev/null

# Instala os pacotes necessários
echo -e "${prefix_ok} \033[0;34mInstalando novos pacotes... \033[0;37m20%"
pkg i -y cmake gcc-9 make &> /dev/null

# Baixa o código fonte do compilador
git clone https://github.com/pawn-lang/compiler $root/compiler -q

# Baixa uma tradução para o compilador
if [ "$1" = "ptbr" ] || [ "$1" = "PTBR" ]; then
	curl https://raw.githubusercontent.com/pawn-team/Termux-Pawn/DeviceWhite/translation/sc1.c -s -O $root/compiler/source/compiler/sc1.c
	curl https://raw.githubusercontent.com/pawn-team/Termux-Pawn/DeviceWhite/translation/sc5.c -s -O $root/compiler/source/compiler/sc5.c
	curl https://raw.githubusercontent.com/pawn-team/Termux-Pawn/DeviceWhite/translation/libpawnc.c -s -O $root/compiler/source/compiler/libpawnc.c
fi


