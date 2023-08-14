#!/data/data/com.termux/files/usr/bin/bash

# Configuracao Inicial
clear
tput civis
termux-setup-storage -y &> /dev/null

# Separador de Linha
function linebreaker {
	for i in $(seq 1 $(tput cols)); do
		echo -en "\033[1m\033[35m=\033[0m"
	done
}

# Sinalizar os Creditos
linebreaker
echo -e "\033[1m\033[32mPROJETO: \033[37mTermux-Pawn"
echo -e "\033[1m\033[32mAUTORES: \033[37mBeerlID e DeviceBlack"
linebreaker

# Atualizar os Pacotes
echo -en "\033[1m\033[32m[\033[37m+\033[32m] \033[33mAtualizando pacotes............................ \033[32m[\033[37m**\033[32m]"
yes | pkg update -y &> /dev/null
yes | pkg upgrade -y &> /dev/null
echo -e "\b\b\b\033[1m\033[37mOK\033[32m]"

# Instalar os Repositorios
echo -en "\033[1m\033[32m[\033[37m+\033[32m] \033[33mInstalando repositorio x11-repo................ \033[32m[\033[37m**\033[32m]"
pkg install x11-repo -y &> /dev/null
echo -e "\b\b\b\033[1m\033[37mOK\033[32m]"

echo -en "\033[1m\033[32m[\033[37m+\033[32m] \033[33mInstalando repositorio tur-repo................ \033[32m[\033[37m**\033[32m]"
pkg install tur-repo -y &> /dev/null
echo -e "\b\b\b\033[1m\033[37mOK\033[32m]"

# Atualizar os Repositorios
echo -en "\033[1m\033[32m[\033[37m+\033[32m] \033[33mAtualizando repositorios....................... \033[32m[\033[37m**\033[32m]"
yes | pkg update -y &> /dev/null
yes | pkg upgrade -y &> /dev/null
echo -e "\b\b\b\033[1m\033[37mOK\033[32m]"

# Instalar os Pacotes
echo -en "\033[1m\033[32m[\033[37m+\033[32m] \033[33mInstalando pacote cmake........................ \033[32m[\033[37m**\033[32m]"
pkg install cmake -y &> /dev/null
echo -e "\b\b\b\033[1m\033[37mOK\033[32m]"

echo -en "\033[1m\033[32m[\033[37m+\033[32m] \033[33mInstalando pacote gcc-9........................ \033[32m[\033[37m**\033[32m]"
pkg install gcc-9 -y &> /dev/null
echo -e "\b\b\b\033[1m\033[37mOK\033[32m]"

echo -en "\033[1m\033[32m[\033[37m+\033[32m] \033[33mInstalando pacote git.......................... \033[32m[\033[37m**\033[32m]"
pkg install git -y &> /dev/null
echo -e "\b\b\b\033[1m\033[37mOK\033[32m]"

echo -en "\033[1m\033[32m[\033[37m+\033[32m] \033[33mInstalando pacote make......................... \033[32m[\033[37m**\033[32m]"
pkg install make -y &> /dev/null
echo -e "\b\b\b\033[1m\033[37mOK\033[32m]"

echo -en "\033[1m\033[32m[\033[37m+\033[32m] \033[33mBaixando repositorio Device-Black/Termux-Pawn.. \033[32m[\033[37m**\033[32m]"
git clone https://github.com/device-black/termux-pawn $HOME/Termux-Pawn -q
echo -e "\b\b\b\033[1m\033[37mOK\033[32m]"

echo -en "\033[1m\033[32m[\033[37m+\033[32m] \033[33mBaixando repositorio pawn-lang/compiler........ \033[32m[\033[37m**\033[32m]"
git clone https://github.com/pawn-lang/compiler $HOME/compiler -q
mv $HOME/Termux-Pawn/pawncc.c $HOME/compiler/source/compiler/ &> /dev/null
echo -e "\b\b\b\033[1m\033[37mOK\033[32m]"

# Sugerir Tradução
echo -en "\033[1m\033[32m[\033[37m+\033[32m] \033[35mDeseja instalar o compilador traduzido? (BETA) \033[37m[y/N] "
read translate

