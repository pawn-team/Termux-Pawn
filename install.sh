#!/data/data/com.termux/files/usr/bin/bash

### MOSTRAR OS CREDITOS DO PROJETO
echo  "\033[32m\033[1mPROJETO: \033[0mTermux-Pawn"
echo  "\033[32m\033[1mAUTORIA: \033[0mBeerlID e DeviceBlack"
echo  "\033[32m\033[1mGITHUB: \033[0mhttps://github.com/Device-Black/Termux-Pawn"


### MOSTRAR OS CREDITOS DO COMPILADOR
echo  "\033[32m\033[1mORIGINAL: \033[0mCompuPhase"
echo  "\033[32m\033[1mGITHUB: \033[0mhttps://github.com/compuphase/pawn"
echo  "\n\033[32m\033[1mMODIFIED: \033[0mPawn-Lang"
echo  "\033[32m\033[1mGITHUB: \033[0mhttps://github.com/pawn-lang/compiler"

### VERIFICAR ACESSO AO ARMAZENAMENTO INTERNO
rm -rf $HOME/storage && termux-setup-storage
echo  "\033[1m\033[32m[\033[37m+\033[32m] \033[33mVoce precisa permitir o acesso a memória interna!"
echo  "\033[1m\033[32m[\033[37m+\033[32m] \033[33mPressione a tecla \033[37mENTER \033[33mpara prosseguir..."
read nullable

### VERIFICAR A COMPOSICAO ATUAL DO TERMINAL
echo n "\033[1m\033[32m[\033[37m+\033[32m] \033[33mAtualizando pacotes do terminal:   "
(yes | pkg upd -y && yes | pkg upg -y) &> /dev/null
echo  "\033[1m\033[32mOK\033[0m"

### INSTALAR REPOSITORIO ESPECIAIS
echo n "\033[1m\033[32m[\033[37m+\033[32m] \033[33mInstalando o repositório \"\033[37mx11-repo\033[33m\"   "
pkg install x11-repo -y &> /dev/null
echo  "\033[1m\033[32mOK\033[0m"

echo n "\033[1m\033[32m[\033[37m+\033[32m] \033[33mInstalando o repositório \"\033[37mtur-repo\033[33m\"   "
pkg install tur-repo -y &> /dev/null
echo  "\033[1m\033[32mOK\033[0m"

### ATUALIZAR OS PACOTES DOS REPOSITORIOS
echo n "\033[1m\033[32m[\033[37m+\033[32m] \033[33mAtualizando pacotes do terminal novamente:   "
(yes | pkg upd -y && yes | pkg upg -y) &> /dev/null
echo  "\033[1m\033[32mOK\033[0m"

### INSTALAR OS PACOTES PARA CONSTRUCAO
echo n "\033[1m\033[32m[\033[37m+\033[32m] \033[33mInstalando o pacote \"\033[37mcmake\033[33m\"   "
pkg install cmake -y &> /dev/null
echo  "\033[1m\033[32mOK\033[0m"

echo n "\033[1m\033[32m[\033[37m+\033[32m] \033[33mInstalando o pacote \"\033[37mgcc-9\033[33m\"   "
pkg install gcc-9 -y &> /dev/null
echo  "\033[1m\033[32mOK\033[0m"

echo n "\033[1m\033[32m[\033[37m+\033[32m] \033[33mInstalando o pacote \"\033[37mgit\033[33m\"   "
pkg install git -y &> /dev/null
echo  "\033[1m\033[32mOK\033[0m"

echo n "\033[1m\033[32m[\033[37m+\033[32m] \033[33mInstalando o pacote \"\033[37mmake\033[33m\"   "
pkg install make -y &> /dev/null
echo  "\033[1m\033[32mOK\033[0m"

### BAIXAR OS REPOSITORIOS
echo n "\033[1m\033[32m[\033[37m+\033[32m] \033[33mBaixando o repositório \"\033[37mDevice-Black/Termux-Pawn\033[33m\"   "
git clone https://github.com/Device-Black/Termux-Pawn $HOME/termux-pawn -q
echo  "\033[1m\033[32mOK\033[0m"

