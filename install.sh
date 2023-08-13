#!/data/data/com.termux/files/usr/bin/env bash

### LINHA DE SEPARACAO
clear
for ((i=0; i < $(tput cols); i++)); do
	line_char+="="
done
line_sep=$(echo -e "\033[35m\033[1m$line_char\033[0m")
echo -e "$line_sep"

### MOSTRAR OS CREDITOS DO PROJETO
echo -e "\033[32m\033[1mPROJETO: \033[0mTermux-Pawn"
echo -e "\033[32m\033[1mAUTORIA: \033[0mBeerlID e DeviceBlack"
echo -e "\033[32m\033[1mGITHUB: \033[0mhttps://github.com/Device-Black/Termux-Pawn"
echo -e "$line_sep"

### MOSTRAR OS CREDITOS DO COMPILADOR
echo -e "\033[32m\033[1mORIGINAL: \033[0mCompuPhase"
echo -e "\033[32m\033[1mGITHUB: \033[0mhttps://github.com/compuphase/pawn"
echo -e "\n\033[32m\033[1mMODIFIED: \033[0mPawn-Lang"
echo -e "\033[32m\033[1mGITHUB: \033[0mhttps://github.com/pawn-lang/compiler"
echo -e "$line_sep"

### VERIFICAR ACESSO AO ARMAZENAMENTO INTERNO
rm -rf $HOME/storage && termux-setup-storage
echo -e "\033[1m\033[32m[\033[37m+\033[32m] \033[33mVoce precisa permitir o acesso a memória interna!"
echo -e "\033[1m\033[32m[\033[37m+\033[32m] \033[33mPressione a tecla \033[37mENTER \033[33mpara prosseguir..."
read nullable

### VERIFICAR A COMPOSICAO ATUAL DO TERMINAL
echo -en "\033[1m\033[32m[\033[37m+\033[32m] \033[33mAtualizando pacotes do terminal:   "
(yes | pkg upd -y && yes | pkg upg -y) &> /dev/null
echo -e "\033[1m\033[32mOK\033[0m"

### INSTALAR REPOSITORIO ESPECIAIS
echo -en "\033[1m\033[32m[\033[37m+\033[32m] \033[33mInstalando o repositório \"\033[37mx11-repo\033[33m\"   "
pkg install x11-repo -y &> /dev/null
echo -e "\033[1m\033[32mOK\033[0m"

echo -en "\033[1m\033[32m[\033[37m+\033[32m] \033[33mInstalando o repositório \"\033[37mtur-repo\033[33m\"   "
pkg install tur-repo -y &> /dev/null
echo -e "\033[1m\033[32mOK\033[0m"

### ATUALIZAR OS PACOTES DOS REPOSITORIOS
echo -en "\033[1m\033[32m[\033[37m+\033[32m] \033[33mAtualizando pacotes do terminal novamente:   "
(yes | pkg upd -y && yes | pkg upg -y) &> /dev/null
echo -e "\033[1m\033[32mOK\033[0m"

### INSTALAR OS PACOTES PARA CONSTRUCAO
echo -en "\033[1m\033[32m[\033[37m+\033[32m] \033[33mInstalando o pacote \"\033[37mcmake\033[33m\"   "
pkg install cmake -y &> /dev/null
echo -e "\033[1m\033[32mOK\033[0m"

echo -en "\033[1m\033[32m[\033[37m+\033[32m] \033[33mInstalando o pacote \"\033[37mgcc-9\033[33m\"   "
pkg install gcc-9 -y &> /dev/null
echo -e "\033[1m\033[32mOK\033[0m"

echo -en "\033[1m\033[32m[\033[37m+\033[32m] \033[33mInstalando o pacote \"\033[37mgit\033[33m\"   "
pkg install git -y &> /dev/null
echo -e "\033[1m\033[32mOK\033[0m"

echo -en "\033[1m\033[32m[\033[37m+\033[32m] \033[33mInstalando o pacote \"\033[37mmake\033[33m\"   "
pkg install make -y &> /dev/null
echo -e "\033[1m\033[32mOK\033[0m"

