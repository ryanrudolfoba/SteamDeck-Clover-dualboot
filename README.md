# Steam Deck - Installing Clover for Dual Boot Between SteamOS and Windows


## About

This repository contains the instructions and scripts on how to install [Clover - a graphical boot manager.](https://github.com/CloverHackyColor/CloverBootloader)

![image](https://user-images.githubusercontent.com/98122529/211457186-49b61cae-2f84-45ed-893c-c5edf1752418.png)

This will mostly benefit Steam Deck users who have setup a dual boot and wants to have a graphical way to select which OS to boot from.
> **NOTE**\
> If you are going to use this script for a video tutorial, PLEASE reference on your video where you got the script! This will make the support process easier!


## Disclaimer

1. Do this at your own risk!
2. This is for educational and research purposes only!


## But Why Use Another Boot Manager?!? Isn't *insert name of boot manager(s)* Enough?!?
> **NOTE1**\
> This is a continuation of my rEFInd script from [here.](https://github.com/ryanrudolfoba/SteamDeck-rEFInd-dualboot)\
> The things I learn from here will also trickle down to my rEFInd script, but my priority for now is Clover.\
> Originally I wanted to go with Clover, but there were some things I can't figure out last December. And then finally things just clicked in!\
> The design goal is pretty much the same from my rEFInd implementation - make as little changes as possible to the system.

> **NOTE2**\
> The config.plist for Clover is 1100+ lines! The config I have bundled here does the basic function - present SteamOS and Windows (on the internal SSD) for dual boot.\
> It is encouraged to please review the config.plist, make changes as needed for improvement and contribute back.

1. **NEW** - Use a different boot manager - Clover.
2. **NEW** - Does not rename / move Windows EFI entries! Finally I figured this one out because of a BUG / FEATURE in the UEFI firmware!
3. Does not rely on 3rd party systemd scripts / powershell scripts / EasyUEFI.
4. All-in-One script - install, disable / re-enable, uninstall!
5. Doesn't rely on pacman repositories - uses the latest (as of this writing V5151) Clover ISO from [here.](https://github.com/CloverHackyColor/CloverBootloader/releases/download/5151/Clover-5151-X64.iso.7z)


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
2. deck account should have a blank password, or change the password to "deck" (without the quotes). If you are not comfortable with this, then edit the script and change every occurence of "deck" to your preferred password.

**Prerequisites for Windows**
> **NOTE**\
> This applies to Windows installed on the internal SSD. I haven't tested external SSD / microSD.
1. No scripts / scheduled tasks related to rEFInd or EasyEUFI.
2. APU / GPU drivers has been installed and screen orientation set to Landscape.
3. Configure Unbranded Boot. This is to minimize the graphical glitches when booting Windows.
    * Go to Control Panel > Programs and Features > Turn Windows Features On or Off.
    * Expand "Device Lockdown", and then put a check mark on "Unbranded Boot"
    * Open command prompt with admin privileges and enter the commands to disable the boot graphics animation-\
        bcdedit.exe -set {globalsettings} bootuxdisabled on\
        bcdedit.exe -set {bootmgr} noerrordisplay on

## Using the Script
> **NOTE - please read carefully below**
> 1. Make sure you fully read and understand the disclaimer, warnings and pre-requisites!
> 2. The script will create a directory called ~/1Clover-tools with scripts to enable / disable Windows EFI and to uninstall Clover. Do not delete this folder!

> **IMPORTANT**\
> Once the install is completed, do not change the password for the deck account! Leave it as "deck" (without quotes).\
> This password is also used by the post install scripts located in ~/1Clover-tools

> **IMPORTANT2**\
> Because of a BUG / FEATURE in the UEFI firmware, I was able to "disable" the Windows Boot Manager without renaming / moving files.\
> There are only 3 scenarios that I know of that will revert back the Windows Boot Manager and make Windows the top priority -\
> a. If the SteamDeck is OFF and you press VOLDOWN + POWER or VOLUP + POWER, the Windows Boot Manager will get reactivated.\
> b. Performing a Windows Update will get the Windows Boot Manager reactivated.\
> c. From within Clover, if you select the EXIT CLOVER button it will reactivate the Windows Boot Manager.\
> When this happens, the easy fix is to boot back to SteamOS and run the disable-windows-efi.sh script to re-arrange the boot order.

Using the script is fairly easy -

1. Open a konsole terminal.
2. Clone the github repo. \
   cd ~/ \
   git clone https://github.com/ryanrudolfoba/SteamDeck-Clover-dualboot
   
3. Execute the script! \
   cd ~/SteamDeck-Clover-dualboot \
   chmod +x install-Clover.sh \
   ./install-Clover.sh
   ![image](https://user-images.githubusercontent.com/98122529/211460553-6dbb68ec-7f00-444c-accc-497a1b24a989.png)

4. Wait for script to finish the install.
   ![image](https://user-images.githubusercontent.com/98122529/211460686-23657b4a-4c05-4c29-8fce-31d5c2131815.png)

5. Reboot the Steam Deck. Clover is installed and you should see a GUI to select which OS to boot from! Use the DPAD and press A to confirm your choice. You can also use the trackpad to control the mouse pointer and use the RIGHT SHOULDER BUTTON for LEFT-CLICK.


## Screenshots
**SteamOS and Windows**
![image](https://user-images.githubusercontent.com/98122529/211457186-49b61cae-2f84-45ed-893c-c5edf1752418.png)



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
   ![image](https://user-images.githubusercontent.com/98122529/211462503-3efa275a-2210-4c05-bd0c-9554565533d3.png)
   
3. Reboot the Steam Deck and it will boot directly to Windows.
4. Make sure screen orientation is set to Landscape.
5. Make sure Unbranded Boot is configured and enabled.
6. Power off the Steam Deck. 
7. While powered off press VOLDOWN + Power and manually boot into SteamOS / rEFInd.
8. Open a konsole terminal and disable the Windows EFI - \
   cd ~/1Clover-tools \
   ./disable-windows-efi.sh\
   ![image](https://user-images.githubusercontent.com/98122529/211460833-6ba6893c-3768-4a34-b5bc-700815159771.png)
         
8. Reboot Steam Deck and it will boot back to the Clover graphical menu.

### Q3. I need to perform a GPU / APU driver upgrade in Windows. What do i do?

1. Boot into SteamOS.
2. Open a konsole terminal and re-enable the Windows EFI - \
   cd ~/1Clover-tools \
   ./enable-windows-efi.sh\
   ![image](https://user-images.githubusercontent.com/98122529/211462482-37f52b09-cdac-4e24-b17d-173babf50c13.png)
   
3. Reboot the Steam Deck and it will automatically load Windows.
4. Install the GPU / APU driver upgrade and reboot Windows.
5. After the reboot it will automatically load Windows.
6. Make sure screen orientation is set to Landscape.
7. Power off the Steam Deck.
8. While powered off press VOLDOWN + Power and manually boot into SteamOS / rEFInd.
9. Open a konsole terminal and disable the Windows EFI - \
   cd ~/1Clover-tools \
   ./disable-windows-efi.sh\
   ![image](https://user-images.githubusercontent.com/98122529/211460833-6ba6893c-3768-4a34-b5bc-700815159771.png)
   
7. Reboot Steam Deck and it will boot back to the Clover graphical menu.
       
### Q4. I reinstalled Windows and now it boots directly to Windows instead of Clover!

1. Power off the Steam Deck. 
2. While powered off press VOLDOWN + Power and manually boot into SteamOS / Clover.
3. Open a konsole terminal and disable the Windows EFI - \
   cd ~/1Clover-tools \
   ./disable-windows-efi.sh\
   ![image](https://user-images.githubusercontent.com/98122529/211460833-6ba6893c-3768-4a34-b5bc-700815159771.png)

3. Reboot the Steam Deck and it will boot back to the Clover graphical menu.

### Q5. Windows automatically installed updates and on reboot it goes automatically to Windows!
This is similar to Q4. Refer to Q4 on how to fix it.

### Q6. I hate Clover / I want to just dual boot the manual way / A better script came along and I want to uninstall your work!

1. Boot into SteamOS.
2. Open a konsole terminal and re-enable the Windows EFI - \
   cd ~/1Clover-tools \
   ./uninstall-Clover.sh\
   ![image](https://user-images.githubusercontent.com/98122529/211461011-90e03e00-e3fa-40ef-9ac9-7f853c21596c.png)
   
3. Reboot the Steam Deck and it will automatically load Windows. Clover has been uninstalled!

### Q7. I like your work how do I show a token of appreciation?
You can send me a message on reddit / discord to say thanks!
