#!/data/data/com.termux/files/usr/bin/bash

# Instala pacotes necessários
pkg i -y git wget &> /dev/null

# Define prefixos de saída para mensagens
prefix_ok="\033[1;32m[ \033[1;37m+ \033[1;32m]"
prefix_no="\033[1;31m[ \033[1;37m- \033[1;31m]"

# Verifica permissão de escrita para o armazenamento interno
if [ ! -w "/sdcard" ]; then
    echo -e "${prefix_no} \033[0;33mNão foi possível acessar a memória interna."
    echo -e "${prefix_no} \033[0;33mUtilize o comando: \033[0;37mtermux-setup-storage"
    exit 1
else
    mkdir -p /sdcard/Pawn/includes
fi

# Pergunta ao usuário se deseja baixar includes para o Open.MP
echo -e "${prefix_ok} \033[1;36mDeseja baixar includes para \033[1;37mOpen.MP\033[1;36m?"
echo -n -e "${prefix_ok} \033[1;36mDigite \033[1;37mSIM \033[1;36mou \033[1;37mNAO\033[1;36m: \033[0;37m"
read option

# Baixa e move includes com base na escolha do usuário
if [ "$option" = "SIM" ] || [ "$option" = "sim" ]; then
    # Baixa e move includes do Open.MP
    echo -e "${prefix_ok} \033[0;34mBaixando pawn-stdlib..."
    git clone -q https://github.com/openmultiplayer/omp-stdlib $HOME/omp-stdlib

    # Verifica se o download foi bem-sucedido
    if [ ! -w "${HOME}/omp-stdlib" ]; then
        echo -e "${prefix_no} \033[0;33mNão foi possível completar o download!"
        exit 1
    else
        echo -e "${prefix_ok} \033[0;34mpawn-stdlib baixado com sucesso..."
        mv $HOME/omp-stdlib/*.inc /sdcard/Pawn
        rm -rf $HOME/omp-stdlib
    fi
else
    # Baixa e move includes da biblioteca padrão do Pawn
    echo -e "${prefix_ok} \033[0;34mBaixando pawn-stdlib..."
    git clone -q https://github.com/pawn-lang/pawn-stdlib $HOME/pawn-stdlib

    # Verifica se o download foi bem-sucedido
    if [ ! -w "${HOME}/pawn-stdlib" ]; then
        echo -e "${prefix_no} \033[0;33mNão foi possível completar o download!"
        exit 1
    else
        echo -e "${prefix_ok} \033[0;34mpawn-stdlib baixado com sucesso..."
        mv $HOME/pawn-stdlib/*.inc /sdcard/Pawn
        rm -rf $HOME/pawn-stdlib
    fi

    # Baixa e move includes do SAMP
    echo -e "${prefix_ok} \033[0;34mBaixando samp-stdlib..."
    git clone -q https://github.com/pawn-lang/samp-stdlib $HOME/samp-stdlib

    # Verifica se o download foi bem-sucedido
    if [ ! -w "${HOME}/samp-stdlib" ]; then
        echo -e "${prefix_no} \033[0;33mNão foi possível completar o download!"
        exit 1
    else
        echo -e "${prefix_ok} \033[0;34msamp-stdlib baixado com sucesso..."
        mv $HOME/samp-stdlib/*.inc /sdcard/Pawn
        rm -rf $HOME/samp-stdlib
    fi
fi

# Remove versões anteriores do compilador Pawn
dpkg -r termux-pawn-enus termux-pawn-ptbr &> /dev/null

# Pergunta ao usuário se deseja instalar o compilador traduzido
echo -e "${prefix_ok} \033[1;36mDeseja instalar o compilador traduzido?"
echo -n -e "${prefix_ok} \033[1;36mDigite \033[1;37mSIM \033[1;36mou \033[1;37mNAO\033[1;36m: \033[0;37m"
read option

# Baixa o compilador traduzido com base na escolha do usuário
if [ "$option" = "SIM" ] || [ "$option" = "sim" ]; then
    # Baixa o compilador Pawn traduzido
    echo -e "${prefix_ok} \033[0;33mBaixando compilador pawn traduzido..."
    wget -q "https://github.com/pawn-team/Termux-Pawn/releases/download/$(uname -m)/termux-pawn-ptbr_3.10.10_$(uname -m).deb" -O $HOME/.termux-pawn.deb
else
    # Baixa a versão em inglês do compilador
    echo -e "${prefix_ok} \033[0;33mBaixando compilador pawn traduzido..."
    wget -q "https://github.com/pawn-team/Termux-Pawn/releases/download/$(uname -m)/termux-pawn-enus_3.10.10_${uname -m}.deb" -O $HOME/.termux-pawn.deb
fi

# Verifica se o download foi bem-sucedido
if [ ! -w "${HOME}/.termux-pawn.deb" ]; then
    echo -e "${prefix_no} \033[0;33mNão foi possível completar o download!"
    exit 1
else
    # Instala o compilador baixado
    echo -e "${prefix_ok} \033[0;34mCompilador baixado com sucesso..."
    dpkg -i $HOME/.termux-pawn.deb &> /dev/null
fi

rm -rf $HOME/.termux-pawn.deb
echo -e "${prefix_ok} \033[0;34mCompilador instalado com sucesso..."
if [ "$option" = "SIM" ] || [ "$option" = "sim" ]; then
    echo -e "${prefix_ok} \033[0;34mPara desinstalar utilize: \033[0;37mdpkg -r termux-pawn-ptbr"
else
    echo -e "${prefix_ok} \033[0;34mPara desinstalar utilize: \033[0;37mdpkg -r termux-pawn-enus"
fi

# Configura pawn.cfg e alias
echo "-Z+ -;+ -E+ -R+ -(+ -d3 -i:/sdcard/Pawn" > $PREFIX/bin/pawn.cfg

text_alias="alias pawncc='pawncc @$PREFIX/bin/pawn.cfg'"
profile_path="${PREFIX}/etc/profile"

# Verifica se o alias já existe no perfil
if grep -q "$text_alias" "$profile_path"; then
    # Remove o alias existente
    grep -v "$text_alias" "$profile_path" > .profile
    mv .profile $profile_path
fi

# Adiciona o novo alias ao perfil
echo ${text_alias} >> $profile_path

# Exibe dicas
echo -e "\n\n\033[1;33m>>>> DICAS:"
echo -e "\n\033[1;33m>> \033[1;37mAdicione suas includes na pasta: /sdcard/Pawn"
echo -e "\n\033[1;33m>> \033[1;37mVocê pode criar uma configuração para seu gamemode, utilize: cp -r \$PREFIX/bin/pawn.cfg \$PWD"
echo -e "\n\033[1;33m>> \033[1;37mVocê pode enviar sugestões e reportar problemas para o email: devicewhite@proton.me\n\n"