echo n "\033[1m\033[32m[\033[37m+\033[32m] \033[33mBaixando o repositório \"\033[37mpawn-lang/compiler\033[33m\"   "
git clone https://github.com/pawn-lang/compiler $HOME/compiler -q
mv $HOME/termux-pawn/pawncc.c $HOME/compiler/source/compiler/
echo  "\033[1m\033[32mOK\033[0m"

### MOVER A PASTA PAWN-LANG
echo n "\033[1m\033[32m[\033[37m+\033[32m] \033[33mMovendo a pasta \"\033[37mpawn-lang\033[33m\"   "
cp -r $HOME/termux-pawn/pawn-lang $HOME/sdcard
echo  "\033[1m\033[32mOK\033[0m"

### PERGUNTAR SOBRE A TRADUCAO
echo n "\033[1m\033[32m[\033[37m+\033[32m] \033[33mDeseja instalar o compilador traduzido? \033[37m[y/N] "
read response

if [ "$response" = "y" ] || [ "$response" = "Y" ]; then
	mv $HOME/termux-pawn/libpawnc.c $HOME/compiler/source/compiler/
	mv $HOME/termux-pawn/sc1.c $HOME/compiler/source/compiler/
	mv $HOME/termux-pawn/sc5.c $HOME/compiler/source/compiler/
fi

### COMPILAR O CODIGO FONTE
echo n "\033[1m\033[32m[\033[37m+\033[32m] \033[33mConstruindo o compilador, aguarde...   "
(mkdir -p $HOME/build && cd $HOME/build && cmake $HOME/compiler/source/compiler -DCMAKE_C_COMPILER=$PREFIX/bin/gcc-9 -DCMAKE_BUILD_TYPE=Release && make) &> /dev/null
echo  "\033[1m\033[32mOK\033[0m"

### MOVER OS ARQUIVOS COMPILADOS
echo n "\033[1m\033[32m[\033[37m+\033[32m] \033[33mMovendo o arquivo \"\033[37mlibpawnc.so\033[33m\"   "
mv $HOME/build/libpawnc.so $PREFIX/lib
echo  "\033[1m\033[32mOK\033[0m"

echo n "\033[1m\033[32m[\033[37m+\033[32m] \033[33mMovendo o arquivo \"\033[37mpawncc\033[33m\"   "
mv $HOME/build/pawncc $PREFIX/bin
echo  "\033[1m\033[32mOK\033[0m"

echo n "\033[1m\033[32m[\033[37m+\033[32m] \033[33mMovendo o arquivo \"\033[37mpawndisasm\033[33m\"   "
mv $HOME/build/pawndisasm $PREFIX/bin
echo  "\033[1m\033[32mOK\033[0m"

echo n "\033[1m\033[32m[\033[37m+\033[32m] \033[33mMovendo o arquivo \"\033[37mpawnruns\033[33m\"   "
mv $HOME/build/pawnruns $PREFIX/bin
echo  "\033[1m\033[32mOK\033[0m"

### REMOVER O CACHE RESTANTE
echo n "\033[1m\033[32m[\033[37m+\033[32m] \033[33mRemovendo o cache restante, aguarde...   "
rm -rf $HOME/build $HOME/compiler $HOME/termux-pawn
echo  "\033[1m\033[32mOK\033[0m"


### FINALIZAR COM UM PEQUENO EXEMPLO DE USO
echo  "\033[1m\033[32mCompilador instalado com sucesso!\n"
echo  "\033[1m\033[37m- Observe que a pasta \033[33m\"pawn-lang\" \033[0mreside na memoria interna!"
echo  "\033[1m\033[37m- Utilize \033[33mcd /sdcard/pawn-lang \033[37mpara navegar até a pasta!"
echo  "\033[1m\033[37m- Utilize \033[33mpawncc <arquivo.pwn> \033[37mpara compilar algum script!"
echo  "\n\033[1m\033[32mExemplo de Uso:\n\033[37mcd /sdcard/pawn-lang\npawncc gamemodes/new.pwn"
