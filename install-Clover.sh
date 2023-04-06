#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
CLOVER_VERSION='5151'

clear

echo Clover Install Script by ryanrudolf
echo https://github.com/ryanrudolfoba/SteamDeck-Clover-dualboot
sleep 2

# Password sanity check - make sure sudo password is already set by end user!
if [ "$(passwd --status deck | tr -s " " | cut -d " " -f 2)" == "P" ]
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
Choice=$(zenity --width 900 --height 250 --list --radiolist --multiple --title "Clover Install Script for Steam Deck - https://github.com/ryanrudolfoba/SteamDeck-clover-dualboot"\
	--column "Select One" \
	--column "Default OS" \
	--column="Comments - Read this carefully!"\
	FALSE Windows "Choose this and Windows will be the default OS selected in the Clover GUI boot menu."\
	FALSE SteamOS "Choose this and SteamOS will be the default OS selected in the Clover GUI boot menu."\
	TRUE EXIT "Select this if you changed your mind and don't want to proceed anymore.")

if [ $? -eq 1 ] || [ "$Choice" == "EXIT" ]
then
	echo User pressed CANCEL / EXIT. Make no changes. Exiting immediately.
	exit

else
	OS=$Choice
fi

# obtain Clover ISO
clover_archive=$(curl -s -O -L -w "%{filename_effective}" "https://github.com/CloverHackyColor/CloverBootloader/releases/download/${CLOVER_VERSION}/Clover-${CLOVER_VERSION}-X64.iso.7z")
clover_base=$(basename -s .7z $clover_archive)
7z x $clover_archive -aoa $clover_base

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
sudo mkdir -p /esp/efi/clover && sudo cp -Rf ~/temp-clover/efi/clover /esp/efi/ && sudo cp custom/$OS-config.plist /esp/efi/clover/config.plist && sudo cp -Rf custom/themes/* /esp/efi/clover/themes

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

# backup and disable the Windows EFI entry!
sudo cp /esp/efi/Microsoft/Boot/bootmgfw.efi /esp/efi/Microsoft/Boot/bootmgfw.efi.orig && sudo mv /esp/efi/Microsoft/Boot/bootmgfw.efi /esp/efi/Microsoft

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

sleep 2
echo \****************************************************************************************************
echo Post install scripts saved in 1Clover-tools. Use them as needed -
echo \****************************************************************************************************
echo enable-windows-efi.sh   -   Use this script to re-enable Windows EFI entry and temp disable Clover.
echo uninstall-Clover.sh     -   Use this to completely uninstall Clover from the EFI system partition.
echo \****************************************************************************************************
echo \****************************************************************************************************

#################################################################################
################################ post install ###################################
#################################################################################

# create ~/1Clover-tools and place the scripts in there
mkdir ~/1Clover-tools &> /dev/null
rm -f ~/1Clover-tools/* &> /dev/null

# enable-windows-efi.sh - use this to temporarily re-enable the Windows EFI entry
cat > ~/1Clover-tools/enable-windows-efi.sh << EOF
#!/bin/bash

# restore Windows EFI entry from backup
sudo cp /esp/efi/Microsoft/Boot/bootmgfw.efi.orig /esp/efi/Microsoft/Boot/bootmgfw.efi

# make Windows the next boot option!
Windows=\$(efibootmgr | grep -i Windows | colrm 9 | colrm 1 4)
sudo efibootmgr -n \$Windows &> /dev/null

echo Clover has been temporarily deactivated and Windows EFI entry has been re-enabled!
EOF

# uninstall-Clover.sh - use this to revert any changes made and uninstall Clover
cat > ~/1Clover-tools/uninstall-Clover.sh << EOF
#!/bin/bash

# restore Windows EFI entry from backup
sudo mv /esp/efi/Microsoft/Boot/bootmgfw.efi.orig /esp/efi/Microsoft/Boot/bootmgfw.efi
sudo rm /esp/efi/Microsoft/bootmgfw.efi

# remove Clover from the EFI system partition
sudo rm -rf /esp/efi/clover

for entry in \$(efibootmgr | grep "Clover - GUI" | colrm 9 | colrm 1 4)
do
	sudo efibootmgr -b \$entry -B &> /dev/null
done

rm -rf ~/1Clover-tools/*

# delete systemd service
sudo steamos-readonly disable
sudo systemctl stop clover-bootmanager.service
sudo rm /etc/systemd/system/clover-bootmanager.service
sudo systemctl daemon-reload
sudo steamos-readonly enable

# delete dolphin root extension
rm ~/.local/share/kservices5/ServiceMenus/open_as_root.desktop

# delete the injected systemd from the other rootfs
echo "mount -o rw,remount / ; sudo steamos-readonly disable ; sudo rm /etc/systemd/system/clover-bootmanager.service" | sudo steamos-chroot --partset other -- &> /dev/null

echo Clover has been uninstalled and the Windows EFI entry has been restored!
EOF

# post-install-Clover.sh
cat > ~/1Clover-tools/post-install-Clover.sh << EOF
#!/bin/bash

CloverStatus=/home/deck/1Clover-tools/status.txt

echo Clover Boot Manager > \$CloverStatus
date  >> \$CloverStatus
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
efibootmgr >> \$CloverStatus
chown deck:deck \$CloverStatus
EOF

#clover-bootmanager.service - systemd service that calls post-install-Clover.sh on startup
cat > ~/1Clover-tools/clover-bootmanager.service << EOF
[Unit]
Description=Custom systemd service for Clover - GUI Boot Manager.

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/bin/bash -c '/home/deck/1Clover-tools/post-install-Clover.sh'

[Install]
WantedBy=multi-user.target
EOF

# inject systemd service to the other rootfs
echo "mount -o rw,remount / ; sudo steamos-readonly disable ; echo -e \"
[Unit]
Description=Custom systemd service for Clover - GUI Boot Manager.

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/bin/bash -c '/home/deck/1Clover-tools/post-install-Clover.sh'

[Install]
WantedBy=multiuser.target
\" > /etc/systemd/system/clover-bootmanager.service" | sudo steamos-chroot --partset other -- &> /dev/null

echo "mount -o rw,remount / ; sudo steamos-readonly disable ; systemctl enable --now clover-bootmanager.service" | sudo steamos-chroot --partset other -- &> /dev/null

chmod +x ~/1Clover-tools/*
sudo cp ~/1Clover-tools/clover-bootmanager.service /etc/systemd/system/clover-bootmanager.service
sudo systemctl daemon-reload
sudo systemctl enable --now clover-bootmanager.service
