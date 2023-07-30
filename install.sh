#!/data/data/com.termux/files/usr/bin/env sh

# install repositories
pkg install x11-repo tur-repo -y

#  update repositories
yes | pkg  update -y && yes | pkg upgrade -y

# install packages
yes | pkg install cmake gcc-9 git make

# download project's
git clone https://github.com/Device-Black/Termux-Pawn $HOME/termux-pawn
git clone https://github.com/pawn-lang/compiler $HOME/compiler

# move folder
mv $HOME/termux-pawn/pawn-lang $HOME/storage/shared

# update a file from project
mv $HOME/termux-pawn/pawncc.c $HOME/compiler/source/compiler/

# compile project
mkdir -p $HOME/build && cd $HOME/build && cmake $HOME/compiler/source/compiler -DCMAKE_C_COMPILER=$PREFIX/bin/gcc-9 -DCMAKE_BUILD_TYPE=Release && make

# move lib file to main lib folder
mv $HOME/build/libpawnc.so $PREFIX/lib

# move bin file to main bin folder
mv $HOME/build/pawn* $PREFIX/bin

# delete all cache
rm -rf $HOME/build $HOME/compiler $HOME/termux-pawn

# clear all and credits
echo "\033c\033[32mCompilador instalado com sucesso!"
echo "\n\033[0m1: Observe que há uma pasta chamada \033[33m\"pawn-lang\" \033[0mna memoria interna!"
echo "\033[0m2: Utilize \033[33mcd /sdcard/pawn-lang \033[0mpara navegar para essa pasta!"
echo "\033[0m3: Utilize \033[33mpawncc <arquivo.pwn> \033[0mpara compilar um novo script!"
echo "\n\033[32mExemplo de Uso:\n\033[0mcd /sdcard/pawn-lang\n\033[0mpawncc gamemodes/new.pwn"
