#!/bin/bash

# A script to automate the changing of your hostname and  domain name.
# ****Tested on Ubuntu 18.04+***

# Variables
HN_FILE="/etc/hostname"
H_FILE="/etc/hosts"
OLD_HOSTNAME="`cat $HN_FILE`"
OLD_DOMAINNAME="`hostname -f | cut -d "." -f 2-10`"
BACKUP_EXT="ch`date +%s`"

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

# Check if help mode requested
if [ -h == "$1" ]; then
        echo -e "${Green}chhostname help:${NC}"
	echo ""
        echo -e "${Green}You must be root to make changes to your hostname and/or domain name...${NC}"
	echo ""
	echo -e "${Yellow}Usage:${NC}"
        echo -e "${Cyan}Change Hostname:            chhostname.sh [${Yellow}NEW_HOSTNAME${Cyan}]${NC}"
        echo -e "${Cyan}Help:                       chhostname.sh ${Yellow}-h${NC}"
        echo -e "${Cyan}List config file contents:  chhostname.sh ${Yellow}-l${NC}"
        echo -e "${Cyan}Manually edit config files: chhostname.sh ${Yellow}-m${NC}"
        exit 0;
fi

# Check if list mode requested
if [ -l == "$1" ]; then
        echo -e "${Red}Showing contents of config files below...${NC}"
        echo -e "${Yellow}-------Begin Contents of $HN_FILE-------${NC}";
        cat $HN_FILE;
        echo -e "${Yellow}-------End Contents of $HN_FILE---------${NC}";
        echo -e "${Cyan}-------Begin Contents of $H_FILE----------${NC}";
        cat $H_FILE;
        echo -e "${Cyan}-------End Contents of $H_FILE------------${NC}";
        exit 0;
fi

# Check if manual mode requested, and if root
if [ -m == "$1" ]; then
        echo -e "${Red}Manual mode${NC}"
        if [ "$(id -u)" != "0" ]; then
                echo -e "${Red}Sorry, you are not root.${NC}";
		exit 1;
        fi
	echo -e "${Yellow}Backing up original files...  Backups will have an extension of $BACKUP_EXT${NC}";
	cp $H_FILE $H_FILE.$BACKUP_EXT;
	cp $HN_FILE $HN_FILE.$BACKUP_EXT;
	sleep 1;
	nano $HN_FILE; 
	nano $H_FILE;
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
	[Mm]* ) echo "Backing up original files...  Backups will have an extension of $BACKUP_EXT"
		cp $H_FILE $H_FILE.$BACKUP_EXT;
		cp $HN_FILE $HN_FILE.$BACKUP_EXT;
		nano $HN_FILE;
		nano $H_FILE;
		exit 0;;
        * ) echo -e "${Red}Please answer Y or N.${NC}";;
    esac
done

# Backup files
echo "Backing up original files...  Backups will have an extension of $BACKUP_EXT"
cp $H_FILE $H_FILE.$BACKUP_EXT
cp $HN_FILE $HN_FILE.$BACKUP_EXT


# Change hostname
sed -i "s/$OLD_HOSTNAME/$1/g" $H_FILE
sed -i "s/$OLD_HOSTNAME/$1/g" $HN_FILE

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
		        [Yy]* ) sed -i "s/$OLD_DOMAINNAME/$NEW_DOMAINNAME/g" $H_FILE;
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
echo -e "${Yellow}WARNING! If you made changes, reboot BEFORE running this script again...${NC}"
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
