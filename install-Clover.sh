#!/bin/bash
# May 24 2003
RED='\033[0;31m'
GREEN='\033[0;32m'
CLOVER_VERSION='5154'

clear

echo Clover Install Script by ryanrudolf
echo https://github.com/ryanrudolfoba/SteamDeck-Clover-dualboot
sleep 2

# initial support so that script will work with regular Linux distros outside of SteamOS
# Password sanity check - make sure sudo password is already set by end user!
if [ "$(passwd --status $(whoami) | tr -s " " | cut -d " " -f 2)" == "P" ]
then
	read -s -p "Please enter current sudo password: " current_password ; echo
	echo Checking if the sudo password is correct.
	echo -e "$current_password\n" | sudo -S -k ls &> /dev/null

	if [ $? -eq 0 ]
	then
		echo -e "$GREEN"Sudo password is good!
	else
		echo -e "$RED"Sudo password is wrong! Re-run the script and make sure to enter the correct sudo password!
		exit
	fi
else
	echo -e "$RED"Sudo password is blank! Setup a sudo password first and then re-run script!
	passwd
	exit
fi

# sudo password is already set by the end user, all good let's go!
echo -e "$current_password\n" | sudo -S ls &> /dev/null
if [ $? -eq 0 ]
then
	echo -e "$GREEN"1st sanity check. So far so good!
else
	echo -e "$RED"Something went wrong on the 1st sanity check! Re-run script!
	exit
fi

###### Main menu. Ask user for the default OS to be selected in the Clover GUI boot menu.
Choice=$(zenity --width 800 --height 250 --list --radiolist --multiple --title "Clover Install Script for Steam Deck - https://github.com/ryanrudolfoba/SteamDeck-clover-dualboot"\
	--column "Select One" \
	--column "Option" \
	--column="Description - Read this carefully!"\
	FALSE Windows "Windows will be the default OS selected in the Clover GUI boot menu."\
	FALSE SteamOS "SteamOS will be the default OS selected in the Clover GUI boot menu."\
	TRUE EXIT "Select this if you changed your mind and don't want to proceed anymore.")

if [ $? -eq 1 ] || [ "$Choice" == "EXIT" ]
then
	echo User pressed CANCEL / EXIT. Make no changes. Exiting immediately.
	exit

elif [ "$Choice" == "Windows" ]
then
	echo $Choice
	# change the Default Loader in config,plist 
	sed -i '/<key>DefaultLoader<\/key>/!b;n;c\\t\t<string>\\EFI\\MICROSOFT\\bootmgfw\.efi<\/string>' custom/config.plist

elif [ "$Choice" == "SteamOS" ]
then
	echo $Choice
	# change the Default Loader in config,plist 
	sed -i '/<key>DefaultLoader<\/key>/!b;n;c\\t\t<string>\\EFI\\STEAMOS\\STEAMCL\.efi<\/string>' custom/config.plist
fi

# obtain Clover ISO
clover_archive=$(curl -s -O -L -w "%{filename_effective}" "https://github.com/CloverHackyColor/CloverBootloader/releases/download/${CLOVER_VERSION}/Clover-${CLOVER_VERSION}-X64.iso.7z")
clover_base=$(basename -s .7z $clover_archive)
/usr/bin/7z x $clover_archive -aoa $clover_base

# mount Clover ISO
sudo mkdir ~/temp-clover && sudo mount $clover_base ~/temp-clover &> /dev/null
if [ $? -eq 0 ]
then
	echo -e "$GREEN"2nd sanity check. ISO has been mounted!
else
	echo -e "$RED"Error mounting ISO!
	sudo umount ~/temp-clover
	rmdir ~/temp-clover
	exit
fi

