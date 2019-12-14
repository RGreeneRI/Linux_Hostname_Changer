#!/bin/bash

# ****Tested on Ubuntu***

# Variables
OLD_HOSTNAME="`cat /etc/hostname`"

# Text Colors
NC='\033[0m'              # Text Reset
Black='\033[0;30m'        # Black
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Blue='\033[0;34m'         # Blue
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan
White='\033[0;37m'        # White

# Check if new hostname provided, and if root
if [ ! -n "$1" ]; then
	echo -e "${Red}Missed argument : new hostname${NC}"
	if [ "$(id -u)" != "0" ]; then
        	echo -e "${Red}Sorry, you are not root.${NC}"
	fi
	echo -e "${Yellow}Usage: chhostname.sh [NEW_HOSTNAME]${NC}"
	exit 1
fi

# Check if root
if [ "$(id -u)" != "0" ]; then
	echo -e "${Red}Sorry, you are not root.${NC}"
	exit 1
fi

# Prompt user to confirm hostname change
clear
echo -e "${Cyan}Would you like to change your hostname from \"${Yellow}$OLD_HOSTNAME${Cyan}\" to \"${Yellow}$1${Cyan}\"?${NC}"
echo -e "${Cyan}Please answer ${Green}Yes${Cyan} or ${Red}No${Cyan}...${NC}"
#read -r key
while true; do
    read yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) exit 0;;
        * ) echo -e "${Red}Please answer Y or N.${NC}";;
    esac
done

# Change hostname
sed -i "s/$OLD_HOSTNAME/$1/g" /etc/hosts
sed -i "s/$OLD_HOSTNAME/$1/g" /etc/hostname

# Prompt for reboot or not
echo -e "${Yellow}Would you like to reboot for the hostname to take effect? Yes / No?${NC}"
while true; do
    read yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) exit 0;;
        * ) echo -e "${Red}Please answer Y or N.${NC}";;
    esac
done

# Reboot
echo -e "${Cyan}Rebooting...${NC}"
reboot
