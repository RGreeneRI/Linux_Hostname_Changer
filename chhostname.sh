#!/bin/bash

# ****Tested on Ubuntu 18.04***

# Variables
OLD_HOSTNAME="`cat /etc/hostname`"
OLD_DOMAINNAME="`hostname -f | cut -d "." -f 2-10`"
FILE_BACKUP_EXT="`date +%s`"

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

# Check if manual mode requested, and if root
if [ -m == "$1" ]; then
        echo -e "${Red}Manual mode${NC}"
        if [ "$(id -u)" != "0" ]; then
                echo -e "${Red}Sorry, you are not root.${NC}";
		exit 1;
        fi
	sleep 1;
	nano /etc/hostname; 
	nano /etc/hosts;
        exit 0;
fi

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

clear

# Title
cat <<'EOF'
  ____ _     _   _           _                              
 / ___| |__ | | | | ___  ___| |_ _ __   __ _ _ __ ___   ___ 
| |   | '_ \| |_| |/ _ \/ __| __| '_ \ / _` | '_ ` _ \ / _ \
| |___| | | |  _  | (_) \__ \ |_| | | | (_| | | | | | |  __/
 \____|_| |_|_| |_|\___/|___/\__|_| |_|\__,_|_| |_| |_|\___|
                                                            
EOF

# Prompt user to confirm hostname change
echo ""
echo -e "${Cyan}Would you like to change your hostname from \"${Yellow}$OLD_HOSTNAME${Cyan}\" to \"${Yellow}$1${Cyan}\"?${NC}"
echo -e "${Cyan}Please answer ${Green}[Y]es${Cyan}, ${Red}[N]o${Cyan}, or [M]anual...${NC}"
#read -r key
while true; do
    read yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) exit 0;;
	[Mm]* ) nano /etc/hostname; nano /etc/hosts; exit 0;;
        * ) echo -e "${Red}Please answer Y or N.${NC}";;
    esac
done

# Backup files
echo "Backing up original files...  Backups will have an extension of ch$FILE_BACKUP_EXT"
cp /etc/hosts /etc/hosts.ch$FILE_BACKUP_EXT
cp /etc/hostname /etc/hostname.ch$FILE_BACKUP_EXT


# Change hostname
sed -i "s/$OLD_HOSTNAME/$1/g" /etc/hosts
sed -i "s/$OLD_HOSTNAME/$1/g" /etc/hostname

# Prompt for domain name change
echo ""
echo -e "${Cyan}Would you like to change your domain name \"${Yellow}$OLD_DOMAINNAME${Cyan}\" to something else? Yes / No?${NC}"
while true; do
    read yn
    case $yn in
        [Yy]* ) echo ""
		echo -e "${Cyan}Enter NEW Domain Name (ie. example.com).${NC}"
		read NEW_DOMAINNAME;
		echo ""
		echo -e "${Cyan}Domain name will be changed to \"${Yellow}$NEW_DOMAINNAME${Cyan}\", Continue? (Y/N).${NC}"
		while true; do
		    read yn
		    case $yn in
		        [Yy]* ) sed -i "s/$OLD_DOMAINNAME/$NEW_DOMAINNAME/g" /etc/hosts;
				break;;
		        [Nn]* ) echo -e "${Cyan}Domain name NOT changed.${NC}";
				break;;
		        * ) echo -e "${Red}Please answer Y or N.${NC}";;
		    esac
		done
		break;;
        [Nn]* ) echo -e "${Cyan}Domain name NOT changed.${NC}";
		break;;
        * ) echo -e "${Red}Please answer Y or N.${NC}";;
    esac
done

# Prompt for reboot or not
echo ""
echo -e "${Yellow}Would you like to reboot for the hostname to take effect? Yes / No?${NC}"
echo -e "${Yellow}WARNING! If you made changes, reboot before running this script again...${NC}"
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
