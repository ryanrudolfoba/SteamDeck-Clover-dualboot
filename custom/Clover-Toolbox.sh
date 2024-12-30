#!/bin/bash

# check if Bazzite or SteamOS
grep -i bazzite /etc/os-release &> /dev/null
if [ $? -eq 0 ]
then
	OS=bazzite
	EFI_PATH=/boot/efi/EFI
	BOOTX64=$EFI_PATH/BOOT/BOOTX64.EFI
else
	grep -i SteamOS /etc/os-release &> /dev/null
	if [ $? -eq 0 ]
	then
		OS=SteamOS
		EFI_PATH=/esp/efi
		BOOTX64=$EFI_PATH/boot/bootx64.efi
	else
		exit
	fi
fi

current_password=$(zenity --password --title "sudo Password Authentication")
echo -e "$current_password\n" | sudo -S ls &> /dev/null
if [ $? -ne 0 ]
then
	echo sudo password is wrong! | \
		zenity --text-info --title "Clover Toolbox" --width 400 --height 200
	exit
fi

while true
do
Choice=$(zenity --width 750 --height 450 --list --radiolist --multiple 	--title "Clover Toolbox for Clover script  - https://github.com/ryanrudolfoba/SteamDeck-clover-dualboot"\
	--column "Select One" \
	--column "Option" \
	--column="Description - Read this carefully!"\
	FALSE Status "Choose this when filing a bug report!"\
	FALSE Batocera "Choose config between Batocera v39 (and newer) or v38 (and older)."\
	FALSE Themes "Select a static theme or random themes."\
	FALSE Timeout "Set the default timeout to 1 5 10 or 15secs before it boots the default OS."\
	FALSE Service "Disable / Enable the Clover EFI entry and Clover systemd service."\
	FALSE Boot "Set the OS that will be booted by default."\
	FALSE NewLogo "Replace the BGRT startup logo."\
	False OldLogo "Restore the BGRT startup logo to the default."\
	FALSE Resolution "Set the screen resolution if using the DeckHD 1200p screen mod."\
	FALSE Custom "Replace Clover EFI with a custom one that hides the OPTIONS button."\
	FALSE Uninstall "Choose this to uninstall Clover and revert any changes made."\
	TRUE EXIT "***** Exit the Clover Toolbox *****")

if [ $? -eq 1 ] || [ "$Choice" == "EXIT" ]
then
	echo User pressed CANCEL / EXIT.
	exit

elif [ "$Choice" == "Status" ]
then
	zenity --warning --title "Clover Toolbox" --text "$(fold -w 120 -s ~/1Clover-tools/status.txt)" --width 1000 --height 400

elif [ "$Choice" == "Batocera" ]
then
Batocera_Choice=$(zenity --width 550 --height 220 --list --radiolist --multiple --title "Clover Toolbox" --column "Select One" \
	--column "Option" --column="Description - Read this carefully!"\
	FALSE v39 "Set the Clover config for Batocera v39 and newer."\
	FALSE v38 "Set the Clover config for Batocera v38 and older."\
	TRUE EXIT "***** Exit the Clover Toolbox *****")

	if [ $? -eq 1 ] || [ "$Batocera_Choice" == "EXIT" ]
	then
		echo User pressed CANCEL. Going back to main menu.

	elif [ "$Batocera_Choice" == "v39" ]
	then
		# Update the config.plist for Batocera v39 and newer
		echo -e "$current_password\n" | sudo -S sed -i '/<string>os_batocera<\/string>/!b;n;n;c\\t\t\t\t\t<string>\\efi\\batocera\\grubx64\.efi<\/string>' $EFI_PATH/clover/config.plist

		zenity --warning --title "Clover Toolbox" --text "Clover config has been updated for Batocera v39 and newer!" --width 450 --height 75

	elif [ "$Batocera_Choice" == "v38" ]
	then
		# Update the config.plist for Batocera v38 and older
		echo -e "$current_password\n" | sudo -S sed -i '/<string>os_batocera<\/string>/!b;n;n;c\\t\t\t\t\t<string>\\efi\\boot\\bootx64\.efi<\/string>' $EFI_PATH/clover/config.plist

		zenity --warning --title "Clover Toolbox" --text "Clover config has been updated for Batocera v38 and older!" --width 450 --height 75

	fi

