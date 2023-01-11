#!/bin/bash

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
		echo Sudo password is good!
	else
		echo Sudo password is wrong! Re-run the script and make sure to enter the correct sudo password!
		exit
	fi

else
	echo Sudo password is blank! Setup a sudo password first and then re-run script!
	passwd
	exit
fi

# sudo password is already set by the end user, all good let's go!
echo -e "$current_password\n" | sudo -S steamos-readonly disable &> /dev/null
if [ $? -eq 0 ]
then
	echo 1st sanity check. So far so good!
else
	echo Something went wrong on the 1st sanity check! Re-run script!
	exit
fi

# mount Clover ISO
sudo mkdir ~/temp-clover && sudo mount Clover-5151-X64.iso ~/temp-clover &> /dev/null
if [ $? -eq 0 ]
then
	echo 2nd sanity check. ISO has been mounted!
else
	echo Error mounting ISO!
	sudo umount ~/temp-clover
	rmdir ~/temp-clover
	exit
fi

# copy Clover files to EFI system partition
sudo mkdir -p /esp/efi/clover && sudo cp -Rf ~/temp-clover/efi/clover /esp/efi/ && sudo cp custom/config.plist /esp/efi/clover && sudo cp -Rf custom/themes/* /esp/efi/clover/themes

if [ $? -eq 0 ]
then
	echo 3rd sanity check. Clover has been copied to the EFI system partition!
else
	echo Error copying files. Something went wrong.
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


# Sanity check - is SteamOS EFI entry exists?
efibootmgr | grep "Steam" &> /dev/null

if [ $? -eq 0 ]
then
	echo 4th sanity check. SteamOS EFI entry is good, no action needed!
else
	echo 4th sanity check. SteamOS EFI entry does not exist! Re-creating SteamOS EFI entry.
	sudo efibootmgr -c -d /dev/nvme0n1 -p 1 -L "SteamOS" -l "\EFI\steamos\steamcl.efi" &> /dev/null
fi

# install Clover to the EFI system partition
sudo efibootmgr -c -d /dev/nvme0n1 -p 1 -L "Clover - GUI Boot Manager" -l "\EFI\clover\cloverx64.efi" &> /dev/null

# rearrange boot order and remove Windows from the EFI list!
Clover=$(efibootmgr |  grep -i Clover | colrm 9 | colrm 1 4)
SteamOS=$(efibootmgr | grep -i Steam | colrm 9 | colrm 1 4)
sudo efibootmgr -o $Clover,$SteamOS &> /dev/null 

sudo steamos-readonly enable &> /dev/null

# Final sanity check
efibootmgr | grep "Clover - GUI" &> /dev/null

if [ $? -eq 0 ]
then
	echo 5th sanity check. Clover has been successfully installed to the EFI system partition!
else
	echo Whoopsie something went wrong. Clover is not installed.
	exit
fi

sleep 2
echo \****************************************************************************************************
echo Post install scripts saved in 1Clover-tools. Use them as needed -
echo \****************************************************************************************************
echo enable-windows-efi.sh   -   Use this script to re-enable Windows EFI entry and temp disable Clover.
echo disable-windows-efi.sh  -   Use this script to disable Windows EFI entry and re-enable Clover.
echo uninstall-Clover.sh     -   Use this to completely uninstall Clover from the EFI system partition.
echo \****************************************************************************************************
echo \****************************************************************************************************

################################ post install ###################################

mkdir ~/1Clover-tools &> /dev/null
rm ~/1Clover-tools/*.sh &> /dev/null
cat > ~/1Clover-tools/enable-windows-efi.sh << EOF
#!/bin/bash

sudo steamos-readonly disable &> /dev/null

# rearrange boot order and make Windows EFI the top priority!
Clover=\$(efibootmgr |  grep -i Clover | colrm 9 | colrm 1 4)
SteamOS=\$(efibootmgr | grep -i SteamOS | colrm 9 | colrm 1 4)
Windows=\$(efibootmgr | grep -i Windows | colrm 9 | colrm 1 4)
sudo efibootmgr -o \$Windows,\$Clover,\$SteamOS &> /dev/null

sudo steamos-readonly enable &> /dev/null
echo Clover has been deactivated and Windows EFI entry has been re-enabled!
echo Run the script disable-windows-efi.sh to reactivate Clover!
EOF

cat > ~/1Clover-tools/disable-windows-efi.sh << EOF
#!/bin/bash

sudo steamos-readonly disable &> /dev/null

# rearrange boot order and remove Windows EFI from the list!
Clover=\$(efibootmgr |  grep -i Clover | colrm 9 | colrm 1 4)
SteamOS=\$(efibootmgr | grep -i SteamOS | colrm 9 | colrm 1 4)
sudo efibootmgr -o \$Clover,\$SteamOS &> /dev/null

sudo steamos-readonly enable &> /dev/null
echo Clover has been activated and Windows EFI entry has been disabled!
echo Run the script enable-windows-efi.sh to re-enable Windows EFI.
EOF

cat > ~/1Clover-tools/uninstall-Clover.sh << EOF
#!/bin/bash

sudo steamos-readonly disable &> /dev/null

# remove Clover from the EFI system partition
sudo rm -rf /esp/efi/clover

for entry in \$(efibootmgr | grep "Clover - GUI" | colrm 9 | colrm 1 4)
do
	sudo efibootmgr -b \$entry -B &> /dev/null
done

# rearrange boot order
SteamOS=\$(efibootmgr | grep -i SteamOS | colrm 9 | colrm 1 4)
Windows=\$(efibootmgr | grep -i Windows | colrm 9 | colrm 1 4)
sudo efibootmgr -o \$SteamOS,\$Windows &> /dev/null

grep -v 1Clover-tools ~/.bash_profile > ~/.bash_profile.temp
mv ~/.bash_profile.temp ~/.bash_profile

rm -rf ~/1Clover-tools/*

sudo steamos-readonly enable &> /dev/null

echo Clover has been uninstalled and the Windows EFI entry has been restored!
EOF

cat > ~/1Clover-tools/post-install-Clover.sh << EOF
#!/bin/bash

echo -e "$current_password\n" | sudo -S steamos-readonly disable &> /dev/null

# Sanity Check - are the needed EFI entries available?

efibootmgr | grep -i Clover &> /dev/null
if [ \$? -eq 0 ]
then
	echo Clover EFI entry exists! No need to re-add Clover.
else
	echo Clover EFI entry is not found. Need to re-ad Clover.
	sudo efibootmgr -c -d /dev/nvme0n1 -p 1 -L "Clover - GUI Boot Manager" -l "\EFI\clover\cloverx64.efi" &> /dev/null
fi

efibootmgr | grep -i Steam &> /dev/null
if [ \$? -eq 0 ]
then
	echo SteamOS EFI entry exists! No need to re-add SteamOS.
else
	echo SteamOS EFI entry is not found. Need to re-add SteamOS.
	sudo efibootmgr -c -d /dev/nvme0n1 -p 1 -L "SteamOS" -l "\EFI\steamos\steamcl.efi" &> /dev/null
fi

# Sanity Check - is Windows in the boot order?
CurrentBoot=\$(efibootmgr | grep -i bootorder | tr -s " "  | cut -d " "  -f 2 )
FirstBoot=\$(efibootmgr | grep -i bootorder | tr -s " "  | cut -d " "  -f 2 | cut -d "," -f 1)
Windows1=\$(efibootmgr | grep -i Windows | colrm 9 | colrm 1 4 | head -n1)
Windows2=\$(efibootmgr | grep -i Windows | colrm 9 | colrm 1 4 | tail -n1)
SteamOS=\$(efibootmgr | grep -i Steam | colrm 9 | colrm 1 4)
Clover=\$(efibootmgr | grep -i Clover | colrm 9 | colrm 1 4)

echo \$CurrentBoot - Current Boot Order
echo \$FirstBoot - First Boot Item
echo \$Windows1 - Windows1
echo \$Windows2 - Windows2
echo \$SteamOS - SteamOS
echo \$Clover - Clover

echo \$CurrentBoot | grep \$Windows1
if [ \$? -eq 0 ]
then
	echo Windows is in the boot order! Need to re-arrange the boot order!
	sudo efibootmgr -o \$Clover,\$SteamOS
else
	echo Windows is not in the boot order. Nothing needs to be done!
fi

echo \$CurrentBoot | grep \$Windows2
if [ \$? -eq 0 ]
then
	echo Windows is in the boot order! Need to re-arrange the boot order!
	sudo efibootmgr -o \$Clover,\$SteamOS
else
	echo Windows is not in the boot order. Nothing needs to be done!
fi

# Check if Clover is the first boot
echo \$FirstBoot | grep \$Clover
if [ \$? -eq 0 ]
then
	echo Clover is already the first boot order! Nothing needs to be done.
	echo "Clover is OK" > ~/1Clover-tools/status.txt
else
	echo Clover is not the first boot order. Need to re-arrange the boot order!
	sudo efibootmgr -o \$Clover,\$SteamOS
	echo "Clover is OK" > ~/1Clover-tools/status.txt
fi
EOF

grep 1Clover-tools ~/.bash_profile &> /dev/null
if [ $? -eq 0 ]
then
	echo Post install script already present no action needed! Clover install is done!
else
	echo Post install script not found! Adding post install script!
	echo "~/1Clover-tools/post-install-Clover.sh" >> ~/.bash_profile
	echo Post install script added! Clover install is done!
fi

chmod +x ~/1Clover-tools/*