# copy Clover and HackBGRT files to EFI system partition
sudo mkdir -p /esp/efi/clover && sudo cp -Rf ~/temp-clover/efi/clover /esp/efi/ && sudo cp custom/config.plist /esp/efi/clover/config.plist && sudo cp -Rf custom/themes/* /esp/efi/clover/themes && sudo cp -R HackBGRT /esp/efi

if [ $? -eq 0 ]
then
	echo -e "$GREEN"3rd sanity check. Clover and HackBGRT has been copied to the EFI system partition!
else
	echo -e "$RED"Error copying files. Something went wrong.
	sudo umount ~/temp-clover
	rmdir ~/temp-clover
	exit
fi

# cleanup temp directories created
sudo umount ~/temp-clover
sudo rmdir ~/temp-clover

# remove previous Clover entries before re-creating them
for entry in $(efibootmgr | grep -i "Clover" | colrm 9 | colrm 1 4)
do
	sudo efibootmgr -b $entry -B &> /dev/null
done

# install Clover to the EFI system partition
sudo efibootmgr -c -d /dev/nvme0n1 -p 1 -L "Clover - GUI Boot Manager" -l "\EFI\clover\cloverx64.efi" &> /dev/null

# test if Windows is installed on the internal SSD
sudo ls /esp/efi | grep Microsoft

if [ $? -eq 0 ]
then
	# Windows is installed on the internal SSD - backup and disable the Windows EFI entry!
	sudo cp /esp/efi/Microsoft/Boot/bootmgfw.efi /esp/efi/Microsoft/Boot/bootmgfw.efi.orig \
	&& sudo mv /esp/efi/Microsoft/Boot/bootmgfw.efi /esp/efi/Microsoft \
	&& sudo mv /esp/efi/boot/bootx64.efi /esp/efi/boot/bootx64.efi.orig \
	&& sudo cp /esp/efi/clover/cloverx64.efi /esp/efi/boot/bootx64.efi
	if [ "$Choice" == "Windows" ]
	then
		sudo sed -i '/<key>DefaultLoader<\/key>/!b;n;c\\t\t<string>\\EFI\\HackBGRT\\HackBGRT\.efi<\/string>' /esp/efi/clover/config.plist
	fi
else
	# Windows is not installed on the internal SSD - do not use the custom splash screen!
	if [ "$Choice" == "Windows" ]
	then
		sudo sed -i '/<key>DefaultLoader<\/key>/!b;n;c\\t\t<string>\\EFI\\MICROSOFT\\bootmgfw\.efi<\/string>' /esp/efi/clover/config.plist
	fi
	sudo sed -i 's/\\EFI\\HackBGRT\\HackBGRT\.efi/\\EFI\\MICROSOFT\\bootmgfw\.efi/g' /esp/efi/clover/config.plist
fi

# re-arrange the boot order and make Clover the priority!
Clover=$(efibootmgr | grep -i Clover | colrm 9 | colrm 1 4)
SteamOS=$(efibootmgr | grep -i SteamOS | colrm 9 | colrm 1 4)
sudo efibootmgr -n $Clover &> /dev/null
sudo efibootmgr -o $Clover,$SteamOS &> /dev/null

# Final sanity check
efibootmgr | grep "Clover - GUI" &> /dev/null

if [ $? -eq 0 ]
then
	echo -e "$GREEN"Final sanity check. Clover has been successfully installed to the EFI system partition!
else
	echo -e "$RED"Whoopsie something went wrong. Clover is not installed.
	exit
fi

# copy dolphin root extension to easily add themes
mkdir -p ~/.local/share/kservices5/ServiceMenus
cp custom/open_as_root.desktop ~/.local/share/kservices5/ServiceMenus

#########################
###### post install #####
#########################

# create ~/1Clover-tools and place the scripts in there
mkdir ~/1Clover-tools &> /dev/null
rm -f ~/1Clover-tools/* &> /dev/null

# clover-bootmanager.sh - script that gets called by clover-bootmanager.service on startup
cat > ~/1Clover-tools/clover-bootmanager.sh << EOF
#!/bin/bash

CloverStatus=/home/deck/1Clover-tools/status.txt

echo Clover Boot Manager - \$(date) > \$CloverStatus
echo BIOS Version : \$(sudo dmidecode -s bios-version) >> \$CloverStatus

# check for dump files
dumpfiles=\$(ls -l /sys/firmware/efi/efivars/dump-type* 2> /dev/null | wc -l)

if [ \$dumpfiles -gt 0 ]
then
	echo dump files exists. performing cleanup. >> \$CloverStatus
	sudo rm -f /sys/firmware/efi/efivars/dump-type*
else
	echo no dump files. no action needed. >> \$CloverStatus
fi

# Sanity Check - are the needed EFI entries available?
efibootmgr | grep -i Clover &> /dev/null
if [ \$? -eq 0 ]
then
	echo Clover EFI entry exists! No need to re-add Clover. >> \$CloverStatus
else
	echo Clover EFI entry is not found. Need to re-ad Clover. >> \$CloverStatus
	efibootmgr -c -d /dev/nvme0n1 -p 1 -L "Clover - GUI Boot Manager" -l "\EFI\clover\cloverx64.efi" &> /dev/null
fi

efibootmgr | grep -i Steam &> /dev/null
if [ \$? -eq 0 ]
then
	echo SteamOS EFI entry exists! No need to re-add SteamOS. >> \$CloverStatus
else
	echo SteamOS EFI entry is not found. Need to re-add SteamOS. >> \$CloverStatus
	efibootmgr -c -d /dev/nvme0n1 -p 1 -L "SteamOS" -l "\EFI\steamos\steamcl.efi" &> /dev/null
fi

# disable the Windows EFI entry!
test -f /esp/efi/Microsoft/Boot/bootmgfw.efi && echo Windows EFI exists! Moving it to /esp/efi/Microsoft >> \$CloverStatus && sudo cp /esp/efi/Microsoft/Boot/bootmgfw.efi /esp/efi/Microsoft/Boot/bootmgfw.efi.orig && sudo mv /esp/efi/Microsoft/Boot/bootmgfw.efi /esp/efi/Microsoft &>> \$CloverStatus

# re-arrange the boot order and make Clover the priority!
Clover=\$(efibootmgr | grep -i Clover | colrm 9 | colrm 1 4)
SteamOS=\$(efibootmgr | grep -i SteamOS | colrm 9 | colrm 1 4)
efibootmgr -o \$Clover,\$SteamOS &> /dev/null

echo "*** Current state of EFI entries ****" >> \$CloverStatus
efibootmgr | grep -iv Boot2 >> \$CloverStatus
chown deck:deck \$CloverStatus
EOF

# clover-bootmanager.service - systemd service that calls clover-bootmanager.sh on startup
cat > ~/1Clover-tools/clover-bootmanager.service << EOF
[Unit]
Description=Custom systemd service for Clover - GUI Boot Manager.

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/bin/bash -c '/etc/systemd/system/clover-bootmanager.sh'

[Install]
WantedBy=multi-user.target
EOF

########################################
###### Main menu of Clover Toolbox #####
########################################
cat > ~/1Clover-tools/Clover-Toolbox.sh << EOF
#!/bin/bash
zenity --password --title "Password Authentication" | sudo -S ls &> /dev/null
if [ \$? -ne 0 ]
then
	echo sudo password is wrong! | \\
		zenity --text-info --title "Clover Toolbox" --width 400 --height 200
	exit
fi

while true
do
Choice=\$(zenity --width 750 --height 350 --list --radiolist --multiple \
	--title "Clover Toolbox for Clover script  - https://github.com/ryanrudolfoba/SteamDeck-clover-dualboot"\\
	--column "Select One" \\
	--column "Option" \\
	--column="Description - Read this carefully!"\\
	FALSE Status "Choose this when filing a bug report!"\\
	FALSE Timeout "Set the default timeout to 5 10 or 15secs before it boots the default OS."\\
	FALSE Service "Disable / Enable the Clover EFI entry and Clover systemd service."\\
	FALSE Boot "Set the OS that will be booted by default."\\
	FALSE Logo "Use the new logo or old logo when booting to Windows."\\
	FALSE Uninstall "Choose this to uninstall Clover and revert any changes made."\\
	TRUE EXIT "***** Exit the Clover Toolbox *****")

if [ \$? -eq 1 ] || [ "\$Choice" == "EXIT" ]
then
	echo User pressed CANCEL / EXIT.
	exit

elif [ "\$Choice" == "Status" ]
then
	zenity --warning --title "Clover Toolbox" --text "\$(fold -w 120 -s ~/1Clover-tools/status.txt)" --width 400 --height 600

elif [ "\$Choice" == "Timeout" ]
then
Timeout_Choice=\$(zenity --width 500 --height 250 --list --radiolist --multiple \
	--title "Clover Toolbox for Clover script  - https://github.com/ryanrudolfoba/SteamDeck-clover-dualboot"\\
	--column "Select One" \\
	--column "Option" \\
	--column="Description - Read this carefully!"\\
	FALSE 5secs "Set the default timeout to 5secs."\\
	FALSE 10secs "Set the default timeout to 10secs."\\
	FALSE 15secs "Set the default timeout to 15secs."\\
	TRUE EXIT "***** Exit the Clover Toolbox *****")

	if [ \$? -eq 1 ] || [ "\$Timeout_Choice" == "EXIT" ]
	then
		echo User pressed CANCEL / EXIT.
		exit

	elif [ "\$Timeout_Choice" == "5secs" ]
	then
		# change the Default Timeout to 5secs in config,plist 
		sudo sed -i '/<key>Timeout<\\/key>/!b;n;c\\\t\\t<integer>5<\\/integer>' /esp/efi/clover/config.plist
		zenity --warning --title "Clover Toolbox" --text "Default timeout is now set to 5secs!" --width 400 --height 75

	elif [ "\$Timeout_Choice" == "10secs" ]
	then
		# change the Default Timeout to 10secs in config,plist 
		sudo sed -i '/<key>Timeout<\\/key>/!b;n;c\\\t\\t<integer>10<\\/integer>' /esp/efi/clover/config.plist
		zenity --warning --title "Clover Toolbox" --text "Default timeout is now set to 10secs!" --width 400 --height 75

	elif [ "\$Timeout_Choice" == "15secs" ]
	then
		# change the Default Timeout to 15secs in config,plist 
		sudo sed -i '/<key>Timeout<\\/key>/!b;n;c\\\t\\t<integer>15<\\/integer>' /esp/efi/clover/config.plist
		zenity --warning --title "Clover Toolbox" --text "Default timeout is now set to 15secs!" --width 400 --height 75
	fi

elif [ "\$Choice" == "Service" ]
then
Service_Choice=\$(zenity --width 650 --height 250 --list --radiolist --multiple \
	--title "Clover Toolbox for Clover script  - https://github.com/ryanrudolfoba/SteamDeck-clover-dualboot"\\
	--column "Select One" \\
	--column "Option" \\
	--column="Description - Read this carefully!"\\
	FALSE Disable "Disable the Clover EFI entry and Clover systemd service."\\
	FALSE Enable "Enable the Clover EFI entry and Clover systemd service."\\
	TRUE EXIT "***** Exit the Clover Toolbox *****")

	if [ \$? -eq 1 ] || [ "\$Service_Choice" == "EXIT" ]
	then
		echo User pressed CANCEL / EXIT.
		exit

	elif [ "\$Service_Choice" == "Disable" ]
	then
		# restore Windows EFI entry from backup
		sudo cp /esp/efi/Microsoft/Boot/bootmgfw.efi.orig /esp/efi/Microsoft/Boot/bootmgfw.efi

		# make Windows the next boot option!
		Windows=\$(efibootmgr | grep -i Windows | colrm 9 | colrm 1 4)
		sudo efibootmgr -n \$Windows &> /dev/null

		# disable the Clover systemd service
		sudo systemctl disable --now clover-bootmanager
		zenity --warning --title "Clover Toolbox" --text "Clover systemd service has been disabled. Windows is now activated!" --width 500 --height 75

	elif [ "\$Service_Choice" == "Enable" ]
	then
		# enable the Clover systemd service
		sudo systemctl enable --now clover-bootmanager
		sudo /etc/systemd/system/clover-bootmanager.sh
		zenity --warning --title "Clover Toolbox" --text "Clover systemd service has been enabled. Windows is now disabled!" --width 500 --height 75
	fi

elif [ "\$Choice" == "Boot" ]
then
Boot_Choice=\$(zenity --width 550 --height 250 --list --radiolist --multiple \
	--title "Clover Toolbox for Clover script  - https://github.com/ryanrudolfoba/SteamDeck-clover-dualboot"\\
	--column "Select One" \\
	--column "Option" \\
	--column="Description - Read this carefully!"\\
	FALSE Windows "Set Windows as the default OS to boot."\\
	FALSE SteamOS "Set SteamOS as the default OS to boot."\\
	FALSE LastOS "The last OS that was booted will be the default."\\
	TRUE EXIT "***** Exit the Clover Toolbox *****")

	if [ \$? -eq 1 ] || [ "\$Boot_Choice" == "EXIT" ]
	then
		echo User pressed CANCEL / EXIT.
		exit

	elif [ "\$Boot_Choice" == "Windows" ]
	then
		# change the Default Loader to Windows in config,plist 

		# test if Windows is installed on the internal SSD
		sudo ls /esp/efi | grep Microsoft

		if [ \$? -eq 0 ]
		then
			# Windows is installed on the internal SSD - use the custom splash screen!
			sudo sed -i '/<key>DefaultLoader<\\/key>/!b;n;c\\\t\\t<string>\\\EFI\\\HackBGRT\\\HackBGRT\\.efi<\\/string>' /esp/efi/clover/config.plist
			sudo sed -i '/<key>DefaultVolume<\\/key>/!b;n;c\\\t\\t<string>esp<\\/string>' /esp/efi/clover/config.plist
			sudo sed -i 's/\\\EFI\\\MICROSOFT\\\bootmgfw\.efi/\\\EFI\\\HackBGRT\\\HackBGRT\.efi/g' /esp/efi/clover/config.plist
		else
			# Windows is not installed on the internal SSD - do not use the custom splash screen!
			sudo sed -i '/<key>DefaultLoader<\\/key>/!b;n;c\\\t\\t<string>\\\EFI\\\MICROSOFT\\\bootmgfw\\.efi<\\/string>' /esp/efi/clover/config.plist
			sudo sed -i '/<key>DefaultVolume<\\/key>/!b;n;c\\\t\\t<string>esp<\\/string>' /esp/efi/clover/config.plist
			sudo sed -i 's/\\\EFI\\\HackBGRT\\\HackBGRT\.efi/\\\EFI\\\MICROSOFT\\\bootmgfw\.efi/g' /esp/efi/clover/config.plist
		fi

		zenity --warning --title "Clover Toolbox" --text "Windows is now the default boot entry in Clover!" --width 400 --height 75

	elif [ "\$Boot_Choice" == "SteamOS" ]
	then
		# change the Default Loader in config,plist 
		sudo sed -i '/<key>DefaultLoader<\\/key>/!b;n;c\\\t\\t<string>\\\EFI\\\STEAMOS\\\STEAMCL\\.efi<\\/string>' /esp/efi/clover/config.plist
		sudo sed -i '/<key>DefaultVolume<\\/key>/!b;n;c\\\t\\t<string>esp<\\/string>' /esp/efi/clover/config.plist
		zenity --warning --title "Clover Toolbox" --text "SteamOS is now the default boot entry in Clover!" --width 400 --height 75

	elif [ "\$Boot_Choice" == "LastOS" ]
	then
		# change the Default Volume in config,plist 
		sudo sed -i '/<key>DefaultVolume<\\/key>/!b;n;c\\\t\\t<string>LastBootedVolume<\\/string>' /esp/efi/clover/config.plist
		zenity --warning --title "Clover Toolbox" --text "The last OS used is now the default boot entry in Clover!" --width 425 --height 75
	fi

elif [ "\$Choice" == "Logo" ]
then
Logo_Choice=\$(zenity --width 750 --height 250 --list --radiolist --multiple \
	--title "Clover Toolbox for Clover script  - https://github.com/ryanrudolfoba/SteamDeck-clover-dualboot"\\
	--column "Select One" \\
	--column "Option" \\
	--column="Description - Read this carefully!"\\
	FALSE NewLogo "Use custom splash / logo when booting to Windows (internal SSD only)."\\
	FALSE OldLogo "Use default SteamOS logo when booting to Windows."\\
	TRUE EXIT "***** Exit the Clover Toolbox *****")

	if [ \$? -eq 1 ] || [ "\$Timeout_Choice" == "EXIT" ]
	then
		echo User pressed CANCEL / EXIT.
		exit

	elif [ "\$Logo_Choice" == "NewLogo" ]
	then
		# change HackBGRT config to use te custom splash / logo when booting Windows 
		sudo sed -i '/\\#CUSTOMSPLASH-do-not-delete-this-line/!b;n;cimage=path=\\\EFI\\\HackBGRT\\\splash\\.bmp' /esp/efi/HackBGRT/config.txt
		zenity --warning --title "Clover Toolbox" --text "Custom splash / logo is now activated!" --width 400 --height 75

	elif [ "\$Logo_Choice" == "OldLogo" ]
	then
		# change HackBGRT config to keep the existing splash / SteamOS logo when booting Windows
		sudo sed -i '/\\#CUSTOMSPLASH-do-not-delete-this-line/!b;n;cimage=keep' /esp/efi/HackBGRT/config.txt
		zenity --warning --title "Clover Toolbox" --text "Default splash / logo is now activated!" --width 400 --height 75
	fi

elif [ "\$Choice" == "Uninstall" ]
then
	# restore Windows EFI entry from backup
	sudo mv /esp/efi/Microsoft/Boot/bootmgfw.efi.orig /esp/efi/Microsoft/Boot/bootmgfw.efi
	sudo mv /esp/efi/boot/bootx64.efi.orig /esp/efi/boot/bootx64.efi
	sudo rm /esp/efi/Microsoft/bootmgfw.efi

	# remove Clover and HackBGRT from the EFI system partition
	sudo rm -rf /esp/efi/clover
	sudo rm -rf /esp/efi/HackBGRT
	
	for entry in \$(efibootmgr | grep "Clover - GUI" | colrm 9 | colrm 1 4)
	do
		sudo efibootmgr -b \$entry -B &> /dev/null
	done

	# delete systemd service
	sudo steamos-readonly disable
	sudo systemctl stop clover-bootmanager.service
	sudo rm /etc/systemd/system/clover-bootmanager*
	sudo systemctl daemon-reload
	sudo steamos-readonly enable

	# delete dolphin root extension
	rm ~/.local/share/kservices5/ServiceMenus/open_as_root.desktop

	rm -rf ~/SteamDeck-Clover-dualboot
	rm -rf ~/1Clover-tools/*
	rm ~/Desktop/Clover-Toolbox
	
	zenity --warning --title "Clover Toolbox" --text "Clover has been uninstalled and the Windows EFI entry has been activated!" --width 600 --height 75
	exit
fi
done
EOF

######################################
###### continue with the install #####
######################################
# copy the systemd script to a location owned by root to prevent local privilege escalation
chmod +x ~/1Clover-tools/*.sh
sudo mv ~/1Clover-tools/clover-bootmanager.service /etc/systemd/system/clover-bootmanager.service
sudo mv ~/1Clover-tools/clover-bootmanager.sh /etc/systemd/system/clover-bootmanager.sh

# start the clover-bootmanager.service
sudo systemctl daemon-reload
sudo systemctl enable --now clover-bootmanager.service
sudo /etc/systemd/system/clover-bootmanager.sh

# cleanup - delete the downloaded ISO
rm Clover-$CLOVER_VERSION-X64.iso*

# create desktop icon for Clover Toolbox
ln -s ~/1Clover-tools/Clover-Toolbox.sh ~/Desktop/Clover-Toolbox
echo -e "$RED"Desktop icon for Clover Toolbox has been created!