elif [ "$Choice" == "Themes" ]
then
Theme_Choice=$(zenity --title "Clover Toolbox"	--width 200 --height 325 --list \
	--column "Theme Name" $(echo -e "$current_password\n" | sudo -S ls $EFI_PATH/clover/themes) )

	if [ $? -eq 1 ]
	then
		echo User pressed CANCEL. Going back to main menu.
	else
		echo -e "$current_password\n" | sudo -S sed -i '/<key>Theme<\/key>/!b;n;c\\t\t<string>'$Theme_Choice'<\/string>' $EFI_PATH/clover/config.plist
		zenity --warning --title "Clover Toolbox" --text "Theme has been changed to $Theme_Choice!" --width 400 --height 75
	fi

elif [ "$Choice" == "Timeout" ]
then
Timeout_Choice=$(zenity --width 500 --height 300 --list --radiolist --multiple 	--title "Clover Toolbox" --column "Select One" --column "Option" --column="Description - Read this carefully!"\
	FALSE 1 "Set the default timeout to 1sec."\
	FALSE 5 "Set the default timeout to 5secs."\
	FALSE 10 "Set the default timeout to 10secs."\
	FALSE 15 "Set the default timeout to 15secs."\
 	FALSE 60 "Set the default timeout to 60secs."\
	TRUE EXIT "***** Exit the Clover Toolbox *****")

	if [ $? -eq 1 ] || [ "$Timeout_Choice" == "EXIT" ]
	then
		echo User pressed CANCEL. Going back to main menu.
	else
		# change the Default Timeout in config.plist 
		echo -e "$current_password\n" | sudo -S sed -i '/<key>Timeout<\/key>/!b;n;c\\t\t<integer>'$Timeout_Choice'<\/integer>' $EFI_PATH/clover/config.plist
		zenity --warning --title "Clover Toolbox" --text "Default timeout is now set to $Timeout_Choice !" --width 400 --height 75
	fi

elif [ "$Choice" == "Service" ]
then
Service_Choice=$(zenity --width 650 --height 250 --list --radiolist --multiple --title "Clover Toolbox"\
	--column "Select One" --column "Option" --column="Description - Read this carefully!"\
	FALSE Disable "Disable the Clover EFI entry and Clover systemd service."\
	FALSE Enable "Enable the Clover EFI entry and Clover systemd service."\
	TRUE EXIT "***** Exit the Clover Toolbox *****")

	if [ $? -eq 1 ] || [ "$Service_Choice" == "EXIT" ]
	then
		echo User pressed CANCEL. Going back to main menu.

	elif [ "$Service_Choice" == "Disable" ]
	then
		# restore Windows EFI entry from backup
		echo -e "$current_password\n" | sudo -S cp $EFI_PATH/Microsoft/Boot/bootmgfw.efi.orig $EFI_PATH/Microsoft/Boot/bootmgfw.efi

		# make Windows the next boot option!
		Windows=$(efibootmgr | grep -i Windows | colrm 9 | colrm 1 4)
		echo -e "$current_password\n" | sudo -S efibootmgr -n $Windows &> /dev/null

		# disable the Clover systemd service
		echo -e "$current_password\n" | sudo -S systemctl disable --now clover-bootmanager
		zenity --warning --title "Clover Toolbox" --text "Clover systemd service has been disabled. Windows is now activated!" --width 500 --height 75

	elif [ "$Service_Choice" == "Enable" ]
	then
		# enable the Clover systemd service
		sudo systemctl enable --now clover-bootmanager
		echo -e "$current_password\n" | sudo -S /etc/systemd/system/clover-bootmanager.sh
		zenity --warning --title "Clover Toolbox" --text "Clover systemd service has been enabled. Windows is now disabled!" --width 500 --height 75
	fi