if [ "$translate" = "y" ] || [ "$translate" = "Y" ]; then
	mv $HOME/Termux-Pawn/libpawnc.c $HOME/compiler/source/compiler/ &> /dev/null
	mv $HOME/Termux-Pawn/sc1.c $HOME/compiler/source/compiler/ &> /dev/null
	mv $HOME/Termux-Pawn/sc5.c $HOME/compiler/source/compiler/ &> /dev/null
fi

# Construir o Compilador
echo -en "\033[1m\033[32m[\033[37m+\033[32m] \033[33mConstruindo o compilador [1/2]................. \033[32m[\033[37m**\033[32m]"
mkdir -p $HOME/compiler/build && cd $HOME/compiler/build
cmake $HOME/compiler/source/compiler -DCMAKE_C_COMPILER=$PREFIX/bin/gcc-9 -DCMAKE_BUILD_TYPE=Release &> /dev/null
echo -e "\b\b\b\033[1m\033[37mOK\033[32m]"

echo -en "\033[1m\033[32m[\033[37m+\033[32m] \033[33mConstruindo o compilador [2/2]................. \033[32m[\033[37m**\033[32m]"
make &> /dev/null
echo -e "\b\b\b\033[1m\033[37mOK\033[32m]"

# Instalando os Programas
echo -en "\033[1m\033[32m[\033[37m+\033[32m] \033[33mInstalando o comando pawncc.................... \033[32m[\033[37m**\033[32m]"
mv $HOME/compiler/build/pawncc $PREFIX/bin/ &> /dev/null
echo -e "\b\b\b\033[1m\033[37mOK\033[32m]"

echo -en "\033[1m\033[32m[\033[37m+\033[32m] \033[33mInstalando o comando pawndisasm................ \033[32m[\033[37m**\033[32m]"
mv $HOME/compiler/build/pawndisasm $PREFIX/bin/ &> /dev/null
echo -e "\b\b\b\033[1m\033[37mOK\033[32m]"

echo -en "\033[1m\033[32m[\033[37m+\033[32m] \033[33mInstalando o comando pawnruns.................. \033[32m[\033[37m**\033[32m]"
mv $HOME/compiler/build/pawnruns $PREFIX/bin/ &> /dev/null
echo -e "\b\b\b\033[1m\033[37mOK\033[32m]"

echo -en "\033[1m\033[32m[\033[37m+\033[32m] \033[33mInstalando a biblioteca libpawnc.so............ \033[32m[\033[37m**\033[32m]"
mv $HOME/compiler/build/libpawnc.so $PREFIX/lib/ &> /dev/null
echo -e "\b\b\b\033[1m\033[37mOK\033[32m]"

# Movendo a Pasta do Projeto
echo -en "\033[1m\033[32m[\033[37m+\033[32m] \033[33mMovendo a pasta pawn-lang para o sdcard........ \033[32m[\033[37m**\033[32m]"
mv $HOME/Termux-Pawn/pawn-lang /storage/emulated/0/ &> /dev/null
echo -e "\b\b\b\033[1m\033[37mOK\033[32m]"

# Limpando o Cache
echo -en "\033[1m\033[32m[\033[37m+\033[32m] \033[33mLimpando o cache restante...................... \033[32m[\033[37m**\033[32m]"
rm -rf $HOME/Termux-Pawn $HOME/compiler &> /dev/null
echo -e "\b\b\b\033[1m\033[37mOK\033[32m]"

# Como Usar
linebreaker
echo -e "\033[1m\033[32mCompilador instalado com sucesso!\n"
echo -e "\033[0m\033[1m- Observe que a pasta \033[33m\"pawn-lang\" \033[37mreside na memoria interna!"
echo -e "\033[0m\033[1m- Utilize \033[33mcd /sdcard/pawn-lang \033[37mpara navegar ate a pasta!"
echo -e "\033[0m\033[1m- Utilize \033[33mpawncc <arquivo.pwn> \033[37mpara compilar algum script!\n"
echo -e "\033[1m\033[32mExemplo de Uso:"
echo -e "\033[0m\033[1mcd /sdcard/pawn-lang"
echo -e "\033[0m\033[1mpawncc gamemodes/new.pwn"
linebreaker

# Restaurar o Cursor
tput cnorm
