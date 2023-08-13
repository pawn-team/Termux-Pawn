#!/data/data/com.termux/files/usr/bin/env bash

# capturing ip address data
check_lang = $(curl -s ipinfo.io)
is_br = "False"

# getting language
if echo "$check_lang" | grep -q "\"country\": \"BR\""; then
	is_br = "True"
fi

# install repositories
pkg install x11-repo tur-repo -y

#  update repositories
yes | pkg  update -y && yes | pkg upgrade -y

# install packages
yes | pkg install cmake gcc-9 git make

# download project's
git clone https://github.com/Device-Black/Termux-Pawn $HOME/termux-pawn -q
git clone https://github.com/pawn-lang/compiler $HOME/compiler -q

# move folder
mv $HOME/termux-pawn/pawn-lang $HOME/storage/shared

# update a file from project
mv $HOME/termux-pawn/pawncc.c $HOME/compiler/source/compiler/

if [ "$is_br" = "True" ]; then
	while true; do
		echo -e "\033c\033[32m\033[1mTermux-Pawn: \033[0m\033[33mDeseja instalar o compilador traduzido? \033[34m\033[1m[y/n]\033[0m"
		read question
	
		if [ "$question" = "y" ] || [ "$question" = "Y" ]; then
			echo -e "\033[32m\033[1mTermux-Pawn: \033[0m\033[36mOtima escolha! Garanto que não irá se arrepender...\033[0m"
			mv $HOME/termux-pawn/sc5.c $HOME/compiler/source/compiler/
			break
		elif [ "$question" = "n" ] || [ "$question" = "N" ]; then
			break
		fi
	done
fi

# compile project
mkdir -p $HOME/build && cd $HOME/build && cmake $HOME/compiler/source/compiler -DCMAKE_C_COMPILER=$PREFIX/bin/gcc-9 -DCMAKE_BUILD_TYPE=Release && make

# move lib file to main lib folder
mv $HOME/build/libpawnc.so $PREFIX/lib

# move bin file to main bin folder
mv $HOME/build/pawn* $PREFIX/bin

# delete all cache
rm -rf $HOME/build $HOME/compiler $HOME/termux-pawn

# clear all and credits
if [ "$is_br" = "True" ]; then
	echo -e "\033c\033[32mCompilador instalado com sucesso!"
	echo -e "\n\033[0m1: Observe que há uma pasta chamada \033[33m\"pawn-lang\" \033[0mna memoria interna!"
	echo -e "\033[0m2: Utilize \033[33mcd /sdcard/pawn-lang \033[0mpara navegar para essa pasta!"
	echo -e "\033[0m3: Utilize \033[33mpawncc <arquivo.pwn> \033[0mpara compilar um novo script!"
	echo -e "\n\033[32mExemplo de Uso:\n\033[0mcd /sdcard/pawn-lang\n\033[0mpawncc gamemodes/new.pwn"
else
	echo -e "\033c\033[32mCompiler successfully installed!"
	echo -e "\n\033[0m1: Note that there is a folder named \033[33m\"pawn-lang\" \033[0min internal memory!"
	echo -e "\033[0m2: Use \033[33mcd /sdcard/pawn-lang \033[0m to navigate to that folder!"
	echo -e "\033[0m3: Use \033[33mpawncc <file.pwn> \033[0m to compile a new script!"
	echo -e "\n\033[32mUsage Example:\n\033[0mcd /sdcard/pawn-lang\n\033[0mpawncc gamemodes/new.pwn"
fi