### BAIXAR OS REPOSITORIOS
echo -en "\033[1m\033[32m[\033[37m+\033[32m] \033[33mBaixando o repositório \"\033[37mDevice-Black/Termux-Pawn\033[33m\"   "
git clone https://github.com/Device-Black/Termux-Pawn $HOME/termux-pawn -q
echo -e "\033[1m\033[32mOK\033[0m"

echo -en "\033[1m\033[32m[\033[37m+\033[32m] \033[33mBaixando o repositório \"\033[37mpawn-lang/compiler\033[33m\"   "
git clone https://github.com/pawn-lang/compiler $HOME/compiler -q
mv $HOME/termux-pawn/pawncc.c $HOME/compiler/source/compiler/
echo -e "\033[1m\033[32mOK\033[0m"

### MOVER A PASTA PAWN-LANG
echo -en "\033[1m\033[32m[\033[37m+\033[32m] \033[33mMovendo a pasta \"\033[37mpawn-lang\033[33m\"   "
cp -r $HOME/termux-pawn/pawn-lang $HOME/sdcard
echo -e "\033[1m\033[32mOK\033[0m"

### PERGUNTAR SOBRE A TRADUCAO
echo -en "\033[1m\033[32m[\033[37m+\033[32m] \033[33mDeseja instalar o compilador traduzido? \033[37m[y/N] "
read response

if [ "$response" = "y" ] || [ "$response" = "Y" ]; then
	mv $HOME/termux-pawn/sc1.c $HOME/compiler/source/compiler/
	mv $HOME/termux-pawn/sc5.c $HOME/compiler/source/compiler/
fi

### COMPILAR O CODIGO FONTE
echo -en "\033[1m\033[32m[\033[37m+\033[32m] \033[33mConstruindo o compilador, aguarde...   "
(mkdir -p $HOME/build && cd $HOME/build && cmake $HOME/compiler/source/compiler -DCMAKE_C_COMPILER=$PREFIX/bin/gcc-9 -DCMAKE_BUILD_TYPE=Release && make) &> /dev/null
echo -e "\033[1m\033[32mOK\033[0m"

### MOVER OS ARQUIVOS COMPILADOS
echo -en "\033[1m\033[32m[\033[37m+\033[32m] \033[33mMovendo o arquivo \"\033[37mlibpawnc.so\033[33m\"   "
mv $HOME/build/libpawnc.so $PREFIX/lib
echo -e "\033[1m\033[32mOK\033[0m"

echo -en "\033[1m\033[32m[\033[37m+\033[32m] \033[33mMovendo o arquivo \"\033[37mpawncc\033[33m\"   "
mv $HOME/build/pawncc $PREFIX/bin
echo -e "\033[1m\033[32mOK\033[0m"

echo -en "\033[1m\033[32m[\033[37m+\033[32m] \033[33mMovendo o arquivo \"\033[37mpawndisasm\033[33m\"   "
mv $HOME/build/pawndisasm $PREFIX/bin
echo -e "\033[1m\033[32mOK\033[0m"

echo -en "\033[1m\033[32m[\033[37m+\033[32m] \033[33mMovendo o arquivo \"\033[37mpawnruns\033[33m\"   "
mv $HOME/build/pawnruns $PREFIX/bin
echo -e "\033[1m\033[32mOK\033[0m"

### REMOVER O CACHE RESTANTE
echo -en "\033[1m\033[32m[\033[37m+\033[32m] \033[33mRemovendo o cache restante, aguarde...   "
rm -rf $HOME/build $HOME/compiler $HOME/termux-pawn
echo -e "\033[1m\033[32mOK\033[0m"
echo -e "$line_sep"

### FINALIZAR COM UM PEQUENO EXEMPLO DE USO
echo -e "\033[32mCompilador instalado com sucesso!"
echo -e "\n\033[0m1: Observe que há uma pasta chamada \033[33m\"pawn-lang\" \033[0mna memoria interna!"
echo -e "\033[0m2: Utilize \033[33mcd /sdcard/pawn-lang \033[0mpara navegar para essa pasta!"
echo -e "\033[0m3: Utilize \033[33mpawncc <arquivo.pwn> \033[0mpara compilar um novo script!"
echo -e "\n\033[32mExemplo de Uso:\n\033[0mcd /sdcard/pawn-lang\npawncc gamemodes/gm.pwn"
echo -e "$line_sep"
