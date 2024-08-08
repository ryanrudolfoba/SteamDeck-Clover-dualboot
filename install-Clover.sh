#!/bin/bash

# define variables here
CLOVER=$(efibootmgr | grep -i Clover | colrm 9 | colrm 1 4)
STEAMOS=$(efibootmgr | grep -i SteamOS | colrm 9 | colrm 1 4)
REFIND=$(efibootmgr | grep -i rEFInd | colrm 9 | colrm 1 4)
CLOVER_VERSION=5157
CLOVER_URL=https://github.com/CloverHackyColor/CloverBootloader/releases/download/$CLOVER_VERSION/Clover-$CLOVER_VERSION-X64.iso.7z
CLOVER_ARCHIVE=$(curl -s -O -L -w "%{filename_effective}" $CLOVER_URL)
CLOVER_BASE=$(basename -s .7z $CLOVER_ARCHIVE)

clear

echo Clover Dual Boot Install Script 
echo Translated by Nicvank
sleep 2

if [ "$(passwd --status $(whoami) | tr -s " " | cut -d " " -f 2)" == "P" ]
then
    read -s -p "请输入当前sudo密码：" current_password ; echo
    echo 检查sudo密码是否正确。
    echo -e "$current_password\n" | sudo -S -k ls &> /dev/null

    if [ $? -eq 0 ]
    then
        echo Sudo密码是有效的！
    else
        echo Sudo密码是错误的！重新运行脚本并确保输入正确的sudo密码！
        exit
    fi
else
    echo Sudo密码是空白的！首先设置一个sudo密码，然后再重新运行脚本！
    passwd
    exit
fi

mkdir ~/temp-ESP
echo -e "$current_password\n" | sudo -S mount /dev/nvme0n1p1 ~/temp-ESP
if [ $? -eq 0 ]
then
    echo ESP已经挂载。
else
    echo ESP挂载失败。
    rmdir ~/temp-ESP
    exit
fi

ESP=$(df /dev/nvme0n1p1 --output=avail | tail -n1)
if [ $ESP -ge 15000 ]
then
    echo ESP分区有$ESP KB空闲空间。
    echo ESP分区有足够的空闲空间。
	echo -e "$current_password\n" | sudo -S umount ~/temp-ESP
	rmdir ~/temp-ESP
else
    echo ESP分区有$ESP KB空闲空间。
    echo ESPPartition中没有足够的空间!
    echo -e "$current_password\n" | sudo -S du -hd2 /esp
	echo -e "$current_password\n" | sudo -S umount ~/temp-ESP
	rmdir ~/temp-ESP
	exit
fi


efibootmgr | grep -i refind
if [ $? -ne 0 ]
then
    echo rEFInd未检测到！继续进行Clover安装。
else
    echo rEFInd似乎已经安装！尽力卸载rEFInd！
    for rEFInd_boot in $REFIND
    do
        echo -e "$current_password\n" | sudo -S efibootmgr -b $rEFInd_boot -B &> /dev/null
    done
    echo -e "$current_password\n" | sudo -S systemctl disable bootnext-refind.service &> /dev/null
    echo -e "$current_password\n" | sudo -S rm -rf /esp/efi/refind &> /dev/null
    echo -e "$current_password\n" | sudo -S rm /etc/systemd/system/bootnext-refind.service &> /dev/null
    rm -rf ~/.SteamDeck_rEFInd &> /dev/null


    efibootmgr | grep -i refind
    if [ $? -ne 0 ]
    then
    echo rEFInd已成功卸载！继续进行Clover安装。
    else
    echo rEFInd仍然安装。请手动卸载rEFInd！
    exit
    fi
fi


/usr/bin/7z x $CLOVER_ARCHIVE -aoa $CLOVER_BASE &> /dev/null
if [ $? -eq 0 ]
then
    echo 从github仓库下载了Clover！
else
    echo 下载Clover出错！ 
    exit
fi


mkdir ~/temp-clover &> /dev/null
echo -e "$current_password\n" | sudo -S mount $CLOVER_BASE ~/temp-clover &> /dev/null
if [ $? -eq 0 ]
then
    echo Clover ISO已挂载！
