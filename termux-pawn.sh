#!/data/data/com.termux/files/usr/bin/bash

function termux-pawn-config {
	nano $PREFIX/Termux-Pawn/pawn.cfg
}

function termux-pawn-remove {
	rm -rf $PREFIX/Termux-Pawn $EXTERNAL_STORAGE/Termux-Pawn $PREFIX/etc/profile.d/termux-pawn.sh
	dpkg -r termux-pawn-enus termux-pawn-ptbr &> /dev/null
	echo -e "\n\033[1;33m>> \033[1;37mCompiler uninstalled successfully"
	echo -e "\n\033[1;33m>> \033[1;37mCompilador desinstalado com sucesso"
}

function termux-pawn-check {
	res=$(curl -s "https://raw.githubusercontent.com/pawn-team/Termux-Pawn/DeviceWhite/2024-02-11%2001%3A10%3A21%20BRT.txt")
	if [ "$res" = "updated" ]; then
		echo -e "\n\033[1;33m>> \033[1;37mTermux-Pawn received an update, visit: \033[1;36mhttps://github.com/pawn-team/termux-pawn"
		echo -e "\n\033[1;33m>> \033[1;37mO Termux-Pawn recebeu uma atualização, acesse: \033[1;36mhttps://github.com/pawn-team/termux-pawn"
	fi
}

function termux-pawn-help {
	echo -e "\n\n\033[1;33m>>>> TIPS : DICAS"
	sleep 1
	
	echo -e "\n\033[1;33m>> \033[1;37mUse the command \033[1;36mtermux-pawn-help \033[1;37mto see this message"
	echo -e "\n\033[1;33m>> \033[1;37mUtilize o comando \033[1;36mtermux-pawn-help \033[1;37mpara ver essa mensagem"
	sleep 1
	
	echo -e "\n\033[1;33m>> \033[1;37mUse the command \033[1;36mtermux-pawn-config \033[1;37mto edit the compiler configuration"
	echo -e "\n\033[1;33m>> \033[1;37mUtilize o comando \033[1;36mtermux-pawn-config \033[1;37mpara editar a configuração do compilador"
	sleep 1
	
	echo -e "\n\033[1;33m>> \033[1;37mUse the command \033[1;36mtermux-pawn-check \033[1;37m to check if there has been an update"
	echo -e "\n\033[1;33m>> \033[1;37mUtilize o comando \033[1;36mtermux-pawn-check \033[1;37mpara verificar se houve alguma atualização"
	sleep 1
	
	echo -e "\n\033[1;33m>> \033[1;37mUse the command \033[1;36mtermux-pawn-remove \033[1;37m to uninstall the compiler"
	echo -e "\n\033[1;33m>> \033[1;37mUtilize o comando \033[1;36mtermux-pawn-remove \033[1;37mpara desinstalar o compilador"
	sleep 1
	
	echo -e "\n\033[1;33m>> \033[1;37mAdd your includes in the folder: \033[1;36m/sdcard/Termux-Pawn"
	echo -e "\n\033[1;33m>> \033[1;37mAdicione suas includes na pasta: \033[1;36m/sdcard/Termux-Pawn"
	sleep 1
	
	echo -e "\n\033[1;33m>> \033[1;37mYou can send suggestions and report issues to the email: \033[1;36mdevicewhite@proton.me"
	echo -e "\n\033[1;33m>> \033[1;37mVocê pode enviar sugestões e reportar problemas para o email: \033[1;36mdevicewhite@proton.me"
	sleep 1
	
	echo -e "\n\033[1;33m>> \033[1;37mFor more details, visit: \033[1;36mhttps://github.com/pawn-lang/compiler"
	echo -e "\n\033[1;33m>> \033[1;37mPara mais detalhes, acesse: \033[1;36mhttps://github.com/pawn-lang/compiler"
	sleep 1
}

alias pawncc='termux-pawn-check & pawncc @$PREFIX/Termux-Pawn/pawn.cfg'
	