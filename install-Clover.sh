#!/bin/bash
# May 24 2003
RED='\033[0;31m'
GREEN='\033[0;32m'
CLOVER_VERSION='5155'

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

# sanity check - is rEFInd installed?
efibootmgr | grep -i refind
if [ $? -ne 0 ]
then
	echo rEFInd is not detected! Proceeding with the Clover install.
else
	echo -e "$RED"rEFInd seems to be installed! Performing best effort to uninstall rEFInd!
	for rEFInd in $(efibootmgr | grep -i refind | colrm 9 | colrm 1 4)
	do
		sudo efibootmgr -b $rEFInd -B &> /dev/null
	done
	sudo systemctl disable bootnext-refind.service &> /dev/null
	sudo rm -rf /esp/efi/refind &> /dev/null
	sudo rm /etc/systemd/system/bootnext-refind.service &> /dev/null
	rm -rf ~/.SteamDeck_rEFInd &> /dev/null

	# check again if rEFInd is gone?	
	efibootmgr | grep -i refind
	if [ $? -ne 0 ]
	then
		echo rEFInd has been successfully uninstalled! Proceeding with the Clover install.
	else
		echo -e "$RED"rEFInd is still installed. Please manually uninstall rEFInd first!
		exit
	fi
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

# copy Clover files to EFI system partition
sudo mkdir -p /esp/efi/clover && sudo cp -Rf ~/temp-clover/efi/clover /esp/efi/ && sudo cp custom/config.plist /esp/efi/clover/config.plist && sudo cp -Rf custom/themes/* /esp/efi/clover/themes

if [ $? -eq 0 ]
then
	echo -e "$GREEN"3rd sanity check. Clover has been copied to the EFI system partition!
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

#Backup and disable the Windows EFI entry!
sudo cp /esp/efi/Microsoft/Boot/bootmgfw.efi /esp/efi/Microsoft/Boot/bootmgfw.efi.orig \
	&& sudo mv /esp/efi/Microsoft/Boot/bootmgfw.efi /esp/efi/Microsoft \
	&& sudo mv /esp/efi/boot/bootx64.efi /esp/efi/boot/bootx64.efi.orig \
	&& sudo cp /esp/efi/clover/cloverx64.efi /esp/efi/boot/bootx64.efi

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
cp -R custom/logos ~/1Clover-tools &> /dev/null
sudo cp ~/1Clover-tools/logos/SteamDeckLogo.png /esp/efi/steamos/steamos.png &> /dev/null

# clover-bootmanager.sh - script that gets called by clover-bootmanager.service on startup
cat > ~/1Clover-tools/clover-bootmanager.sh << EOF
#!/bin/bash

CloverStatus=/home/deck/1Clover-tools/status.txt

echo Clover Boot Manager - \$(date) > \$CloverStatus
echo BIOS Version : \$(sudo dmidecode -s bios-version) >> \$CloverStatus
cat /etc/os-release | grep 'PRETTY_NAME\\|VERSION_ID\\|BUILD_ID' >> \$CloverStatus
uname -a >> \$CloverStatus

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
PASSWORD=\$(zenity --password --title "sudo Password Authentication")
echo \$PASSWORD | sudo -S ls &> /dev/null
if [ \$? -ne 0 ]
then
	echo sudo password is wrong! | \\
		zenity --text-info --title "Clover Toolbox" --width 400 --height 200
	exit
fi

while true
do
Choice=\$(zenity --width 750 --height 400 --list --radiolist --multiple \
	--title "Clover Toolbox for Clover script  - https://github.com/ryanrudolfoba/SteamDeck-clover-dualboot"\\
	--column "Select One" \\
	--column "Option" \\
	--column="Description - Read this carefully!"\\
	FALSE Status "Choose this when filing a bug report!"\\
	FALSE Themes "Select a static theme or random themes."\\
	FALSE Timeout "Set the default timeout to 1 5 10 or 15secs before it boots the default OS."\\
	FALSE Service "Disable / Enable the Clover EFI entry and Clover systemd service."\\
	FALSE Boot "Set the OS that will be booted by default."\\
	FALSE NewLogo "Replace the BGRT startup logo."\\
	False OldLogo "Restore the BGRT startup logo to the default."\\
	FALSE Resolution "Set the screen resolution if using the DeckHD 1200p screen mod."\\
	FALSE Uninstall "Choose this to uninstall Clover and revert any changes made."\\
	TRUE EXIT "***** Exit the Clover Toolbox *****")

if [ \$? -eq 1 ] || [ "\$Choice" == "EXIT" ]
then
	echo User pressed CANCEL / EXIT.
	exit

elif [ "\$Choice" == "Status" ]
then
	zenity --warning --title "Clover Toolbox" --text "\$(fold -w 120 -s ~/1Clover-tools/status.txt)" --width 400 --height 600

elif [ "\$Choice" == "Themes" ]
then
Theme_Choice=\$(zenity --title "Clover Toolbox"	--width 200 --height 300 --list \\
	--column "Theme Name" \$(echo \$PASSWORD | sudo -S ls -l /esp/efi/clover/themes | cut -d " " -f 9) )

	if [ \$? -eq 1 ]
	then
		echo User pressed CANCEL. Going back to main menu.
	else
		echo \$PASSWORD | sudo -S sed -i '/<key>Theme<\\/key>/!b;n;c\\\t\\t<string>'\$Theme_Choice'<\\/string>' /esp/efi/clover/config.plist
		zenity --warning --title "Clover Toolbox" --text "Theme has been changed to \$Theme_Choice!" --width 400 --height 75
	fi

elif [ "\$Choice" == "Timeout" ]
then
Timeout_Choice=\$(zenity --width 500 --height 275 --list --radiolist --multiple \
	--title "Clover Toolbox" --column "Select One" --column "Option" --column="Description - Read this carefully!"\\
	FALSE 1 "Set the default timeout to 1sec."\\
	FALSE 5 "Set the default timeout to 5secs."\\
	FALSE 10 "Set the default timeout to 10secs."\\
	FALSE 15 "Set the default timeout to 15secs."\\
	TRUE EXIT "***** Exit the Clover Toolbox *****")

	if [ \$? -eq 1 ] || [ "\$Timeout_Choice" == "EXIT" ]
	then
		echo User pressed CANCEL. Going back to main menu.
	else
		# change the Default Timeout in config,plist 
		echo \$PASSWORD | sudo -S sed -i '/<key>Timeout<\\/key>/!b;n;c\\\t\\t<integer>'\$Timeout_Choice'<\\/integer>' /esp/efi/clover/config.plist
		zenity --warning --title "Clover Toolbox" --text "Default timeout is now set to \$Timeout_Choice !" --width 400 --height 75
	fi

elif [ "\$Choice" == "Service" ]
then
Service_Choice=\$(zenity --width 650 --height 250 --list --radiolist --multiple --title "Clover Toolbox"\\
	--column "Select One" --column "Option" --column="Description - Read this carefully!"\\
	FALSE Disable "Disable the Clover EFI entry and Clover systemd service."\\
	FALSE Enable "Enable the Clover EFI entry and Clover systemd service."\\
	TRUE EXIT "***** Exit the Clover Toolbox *****")

	if [ \$? -eq 1 ] || [ "\$Service_Choice" == "EXIT" ]
	then
		echo User pressed CANCEL. Going back to main menu.

	elif [ "\$Service_Choice" == "Disable" ]
	then
		# restore Windows EFI entry from backup
		echo \$PASSWORD | sudo -S cp /esp/efi/Microsoft/Boot/bootmgfw.efi.orig /esp/efi/Microsoft/Boot/bootmgfw.efi

		# make Windows the next boot option!
		Windows=\$(efibootmgr | grep -i Windows | colrm 9 | colrm 1 4)
		echo \$PASSWORD | sudo -S efibootmgr -n \$Windows &> /dev/null

		# disable the Clover systemd service
		echo \$PASSWORD | sudo -S systemctl disable --now clover-bootmanager
		zenity --warning --title "Clover Toolbox" --text "Clover systemd service has been disabled. Windows is now activated!" --width 500 --height 75

	elif [ "\$Service_Choice" == "Enable" ]
	then
		# enable the Clover systemd service
		sudo systemctl enable --now clover-bootmanager
		echo \$PASSWORD | sudo -S /etc/systemd/system/clover-bootmanager.sh
		zenity --warning --title "Clover Toolbox" --text "Clover systemd service has been enabled. Windows is now disabled!" --width 500 --height 75
	fi

elif [ "\$Choice" == "Boot" ]
then
Boot_Choice=\$(zenity --width 550 --height 250 --list --radiolist --multiple --title "Clover Toolbox" --column "Select One" \\
	--column "Option" --column="Description - Read this carefully!"\\
	FALSE Windows "Set Windows as the default OS to boot."\\
	FALSE SteamOS "Set SteamOS as the default OS to boot."\\
	FALSE LastOS "The last OS that was booted will be the default."\\
	TRUE EXIT "***** Exit the Clover Toolbox *****")

	if [ \$? -eq 1 ] || [ "\$Boot_Choice" == "EXIT" ]
	then
		echo User pressed CANCEL. Going back to main menu.

	elif [ "\$Boot_Choice" == "Windows" ]
	then
		# change the Default Loader to Windows in config,plist 

		echo \$PASSWORD | sudo -S sed -i '/<key>DefaultLoader<\\/key>/!b;n;c\\\t\\t<string>\\\EFI\\\MICROSOFT\\\bootmgfw\\.efi<\\/string>' /esp/efi/clover/config.plist
		echo \$PASSWORD | sudo -S sed -i '/<key>DefaultVolume<\\/key>/!b;n;c\\\t\\t<string>esp<\\/string>' /esp/efi/clover/config.plist

		zenity --warning --title "Clover Toolbox" --text "Windows is now the default boot entry in Clover!" --width 400 --height 75

	elif [ "\$Boot_Choice" == "SteamOS" ]
	then
		# change the Default Loader in config,plist 
		echo \$PASSWORD | sudo -S sed -i '/<key>DefaultLoader<\\/key>/!b;n;c\\\t\\t<string>\\\EFI\\\STEAMOS\\\STEAMCL\\.efi<\\/string>' /esp/efi/clover/config.plist
		echo \$PASSWORD | sudo -S sed -i '/<key>DefaultVolume<\\/key>/!b;n;c\\\t\\t<string>esp<\\/string>' /esp/efi/clover/config.plist
		zenity --warning --title "Clover Toolbox" --text "SteamOS is now the default boot entry in Clover!" --width 400 --height 75

	elif [ "\$Boot_Choice" == "LastOS" ]
	then
		# change the Default Volume in config,plist 
		echo \$PASSWORD | sudo -S sed -i '/<key>DefaultVolume<\\/key>/!b;n;c\\\t\\t<string>LastBootedVolume<\\/string>' /esp/efi/clover/config.plist
		zenity --warning --title "Clover Toolbox" --text "The last OS used is now the default boot entry in Clover!" --width 425 --height 75
	fi

elif [ "\$Choice" == "NewLogo" ]
then
Logo_Choice=\$(zenity --title "Clover Toolbox"	--width 200 --height 350 --list \\
	--column "Logo  Name" \$(ls -l ~/1Clover-tools/logos/*.png | cut -d "/" -f 6) )
	if [ \$? -eq 1 ]
	then
		echo User pressed CANCEL. Going back to main menu.
	else
		echo \$PASSWORD | sudo -S cp ~/1Clover-tools/logos/\$Logo_Choice /esp/efi/steamos/steamos.png
		zenity --warning --title "Clover Toolbox" --text "BGRT logo has been changed to \$Logo_Choice!" --width 400 --height 75
	fi

elif [ "\$Choice" == "OldLogo" ]
then
	echo \$PASSWORD | sudo -S rm /esp/efi/steamos/steamos.png &> /dev/null
	zenity --warning --title "Clover Toolbox" --text "BGRT logo has been restored to the default!" --width 400 --height 75

elif [ "\$Choice" == "Resolution" ]
then
Resolution_Choice=\$(zenity --width 550 --height 250 --list --radiolist --multiple --title "Clover Toolbox"\\
	--column "Select One" --column "Option" --column="Description - Read this carefully!"\\
	FALSE 800p "Use the default screen resolution 1280x800."\\
	FALSE 1200p "Use DeckHD screen resolution 1920x1200."\\
	TRUE EXIT "***** Exit the Clover Toolbox *****")

	if [ \$? -eq 1 ] || [ "\$Resolution_Choice" == "EXIT" ]
	then
		echo User pressed CANCEL. Going back to main menu.

	elif [ "\$Resolution_Choice" == "800p" ]
	then
		# change the sceen resolution to 1280x800 in config,plist 
		echo \$PASSWORD | sudo -S sed -i '/<key>ScreenResolution<\\/key>/!b;n;c\\\t\\t<string>1280x800<\\/string>' /esp/efi/clover/config.plist
		zenity --warning --title "Clover Toolbox" --text "Screen resolution is now set to 1280x800." --width 400 --height 75

	elif [ "\$Resolution_Choice" == "1200p" ]
	then
		# change the sceen resolution to 1920x1200 in config,plist 
		echo \$PASSWORD | sudo -S sed -i '/<key>ScreenResolution<\\/key>/!b;n;c\\\t\\t<string>1920x1200<\\/string>' /esp/efi/clover/config.plist
		zenity --warning --title "Clover Toolbox" --text "Screen resolution is now set to 1920x1200." --width 400 --height 75
	fi

elif [ "\$Choice" == "Uninstall" ]
then
	# restore Windows EFI entry from backup
	echo \$PASSWORD | sudo -S mv /esp/efi/Microsoft/Boot/bootmgfw.efi.orig /esp/efi/Microsoft/Boot/bootmgfw.efi
	echo \$PASSWORD | sudo -S mv /esp/efi/boot/bootx64.efi.orig /esp/efi/boot/bootx64.efi
	echo \$PASSWORD | sudo -S rm /esp/efi/Microsoft/bootmgfw.efi

	# remove Clover from the EFI system partition
	echo \$PASSWORD | sudo -S rm -rf /esp/efi/clover

	for entry in \$(efibootmgr | grep "Clover - GUI" | colrm 9 | colrm 1 4)
	do
		echo \$PASSWORD | sudo -S efibootmgr -b \$entry -B &> /dev/null
	done

	# remove custom logo / BGRT
	echo \$PASSWORD | sudo -S rm /esp/efi/steamos/steamos.png &> /dev/null

	# delete systemd service
	echo \$PASSWORD | sudo -S steamos-readonly disable
	echo \$PASSWORD | sudo -S systemctl stop clover-bootmanager.service
	echo \$PASSWORD | sudo -S rm /etc/systemd/system/clover-bootmanager*
	echo \$PASSWORD | sudo -S sudo systemctl daemon-reload
	echo \$PASSWORD | sudo -S steamos-readonly enable

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
