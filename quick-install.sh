your_ip=$(curl https://freeipapi.com)
ip_info=$(curl https://freeipapi.com/api/json/$your_ip)

if echo "$ip_info" | grep -q "Could not resolve host"; then
	echo -e "\033[1;31mFAILED CONNECTION\033[0;37m"
else
	if echo "$ip_info" | grep -q "Brazil"; then
		wget https://raw.githubusercontent.com/pawn-team/Termux-Pawn/DeviceBlack/quick-install-ptbr.sh
		bash quick-install-ptbr.sh
		rm quick-install-ptbr.sh
	else
		wget https://raw.githubusercontent.com/pawn-team/Termux-Pawn/DeviceBlack/quick-install-enus.sh
		bash quick-install-enus.sh
		rm quick-install-enus.sh
	fi
fi