else
    echo 挂载ISO出错！ 
    echo -e "$current_password\n" | sudo -S umount ~/temp-clover
    rmdir ~/temp-clover
    exit
fi

# copy Clover files to EFI system partition
echo -e "$current_password\n" | sudo -S cp -Rf ~/temp-clover/efi/clover /esp/efi/
echo -e "$current_password\n" | sudo -S cp custom/config.plist /esp/efi/clover/config.plist 
echo -e "$current_password\n" | sudo -S cp -Rf custom/themes/* /esp/efi/clover/themes

# delete temp directories created and delete the Clover ISO
echo -e "$current_password\n" | sudo -S umount ~/temp-clover
rmdir ~/temp-clover
rm Clover-$CLOVER_VERSION-X64.iso*

# remove previous Clover entries before re-creating them
for entry in $CLOVER
do
	echo -e "$current_password\n" | sudo -S efibootmgr -b $entry -B &> /dev/null
done

# install Clover to the EFI system partition
echo -e "$current_password\n" | sudo -S efibootmgr -c -d /dev/nvme0n1 -p 1 -L "Clover - GUI Boot Manager" -l "\EFI\clover\cloverx64.efi" &> /dev/null
echo -e "$current_password\n" | sudo -S mv /esp/efi/boot/bootx64.efi /esp/efi/boot/bootx64.efi.orig 
echo -e "$current_password\n" | sudo -S cp /esp/efi/clover/cloverx64.efi /esp/efi/boot/bootx64.efi

# Backup and disable the Windows EFI entry!
echo -e "$current_password\n" | sudo -S cp /esp/efi/Microsoft/Boot/bootmgfw.efi /esp/efi/Microsoft/Boot/bootmgfw.efi.orig &> /dev/null
echo -e "$current_password\n" | sudo -S mv /esp/efi/Microsoft/Boot/bootmgfw.efi /esp/efi/Microsoft &> /dev/null

# re-arrange the boot order and make Clover the priority!
echo -e "$current_password\n" | sudo -S efibootmgr -n $CLOVER &> /dev/null
echo -e "$current_password\n" | sudo -S efibootmgr -o $CLOVER,$STEAMOS &> /dev/null


efibootmgr | grep "Clover - GUI" &> /dev/null
if [ $? -eq 0 ]
then
    echo Clover已成功安装到EFI系统分区！
else
    echo 哎呀! 出现了一些问题。Clover没有被安装。
    exit
fi
# create ~/1Clover-tools and place the scripts in there
mkdir ~/1Clover-tools &> /dev/null
rm -f ~/1Clover-tools/* &> /dev/null
cp custom/Clover-Toolbox.sh ~/1Clover-tools &> /dev/null
echo -e "$current_password\n" | sudo -S cp custom/clover-bootmanager.service custom/clover-bootmanager.sh /etc/systemd/system
cp -R custom/logos ~/1Clover-tools &> /dev/null
cp -R custom/efi ~/1Clover-tools &> /dev/null
#sudo cp ~/1Clover-tools/logos/SteamDeckLogo.png /esp/efi/steamos/steamos.png &> /dev/null

# make the scripts executable
chmod +x ~/1Clover-tools/Clover-Toolbox.sh
echo -e "$current_password\n" | sudo -S chmod +x /etc/systemd/system/clover-bootmanager.sh

# start the clover-bootmanager.service
echo -e "$current_password\n" | sudo -S systemctl daemon-reload
echo -e "$current_password\n" | sudo -S systemctl enable --now clover-bootmanager.service
echo -e "$current_password\n" | sudo -S /etc/systemd/system/clover-bootmanager.sh

# copy dolphin root extension to easily add themes
mkdir -p ~/.local/share/kservices5/ServiceMenus
cp custom/open_as_root.desktop ~/.local/share/kservices5/ServiceMenus


ln -s ~/1Clover-tools/Clover-Toolbox.sh ~/Desktop/Clover-Toolbox &> /dev/null
echo Clover Toolbox的桌面图标已创建！

echo Clover安装完成！ 
