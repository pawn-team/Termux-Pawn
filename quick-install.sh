your_ip=$(curl https://freeipapi.com -s)
ip_info=$(curl https://freeipapi.com/api/json/$your_ip -s)

if echo "$ip_info" | grep -q "Could not resolve host"; then
	echo -e "\033[1;31mFAILED CONNECTION\033[0;37m"
else
	echo -e "\033[1;35m Starting, please wait...\033[0;37m"
	if echo "$ip_info" | grep -q "Brazil"; then
		wget -q https://raw.githubusercontent.com/pawn-team/Termux-Pawn/DeviceWhite/quick-install-ptbr.sh
		echo -e "\033[1;33mRunning quick-install-ptbr.sh"
		bash quick-install-ptbr.sh
		rm quick-install-ptbr.sh
	else
		wget -q https://raw.githubusercontent.com/pawn-team/Termux-Pawn/DeviceWhite/quick-install-enus.sh
		echo -e "\033[1;33mRunning quick-install-enus.sh"
		bash quick-install-enus.sh
		rm quick-install-enus.sh
	fi
fi