elif [ "$Choice" == "Boot" ]
then
Boot_Choice=$(zenity --width 550 --height 300 --list --radiolist --multiple --title "Clover Toolbox" --column "Select One" \
	--column "Option" --column="Description - Read this carefully!"\
	FALSE Windows "Set Windows as the default OS to boot."\
	FALSE SteamOS "Set SteamOS as the default OS to boot."\
	FALSE Bazzite "Set Bazzite as the default OS to boot."\
	FALSE LastOS "The last OS that was booted will be the default."\
	TRUE EXIT "***** Exit the Clover Toolbox *****")

	if [ $? -eq 1 ] || [ "$Boot_Choice" == "EXIT" ]
	then
		echo User pressed CANCEL. Going back to main menu.

	elif [ "$Boot_Choice" == "Windows" ]
	then
		# change the Default Loader to Windows in config.plist 

		echo -e "$current_password\n" | sudo -S sed -i '/<key>DefaultLoader<\/key>/!b;n;c\\t\t<string>\\efi\\microsoft\\bootmgfw\.efi<\/string>' $EFI_PATH/clover/config.plist
		echo -e "$current_password\n" | sudo -S sed -i '/<key>DefaultVolume<\/key>/!b;n;c\\t\t<string>esp<\/string>' $EFI_PATH/clover/config.plist

		zenity --warning --title "Clover Toolbox" --text "Windows is now the default boot entry in Clover!" --width 400 --height 75

	elif [ "$Boot_Choice" == "SteamOS" ]
	then
		# change the Default Loader in config.plist 
		echo -e "$current_password\n" | sudo -S sed -i '/<key>DefaultLoader<\/key>/!b;n;c\\t\t<string>\\efi\\steamos\\steamcl\.efi<\/string>' $EFI_PATH/clover/config.plist
		echo -e "$current_password\n" | sudo -S sed -i '/<key>DefaultVolume<\/key>/!b;n;c\\t\t<string>esp<\/string>' $EFI_PATH/clover/config.plist
		zenity --warning --title "Clover Toolbox" --text "SteamOS is now the default boot entry in Clover!" --width 400 --height 75

	elif [ "$Boot_Choice" == "Bazzite" ]
	then
		# change the Default Loader in config.plist 
		echo -e "$current_password\n" | sudo -S sed -i '/<key>DefaultLoader<\/key>/!b;n;c\\t\t<string>\\EFI\\FEDORA\\shimx64\.efi<\/string>' $EFI_PATH/clover/config.plist
		echo -e "$current_password\n" | sudo -S sed -i '/<key>DefaultVolume<\/key>/!b;n;c\\t\t<string>esp<\/string>' $EFI_PATH/clover/config.plist
		zenity --warning --title "Clover Toolbox" --text "SteamOS is now the default boot entry in Clover!" --width 400 --height 75

	elif [ "$Boot_Choice" == "LastOS" ]
	then
		# change the Default Volume in config.plist 
		echo -e "$current_password\n" | sudo -S sed -i '/<key>DefaultVolume<\/key>/!b;n;c\\t\t<string>LastBootedVolume<\/string>' $EFI_PATH/clover/config.plist
		zenity --warning --title "Clover Toolbox" --text "The last OS used is now the default boot entry in Clover!" --width 425 --height 75
	fi

