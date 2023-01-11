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


## But Why Use Another Boot Manager?!? What's Diffrent?!?
> **NOTE1**\
> This is a continuation of my rEFInd script from [here.](https://github.com/ryanrudolfoba/SteamDeck-rEFInd-dualboot)\
> The design goal is the same from my rEFInd implementation - make as little changes as possible to the system.\
> The script only copies files to the /esp/efi/clover location and manipulates the EFI boot orders. No files are renamed / moved.\
> Extra scripts are saved in ~/1Clover-tools which just manipulates the EFI boot orders, and an uninstall to reverse any changes made.\
> There are no extra systemd scripts created, no extra power shell scripts needed and no need for EasyUEFI.

> **NOTE2**\
> If the EFI boot entries are missing due to BIOS updates or due to official SteamOS updates, just manually reboot into SteamOS and it will fix the dual boot automatically. No need to type any commands!

> **NOTE3**\
> The config.plist for Clover is 1100+ lines! The config I have bundled here does the basic function - present SteamOS and Windows (on the internal SSD) for dual boot.\
> It is encouraged to please review the config.plist, make changes as needed for improvement and contribute back.

1. **NEW** - Use a different boot manager - Clover.
2. **NEW** - Does not rename / move Windows EFI entries.
3. **NEW** - When the dual boot breaks, just boot back manually to SteamOS and it will fix the dual boot entries on its own!
4. Does not rely on 3rd party systemd scripts / powershell scripts / EasyUEFI.
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

## Using the Script
> **NOTE1 - please read carefully below**
> 1. Make sure you fully read and understand the disclaimer, warnings and prerequisites!
> 2. The script will create a directory called ~/1Clover-tools with scripts to enable / disable Windows EFI and an uninstall to reverse any changes made. Do not delete this folder!

> **NOTE2**\
> The design goal is the same from my rEFInd implementation - make as little changes as possible to the system.\
> The script only copies files to the /esp/efi/clover location and manipulates the EFI boot orders. No files are renamed / moved.\
> Extra scripts are saved in ~/1Clover-tools which just manipulates the EFI boot orders, and an uninstall to reverse any changes made.\
> There are no extra systemd scripts created, no extra power shell scripts needed and no need for EasyUEFI.

Using the script is fairly easy -

1. Open a konsole terminal.
2. Clone the github repo. \
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
         ![image](https://user-images.githubusercontent.com/98122529/211833904-25c15d63-bd66-4da6-a6c1-d493966f0fb0.png)

         
5. Reboot the Steam Deck. Clover is installed and you should see a GUI to select which OS to boot from! Use the DPAD and press A to confirm your choice. You can also use the trackpad to control the mouse pointer and use the RIGHT SHOULDER BUTTON for LEFT-CLICK.
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

### Q2. Windows boots up in garbled graphics!
![image](https://user-images.githubusercontent.com/98122529/211198222-5cce38ff-3f20-4386-8715-c408fea6a4b0.png)

1. Boot into SteamOS.
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
2. Open a konsole terminal and re-enable the Windows EFI - \
   cd ~/1Clover-tools \
   ./enable-windows-efi.sh\
   ![image](https://user-images.githubusercontent.com/98122529/211840283-3a3039bc-bc67-4f2f-b5a5-e8d20aea5ecd.png)
   
3. Reboot the Steam Deck and it will automatically load Windows.
4. Install the GPU / APU driver upgrade and reboot Windows.
5. After the reboot it will automatically load Windows.
6. Make sure screen orientation is set to Landscape.
7. Power off the Steam Deck.
8. While powered off press VOLDOWN + Power and manually boot into SteamOS / rEFInd.
9. SteamOS will automatically fix the dual boot entries! On next reboot it will go back to Clover!
       
### Q4. I reinstalled Windows and now it boots directly to Windows instead of Clover!

1. Power off the Steam Deck. 
2. While powered off press VOLDOWN + Power and manually boot into SteamOS / Clover.
3. SteamOS will automatically fix the dual boot entries! On next reboot it will go back to Clover!
   
### Q5. Windows automatically installed updates and on reboot it goes automatically to Windows!
This is similar to Q4. Manually boot into SteamOS and it will automatically fix the dual boot entries! On next reboot it will go back to Clover!

### Q6. There was a SteamOS update and it wiped all my boot entries!
This happens even if not using dualboot / Clover / rEFInd.
1. Turn OFF the Steam Deck. While powered OFF, press VOLUP + POWER.
2. Go to Boot from File > efi > steamos > steamcl.efi
3. Wait until SteamOS boots up to game mode and thats it!

### Q7. I hate Clover / I want to just dual boot the manual way / A better script came along and I want to uninstall your work!

1. Boot into SteamOS.
2. Open a konsole terminal and run the uninstall script - \
   cd ~/1Clover-tools \
   ./uninstall-Clover.sh\
   ![image](https://user-images.githubusercontent.com/98122529/211840095-85745118-fa64-4ef8-b2c1-78dbf0443459.png)
   
3. Reboot the Steam Deck and it will automatically load Windows. Clover has been uninstalled!

### Q8. I like your work how do I show a token of appreciation?
You can send me a message on reddit / discord to say thanks!
