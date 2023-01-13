# Steam Deck - Installing Clover for Dual Boot Between SteamOS and Windows


## About

This repository contains the instructions and scripts on how to install [Clover - a graphical boot manager.](https://github.com/CloverHackyColor/CloverBootloader)

This will mostly benefit Steam Deck users who have setup a dual boot and wants to have a graphical way to select which OS to boot from.
> **NOTE**\
> If you are going to use this script for a video tutorial, PLEASE reference on your video where you got the script! This will make the support process easier!

## Screenshots

![image](https://user-images.githubusercontent.com/98122529/211849206-72c5d027-1d38-413d-9673-34c2ae36abfe.png)
![image](https://user-images.githubusercontent.com/98122529/211849287-31965fef-030a-4b80-9082-5be677e3e005.png)
![image](https://user-images.githubusercontent.com/98122529/211457186-49b61cae-2f84-45ed-893c-c5edf1752418.png)
![image](https://user-images.githubusercontent.com/98122529/211794305-7408975f-6d1b-4ba0-808d-5700f7b78ef8.png)
![image](https://user-images.githubusercontent.com/98122529/211794427-0753e4fc-f96d-492a-bd2b-f2b59464b509.png)


## Disclaimer

1. Do this at your own risk!
2. This is for educational and research purposes only!


## But Why Use Another Boot Manager?!? What's Different?!?
> **NOTE1**\
> This is a continuation of my rEFInd script from [here.](https://github.com/ryanrudolfoba/SteamDeck-rEFInd-dualboot)\
> The design goal is the same from my rEFInd implementation - make as little changes as possible to the system.

> **For the SteamOS side**\
> The script copies files to the /esp/efi/clover location and manipulates the EFI boot orders. No files are renamed / moved.\
> Extra scripts are saved in ~/1Clover-tools which manipulates the EFI boot orders, and an uninstall to reverse any changes made.\
> There are no extra systemd scripts created, ~~no extra power shell scripts needed~~ and no need for EasyUEFI.

> **For the Windows side**\
> The script creates a folder called C:\1Clover-tools and creates a Scheduled Task.\
> The Scheduled Task runs the powershell script saved in C:\1Clover-tools. The powershell script queries the EFI entries and sets Clover to be the next boot entry.

> **NOTE2**\
> If the EFI boot entries are missing due to BIOS updates or due to official SteamOS updates, just manually reboot into SteamOS and it will fix the dual boot automatically. No need to type any commands!

> **NOTE3**\
> The config.plist for Clover is 1100+ lines! The config I have bundled here does the basic function - present SteamOS and Windows (on the internal SSD) for dual boot.\
> It is encouraged to please review the config.plist, make changes as needed for improvement and contribute back.

1. **NEW** - Use a different boot manager - Clover.
2. **NEW** - Does not rename / move Windows EFI entries.
3. **NEW** - When the dual boot breaks, just boot back manually to SteamOS and it will fix the dual boot entries on its own!
4. Does not rely on 3rd party systemd scripts / ~~powershell scripts~~ / EasyUEFI.
5. All-in-One script - install, disable / re-enable, uninstall!
6. Doesn't rely on pacman repositories - uses the latest (as of this writing V5151) Clover ISO from [here.](https://github.com/CloverHackyColor/CloverBootloader/releases/download/5151/Clover-5151-X64.iso.7z)


## !!! WARNING - WARNING - WARNING !!!
> **WARNING!**\
> Please carefully read the items below!
1. The script has been thoroughly tested on a fresh SteamOS and Windows install.
2. If your SteamOS has prior traces of rEFInd or scripts / systemd services related to rEFInd, it is suggested to uninstall / remove those first before proceeding. If you were using my rEFInd script then it's all good as I don't use systemd services.
3. If your Windows install has scripts or programs related to rEFInd / EasyUEFI, it is suggested to uninstall / remove those first before proceeding.

I don't know what the behavior will be if those are present in the system. Remove them first before using this script!

## Prerequisites for SteamOS and Windows
**Prerequisites for SteamOS**
1. No prior traces of rEFInd or scripts / systemd services related to rEFInd.
2. sudo password should already be set by the end user. If sudo password is not yet set, the script will ask to set it up.

**Prerequisites for Windows**
> **NOTE**\
> This applies to Windows installed on the internal SSD / external SSD / microSD.
1. No scripts / scheduled tasks related to rEFInd or EasyUEFI.
2. APU / GPU drivers has been installed and screen orientation set to Landscape.
3. Configure Unbranded Boot. This is to minimize the graphical glitches when booting Windows.
    * Go to Control Panel > Programs and Features > Turn Windows Features On or Off.
    * Expand "Device Lockdown", and then put a check mark on "Unbranded Boot"
    * Open command prompt with admin privileges and enter the commands to disable the boot graphics animation-\
        bcdedit.exe -set {globalsettings} bootuxdisabled on\
        bcdedit.exe -set {bootmgr} noerrordisplay on

Alternative Solution -
1. Boot to Windows.
2. Go to Start > Run > msconfig
3. Click the Boot tab.
4. Put a check mark on NO GUI BOOT.

![image](https://user-images.githubusercontent.com/98122529/212195550-45ddb14f-463e-4f63-ac81-6e685737aa3d.png)


## Using the Script
> **NOTE1 - please read carefully below**
> 1. Make sure you fully read and understand the disclaimer, warnings and prerequisites!
> 2. The script will create a directory called ~/1Clover-tools with scripts to enable / disable Windows EFI and an uninstall to reverse any changes made. Do not delete this folder!

> **NOTE2**\
> The design goal is the same from my rEFInd implementation - make as little changes as possible to the system.

> **For the SteamOS side**\
> The script copies files to the /esp/efi/clover location and manipulates the EFI boot orders. No files are renamed / moved.\
> Extra scripts are saved in ~/1Clover-tools which manipulates the EFI boot orders, and an uninstall to reverse any changes made.\
> There are no extra systemd scripts created, ~~no extra power shell scripts needed~~ and no need for EasyUEFI.

> **For the Windows side**\
> The script creates a folder called C:\1Clover-tools and creates a Scheduled Task.\
> The Scheduled Task runs the powershell script saved in C:\1Clover-tools. The powershell script queries the EFI entries and sets Clover to be the next boot entry.

> **NOTE3**\
> The installation is divided into 2 parts - 1 for SteamOS, and 1 for Windows.\
> The recommended way is to do the steps on SteamOS first, and then do the steps for Windows.


**Installation Steps for SteamOS**

1. Go into Desktop Mode.
2. Open a konsole terminal.
3. Clone the github repo. \
   cd ~/ \
   git clone https://github.com/ryanrudolfoba/SteamDeck-Clover-dualboot
   
3. Execute the script! \
   cd ~/SteamDeck-Clover-dualboot \
   chmod +x install-Clover.sh \
   ./install-Clover.sh
   ![image](https://user-images.githubusercontent.com/98122529/211831914-b170e57c-1d45-426c-9861-c0659c0531f6.png)

4. The script will check if sudo passwword is already set.\
   **4a.**
         If it is already set, enter the current sudo password and the script will continue.\
         If wrong password is provided the script will exit immdediately. Re-run the script and enter the correct sudo password!
         ![image](https://user-images.githubusercontent.com/98122529/211832404-dd234fd2-33af-4b3b-834b-10ecc2b0d1c3.png)

   **4b.**
         If the sudo password is blank / not yet set by the end user, the script will prompt to setup the sudo password. Re-run the script to continue.
         ![image](https://user-images.githubusercontent.com/98122529/211833223-f7a096e5-9ae3-4481-8ad1-569e6f21adb0.png)

   **4c.**
         Script will continue to run and perform sanity checks all throughout the install process.
         ![image](https://user-images.githubusercontent.com/98122529/212214600-7df4d15a-fbe3-4aee-bd38-5b1d1175313c.png)

         
5. Reboot the Steam Deck. Clover is installed and you should see a GUI to select which OS to boot from! Use the DPAD and press A to confirm your choice. You can also use the trackpad to control the mouse pointer and use the RIGHT SHOULDER BUTTON for LEFT-CLICK.
![image](https://user-images.githubusercontent.com/98122529/211849206-72c5d027-1d38-413d-9673-34c2ae36abfe.png)


**Installation Steps for Windows**
1. Download the ZIP by pressing the GREEN CODE BUTTON, then select Download ZIP.
![image](https://user-images.githubusercontent.com/98122529/212368293-2b5f59ac-b480-4f72-b7c5-3122e57476e4.png)

2. Go to your Downloads folder and then extract the zip.
3. Right click CloverWindows.bat and select RUNAS Administrator.
![image](https://user-images.githubusercontent.com/98122529/212368736-c9b10eb0-ecfe-4ccb-b035-1aa55f959d94.png)

4. The script will automatically create the C:\1Clover-tools folder and copy the files in there.
5. It will also automatically create the Scheduled Task called CloverTask-donotdelete
![image](https://user-images.githubusercontent.com/98122529/212368944-9be9e55a-ce96-43d8-9fb0-bf5f17a2bcc8.png)

5. Go to Task Scheduler and the CloverTask will show up in there.
5. Right-click the CloverTask and select Properties.
![image](https://user-images.githubusercontent.com/98122529/212369284-76266936-d9d6-495e-aaf9-44d3abb7b129.png)

6. Under the General tab, make sure it looks like this. Change it if it doesn't then press OK.
![image](https://user-images.githubusercontent.com/98122529/212369626-8a02f229-3a94-45d0-ad1f-929a4a7e51be.png)

7. Right click the task and select RUN.
![image](https://user-images.githubusercontent.com/98122529/212369786-6a973906-a849-4c60-85cb-556963754997.png)

8. Close Task Scheduler. Go to C:\1Clover-tools and look for the file called status.txt.

9. Open status.txt and the Clover GUID should be the same as the bootsequence. Sample below.
![image](https://user-images.githubusercontent.com/98122529/212370053-2bd6dbd8-3d21-43a9-8498-cd0f156c6b9c.png)

10. Reboot and you should see a GUI to select which OS to boot from! Use the DPAD and press A to confirm your choice. You can also use the trackpad to control the mouse pointer and use the RIGHT SHOULDER BUTTON for LEFT-CLICK.
![image](https://user-images.githubusercontent.com/98122529/211849206-72c5d027-1d38-413d-9673-34c2ae36abfe.png)

## FAQ / Troubleshooting
Read this for your Common Questions and Answers!


### Q0. How do I check that the ISO is not tampered?

Use a hash file calculator. Verify that the hash matches -\
MD5 - ef49756644c5fdd5f243aba830b59fb\
SHA1 - c6e97f23e651b84bec33e9658f534a0a3b8cae8\
SHA256 - a1849489103f82b3cb0dc97cf93d7b656f837b9e54507434ce0f0b24158ad991\
SHA384 - ebc10f31977f0c32e9f842cd3114f7c425de7edaf94d0f60f4de260420ee1020074e265c130dde88f763a8573825f094\

### Q1. Windows shows strange vertical lines at the center when booting up!
![image](https://user-images.githubusercontent.com/98122529/211201387-36311ba8-7ac4-44e7-938c-25d5ed2a3e5f.png)

1. Boot to Windows.
2. Go to Control Panel > Programs and Features > Turn Windows Features On or Off.
3. Expand "Device Lockdown", and then put a check mark on "Unbranded Boot"
![image](https://user-images.githubusercontent.com/98122529/211198710-68105c60-3710-4e9d-bf44-11ab7bc1e67e.png)
4. Open command prompt with admin privileges and enter the commands to disable the boot graphics animation -\
   bcdedit.exe -set {globalsettings} bootuxdisabled on\
   bcdedit.exe -set {bootmgr} noerrordisplay on

Alternative Solution -
1. Boot to Windows.
2. Go to Start > Run > msconfig
3. Click the Boot tab.
4. Put a check mark on NO GUI BOOT.

![image](https://user-images.githubusercontent.com/98122529/212195550-45ddb14f-463e-4f63-ac81-6e685737aa3d.png)

### Q2. Windows boots up in garbled graphics!
![image](https://user-images.githubusercontent.com/98122529/211198222-5cce38ff-3f20-4386-8715-c408fea6a4b0.png)

1. Boot into SteamOS.
2. Go to Desktop Mode.
8. Open a konsole terminal and re-enable the Windows EFI - \
   cd ~/1Clover-tools \
   ./enable-windows-efi.sh\
   ![image](https://user-images.githubusercontent.com/98122529/211840322-46c3ab90-2ed4-4abc-84a6-ae82cce1d917.png)
   
3. Reboot the Steam Deck and it will boot directly to Windows.
4. Make sure screen orientation is set to Landscape.
5. Make sure Unbranded Boot is configured and enabled.
6. Power off the Steam Deck. 
7. While powered off press VOLDOWN + Power and manually boot into SteamOS / Clover.
8. SteamOS will automatically fix the dual boot entries! On next reboot it will go back to Clover!

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

1. Follow the steps for the Windows install.

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