elif [ "$Choice" == "NewLogo" ]
then
Logo_Choice=$(zenity --title "Clover Toolbox"	--width 200 --height 350 --list \
	--column "Logo  Name" $(ls -l ~/1Clover-tools/logos/*.png | sed s/^.*\\/\//) )  
	if [ $? -eq 1 ]
	then
		echo User pressed CANCEL. Going back to main menu.
	else
		echo -e "$current_password\n" | sudo -S cp ~/1Clover-tools/logos/$Logo_Choice $EFI_PATH/steamos/steamos.png
		zenity --warning --title "Clover Toolbox" --text "BGRT logo has been changed to $Logo_Choice!" --width 400 --height 75
	fi

elif [ "$Choice" == "OldLogo" ]
then
	echo -e "$current_password\n" | sudo -S rm $EFI_PATH/steamos/steamos.png &> /dev/null
	zenity --warning --title "Clover Toolbox" --text "BGRT logo has been restored to the default!" --width 400 --height 75

elif [ "$Choice" == "Resolution" ]
then
Resolution_Choice=$(zenity --width 550 --height 250 --list --radiolist --multiple --title "Clover Toolbox"\
	--column "Select One" --column "Option" --column="Description - Read this carefully!"\
	FALSE 800p "Use the default screen resolution 1280x800."\
	FALSE 1200p "Use DeckHD screen resolution 1920x1200."\
	TRUE EXIT "***** Exit the Clover Toolbox *****")

	if [ $? -eq 1 ] || [ "$Resolution_Choice" == "EXIT" ]
	then
		echo User pressed CANCEL. Going back to main menu.

	elif [ "$Resolution_Choice" == "800p" ]
	then
		# change the sceen resolution to 1280x800 in config,plist 
		echo -e "$current_password\n" | sudo -S sed -i '/<key>ScreenResolution<\/key>/!b;n;c\\t\t<string>1280x800<\/string>' $EFI_PATH/clover/config.plist
		zenity --warning --title "Clover Toolbox" --text "Screen resolution is now set to 1280x800." --width 400 --height 75

	elif [ "$Resolution_Choice" == "1200p" ]
	then
		# change the sceen resolution to 1920x1200 in config,plist 
		echo -e "$current_password\n" | sudo -S sed -i '/<key>ScreenResolution<\/key>/!b;n;c\\t\t<string>1920x1200<\/string>' $EFI_PATH/clover/config.plist
		zenity --warning --title "Clover Toolbox" --text "Screen resolution is now set to 1920x1200." --width 400 --height 75
	fi

elif [ "$Choice" == "Custom" ]
then
	echo -e "$current_password\n" | sudo -S cp ~/1Clover-tools/efi/custom_clover_5157.efi $EFI_PATH/clover/cloverx64.efi
	zenity --warning --title "Clover Toolbox" --text "Custom Clover EFI has been installed!" --width 400 --height 75

elif [ "$Choice" == "Uninstall" ]
then
	# restore Windows EFI entry from backup
	echo -e "$current_password\n" | sudo -S mv $EFI_PATH/Microsoft/Boot/bootmgfw.efi.orig $EFI_PATH/Microsoft/Boot/bootmgfw.efi
	if [ $? -eq 0 ]
	then
		echo -e "$current_password\n" | sudo -S rm $EFI_PATH/Microsoft/bootmgfw.efi
	else
		echo -e "$current_password\n" | sudo -S mv $EFI_PATH/Microsoft/bootmgfw.efi $EFI_PATH/Microsoft/Boot/bootmgfw.efi
	fi
	echo -e "$current_password\n" | sudo -S mv $BOOTX64.orig $BOOTX64

	# remove Clover from the EFI system partition
	echo -e "$current_password\n" | sudo -S rm -rf $EFI_PATH/clover

	for entry in $(efibootmgr | grep "Clover - GUI" | colrm 9 | colrm 1 4)
	do
		echo -e "$current_password\n" | sudo -S efibootmgr -b $entry -B &> /dev/null
	done

	# remove custom logo / BGRT
	echo -e "$current_password\n" | sudo -S rm $EFI_PATH/steamos/steamos.png &> /dev/null

	echo -e "$current_password\n" | sudo -S steamos-readonly disable

	# delete systemd service
	echo -e "$current_password\n" | sudo -S systemctl stop clover-bootmanager.service
	echo -e "$current_password\n" | sudo -S rm /etc/systemd/system/clover-bootmanager*
	echo -e "$current_password\n" | sudo -S sudo systemctl daemon-reload

	echo -e "$current_password\n" | sudo -S rm -f /etc/atomic-update.conf.d/clover-whitelist.conf

	echo -e "$current_password\n" | sudo -S steamos-readonly enable

	# delete dolphin root extension
	rm ~/.local/share/kservices5/ServiceMenus/open_as_root.desktop

	rm -rf ~/SteamDeck-Clover-dualboot
	rm -rf ~/1Clover-tools/
	rm ~/Desktop/Clover-Toolbox
	
	zenity --warning --title "Clover Toolbox" --text "Clover has been uninstalled and the Windows EFI entry has been activated!" --width 600 --height 75
	exit
fi
done
