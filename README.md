# Steam Deck - Installing Clover for Dual Boot Between SteamOS and Windows


## About

This repository contains the instructions and scripts on how to install [Clover - a graphical boot manager.](https://github.com/CloverHackyColor/CloverBootloader)

This will mostly benefit Steam Deck users who have setup a dual boot and wants to have a graphical way to select which OS to boot from.
> **NOTE**\
> If you are going to use this script for a video tutorial, PLEASE reference on your video where you got the script! This will make the support process easier!

## Disclaimer
1. Do this at your own risk!
2. This is for educational and research purposes only!

## What's New (as of January 26 2023)
1. **added experimental version (this is what i use)** - no need for Windows powershell script / scheduled task.
2. color coded the install script - if the output is RED then something went wrong.
3. updated script and scheduled task on the Windows side.
4. updated config.plist to support Windows, Batocera and Ventoy on microSD / external SSD.
5. easily add / remove themes via drag and drop / copy-paste in Dolphin file manager.
6. add multiple themes and Clover will automatically choose a random theme on each reboot.
7. Catalina and Mojave theme bundled by default.
8. community contributed icons / logos for SteamOS and Batocera (thanks to WindowsOnDeck reddit members u/ch3vr0n5 and u/ChewyYui)
9. re-wrote and re-organized the README.

## Old Changelog - January 11 2023
1. Initial Release based on [Clover v5151.](https://github.com/CloverHackyColor/CloverBootloader/releases/download/5151/Clover-5151-X64.iso.7z)
2. Does not rename / move Windows EFI entries.
3. When the dual boot breaks, just boot back manually to SteamOS and it will fix the dual boot entries on its own.
4. Makes as few changes as possible - doesn't rely on pacman repositories, no systemd scripts and no EasyUEFI.
5. All-in-One script - install, disable / re-enable, uninstall.

## Screenshots
**Catalina - SteamOS, Windows and Batocera (microSD)**
![image](https://user-images.githubusercontent.com/98122529/214861561-bb63c209-14ee-492a-a506-2a87665f52d3.png)


**Mojave - SteamOS, Windows and Batocera (microSD)**
![image](https://user-images.githubusercontent.com/98122529/214861730-66b21114-09bd-43f4-ae30-f1c3efb24d4a.png)

**Easily add / remove themes using Dolphin File Manager**
![image](https://user-images.githubusercontent.com/98122529/214928509-7d6cae5e-107e-4bcd-baa7-2051f6ddb269.png)


## !!! WARNING - WARNING - WARNING !!!
> **WARNING!**\
> Please carefully read the items below!
1. The script has been thoroughly tested on a fresh SteamOS and Windows install.
2. If your SteamOS has prior traces of rEFInd or scripts / systemd services related to rEFInd, it is suggested to uninstall / remove those first before proceeding.
3. If your Windows install has scripts or programs related to rEFInd / EasyUEFI, it is suggested to uninstall / remove those first before proceeding.

**I don't know what the behavior will be if those are present in the system. Remove them first before using this script!**

## Prerequisites for SteamOS and Windows
**Prerequisites for SteamOS**
1. No prior traces of rEFInd or scripts / systemd services related to rEFInd.
2. sudo password should already be set by the end user. If sudo password is not yet set, the script will ask to set it up.

**Prerequisites for Windows**
> **NOTE**\
> This applies to Windows installed on the internal SSD / external SSD / microSD.
1. No scripts / scheduled tasks related to rEFInd or EasyUEFI.
2. APU / GPU drivers has been installed and screen orientation set to Landscape.
3. This is VERY IMPORTANT! Do not skip this step -
    * Open command prompt with admin privileges and enter the command -\
        bcdedit.exe -set {globalsettings} highestmode on
        

## Using the Script
> **NOTE - please read carefully**
> 1. Make sure you fully read and understand the disclaimer, warnings and prerequisites!
> 2. The script creates a directory called ~/1Clover-tools with extra scripts to enable / disable Windows EFI and an uninstall to reverse any changes made. Do not delete this folder!
> 3. The installation is divided into 2 parts - 1 for SteamOS, and 1 for Windows. The recommended way is to do the steps on SteamOS first, and then do the steps for Windows.

> **What does the script do / change on the SteamOS side?!?**\
> The script copies files to the /esp/efi/clover location and manipulates the EFI boot orders. No files are renamed / moved.\
> Extra scripts are saved in ~/1Clover-tools which manipulates the EFI boot orders, and an uninstall to reverse any changes made.\
> There are no extra systemd scripts created.

> **What does the script do / change on the Windows side?!?**\
> The script creates a folder called C:\1Clover-tools and creates a Scheduled Task called CloverTask-donotdelete.\
> The Scheduled Task runs a powershell script saved in C:\1Clover-tools. The powershell script queries the EFI entries and sets Clover to be the next boot entry.


**Installation Steps for SteamOS**
> **NOTE1 - please read carefully**\
> If you are using an older version of my script, it is recommended to uninstall it first before installing the new one!\
> To uninstall the old version, please follow the steps in FAQ Q7.\
> There is now an experimental version that is much easier and quicker to install as it doesn't need any scripts / scheduled task on the Windows side.

1. Go into Desktop Mode.
2. Open a konsole terminal.
3. Clone the github repo. \
   cd ~/ \
   git clone https://github.com/ryanrudolfoba/SteamDeck-Clover-dualboot
   
3. Execute the script!
   > NOTE: There is an experimental version that is much easier and quicker to install. If you want to use the experimental version instead, then perform this steps -\
   > chmod +x experimental-install-Clover.sh\
   > ./experimental-install-Clover.sh\
   > \
   > Once the install is done then that's it! Reboot and enjoy Clover. But if you don't want to use the experimental version then do the steps below!

   cd ~/SteamDeck-Clover-dualboot \
   chmod +x install-Clover.sh \
   ./install-Clover.sh
   ![image](https://user-images.githubusercontent.com/98122529/211831914-b170e57c-1d45-426c-9861-c0659c0531f6.png)

4. The script will check if sudo passwword is already set.\
   **4a.**
         If it is already set, enter the current sudo password and the script will continue.\
         If wrong password is provided the script will exit immdediately. Re-run the script and enter the correct sudo password!
         ![image](https://user-images.githubusercontent.com/98122529/215194972-02cbcdf2-0d8e-41cf-b39c-417049d1b5c6.png)

   **4b.**
         If the sudo password is blank / not yet set by the end user, the script will prompt to setup the sudo password. Re-run the script to continue.
         ![image](https://user-images.githubusercontent.com/98122529/215194796-58b9c638-d21a-4e26-a1c9-12743fd36196.png)

   **4c.**
         Script will continue to run and perform sanity checks all throughout the install process.
         ![image](https://user-images.githubusercontent.com/98122529/215194418-20597cef-4851-440d-b1c5-9428662349ad.png)
         
         If there is an error on step5, then you need to manually download the zip file when doing the steps for Windows.
         ![image](https://user-images.githubusercontent.com/98122529/215194686-00c1a2aa-c429-4b76-8ca7-c526bc59e2c2.png)         

   **4d.**
         If there is an error on step5, then you need to manually download the zip file when doing the steps for Windows.
         ![image](https://user-images.githubusercontent.com/98122529/215194686-00c1a2aa-c429-4b76-8ca7-c526bc59e2c2.png)
         
5. Reboot the Steam Deck. Clover is installed and you should see a GUI to select which OS to boot from! Use the DPAD and press A to confirm your choice. You can also use the trackpad to control the mouse pointer and use the RIGHT SHOULDER BUTTON for LEFT-CLICK.
![image](https://user-images.githubusercontent.com/98122529/214861561-bb63c209-14ee-492a-a506-2a87665f52d3.png)


**Installation Steps for Windows**
> NOTE: If you use the experimental script for Clover, then no need for this steps!

> NOTE2: Check first if the script has been copied to C:\1Clover-tools. If CloverWindows.bat is there already then just follow step 3 onwards.\
> If C:\1Clover-tools doesn't exist then start from step 1.

1. Download the ZIP by pressing the GREEN CODE BUTTON, then select Download ZIP.
![image](https://user-images.githubusercontent.com/98122529/212368293-2b5f59ac-b480-4f72-b7c5-3122e57476e4.png)

2. Go to your Downloads folder and then extract the zip.
3. Right click CloverWindows.bat and select RUNAS Administrator.

![image](https://user-images.githubusercontent.com/98122529/212368736-c9b10eb0-ecfe-4ccb-b035-1aa55f959d94.png)

4. The script will automatically create the C:\1Clover-tools folder and copy the files in there.\
5. It will also automatically create the Scheduled Task called CloverTask-donotdelete
![image](https://user-images.githubusercontent.com/98122529/212368944-9be9e55a-ce96-43d8-9fb0-bf5f17a2bcc8.png)

6. Go to Task Scheduler and the CloverTask will show up in there.
7. Right-click the CloverTask and select Properties.
![image](https://user-images.githubusercontent.com/98122529/212369284-76266936-d9d6-495e-aaf9-44d3abb7b129.png)

8. Under the General tab, make sure it looks like this. Change it if it doesn't then press OK.
![image](https://user-images.githubusercontent.com/98122529/212369626-8a02f229-3a94-45d0-ad1f-929a4a7e51be.png)

9. Right click the task and select RUN.

![image](https://user-images.githubusercontent.com/98122529/212369786-6a973906-a849-4c60-85cb-556963754997.png)

10. Close Task Scheduler. Go to C:\1Clover-tools and look for the file called status.txt.

11. Open status.txt and the Clover GUID should be the same as the bootsequence. Sample below.
![image](https://user-images.githubusercontent.com/98122529/212370053-2bd6dbd8-3d21-43a9-8498-cd0f156c6b9c.png)

12. Reboot and you should see a GUI to select which OS to boot from! Use the DPAD and press A to confirm your choice. You can also use the trackpad to control the mouse pointer and use the RIGHT SHOULDER BUTTON for LEFT-CLICK.
![image](https://user-images.githubusercontent.com/98122529/214861561-bb63c209-14ee-492a-a506-2a87665f52d3.png)


## How to Add / Remove Themes
> **NOTE**
> The esp partition is only 64MB in size. This is where SteamOS, Windows and Clover EFI entries are saved.\
> The free space on the esp partition is around ~25MB. Make sure the themes you download don't exceed this size!\
> You can have multiple themes installed and Clover will automatically pick a random theme on every reboot!

1. Boot into Desktop Mode.
2. Open a konsole terminal and verify you have enough space in the esp partition -\
   df -h | grep "File\\|esp"
   
   On this example there is still around 27MB free space -\
   ![image](https://user-images.githubusercontent.com/98122529/214897987-72936746-47c7-4996-b60f-26bae249d9cb.png)

2. Visit the [Clover Themes github](https://github.com/CloverHackyColor/CloverThemes) to download the themes.
3. Open Dolphin File Manager.
4. Navigate to /esp on the lower left side. It will say "Could not enter folder /esp"
   ![image](https://user-images.githubusercontent.com/98122529/214927546-75e5cd14-1c0a-499d-8491-d5221e20f3a8.png)

6. Right-click and select "Open as Root."
   ![image](https://user-images.githubusercontent.com/98122529/214929527-f9e9a435-f715-4803-88f9-5b30e043a84c.png)

8. Enter the sudo password when prompted.

   ![image](https://user-images.githubusercontent.com/98122529/214928042-eda04c7e-41d0-4d0f-9ae8-6aa3003b5032.png)
   

9. A new folder will appear for the esp partition.
   ![image](https://user-images.githubusercontent.com/98122529/214928185-8a34143c-f78f-4ed6-b5a6-edc7e2b1998a.png)

10. Navigate to efi > clover > themes. It will show a list of themes installed. By default it will show 3 - random, Catalina and Mojave.
   ![image](https://user-images.githubusercontent.com/98122529/214928509-7d6cae5e-107e-4bcd-baa7-2051f6ddb269.png)

11. **Don't delete the random folder!** It is needed so that when there are multiple themes installed, Clover will randomly pick a theme on every reboot.
12. Delete the themes you don't want and copy / paste new themes that you have downloaded.
13. Reboot and enjoy the new theme!

> **NOTE**
> When adding your own theme, make sure to name your custom SteamOS and Batocera icons as follows -\
> os_steamos.icns\
> os_batocera.icns\
> This are just regular PNG files, but you have to rename them to have the icns file extension.\
> Sample icons are saved in custom\iconset folder. Thanks to WindowsOnDeck reddit members u/ch3vr0n5 and u/ChewyYui !!!

## FAQ / Troubleshooting
Read this for your Common Questions and Answers! This will be regularly updated and some of the answers in here are contributions from the [WindowsOnDeck reddit community!](https://www.reddit.com/r/WindowsOnDeck/)


### Q0. How do I check that the ISO is not tampered?

Use a hash file calculator. Verify that the hash matches -\
MD5 - ef49756644c5fdd5f243aba830b59fb\
SHA1 - c6e97f23e651b84bec33e9658f534a0a3b8cae8\
SHA256 - a1849489103f82b3cb0dc97cf93d7b656f837b9e54507434ce0f0b24158ad991\
SHA384 - ebc10f31977f0c32e9f842cd3114f7c425de7edaf94d0f60f4de260420ee1020074e265c130dde88f763a8573825f094\

### Q1. Windows shows strange vertical lines at the center when booting up!
![image](https://user-images.githubusercontent.com/98122529/211201387-36311ba8-7ac4-44e7-938c-25d5ed2a3e5f.png)

1. Boot to Windows.
2. Open command prompt with admin privileges and enter the command -\
   bcdedit.exe -set {globalsettings} highestmode on
      

### Q2. Windows boots up in garbled graphics!
![image](https://user-images.githubusercontent.com/98122529/211198222-5cce38ff-3f20-4386-8715-c408fea6a4b0.png)

1. Boot into SteamOS.
2. Go to Desktop Mode.
3. Open a konsole terminal and re-enable the Windows EFI - \
   cd ~/1Clover-tools \
   ./enable-windows-efi.sh\
   ![image](https://user-images.githubusercontent.com/98122529/211840322-46c3ab90-2ed4-4abc-84a6-ae82cce1d917.png)
   
4. Reboot the Steam Deck and it will boot directly to Windows.
6. Open command prompt with admin privileges and enter the command -\
   bcdedit.exe -set {globalsettings} highestmode on

7. Make sure screen orientation is set to Landscape.
8. Reboot and it will go back to Clover!

### Q3. I need to perform a GPU / APU driver upgrade in Windows. What do I do?

1. Boot into SteamOS.
2. Go to Desktop Mode.
3. Open a konsole terminal and re-enable the Windows EFI - \
   cd ~/1Clover-tools \
   ./enable-windows-efi.sh\
   ![image](https://user-images.githubusercontent.com/98122529/212214891-ea322f50-2704-4676-b550-9071d41947ff.png)
   
3. Reboot the Steam Deck and it will automatically load Windows.
4. Install the GPU / APU driver upgrade and reboot Windows.
5. After the reboot it will go back to Clover.
6. Select Windows and wait until it loads.
7. Make sure screen orientation is set to Landscape.
8. If everything looks good, reboot and it will go back to Clover.

       
### Q4. I reinstalled Windows and now it boots directly to Windows instead of Clover!

1. If you used the experimental version then just manually reboot to SteamOS and it will fix it on its own.\
2. If you didn't use the experimantal version then follow the steps for the Windows install.

### Q5. Windows automatically installed updates and on reboot it goes automatically to Windows!
1. Manually boot into SteamOS and it will automatically fix the dual boot entries.
2. On the next reboot it will go to Clover.

### Q6. There was a SteamOS update and it wiped all my boot entries!
This happens even if not using dualboot / Clover / rEFInd.
1. Turn OFF the Steam Deck. While powered OFF, press VOLUP + POWER.
2. Go to Boot from File > efi > steamos > steamcl.efi
3. Wait until SteamOS boots up and it will automatically fix the dual boot entries.
4. On the next reboot it will go to Clover.

### Q7. I hate Clover / I want to just dual boot the manual way / A better script came along and I want to uninstall your work!

1. Boot into SteamOS.
2. Open a konsole terminal and run the uninstall script - \
   cd ~/1Clover-tools \
   ./uninstall-Clover.sh\
   ![image](https://user-images.githubusercontent.com/98122529/211840095-85745118-fa64-4ef8-b2c1-78dbf0443459.png)
   
3. Reboot the Steam Deck and it will automatically load Windows. Clover has been uninstalled!

### Q8. I like your work how do I show a token of appreciation?
You can send me a message on reddit / discord to say thanks!
