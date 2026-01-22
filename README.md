# Steam Deck and Legion Go S - Installing Clover Script for Dual Boot Between SteamOS (or Bazzite) and Windows (and other OSes too!)

## About

A collection of tools that is packaged into an easy to use script that is streamlined and tested to work with the Steam Deck and Lenovo Legion Go S running on SteamOS.

* The main program that does all the heavy lifting is [Clover - a graphical boot manager / boot loader.](https://github.com/CloverHackyColor/CloverBootloader)
* Clover Toolbox is a shell script that offers a simple GUI to configure some aspects of Clover script.
* Custom systemd script that performs a sanity check whenever SteamOS starts up making sure that the dual boot is intact and repairs it automatically if needed.

## What's New as of July 07 2025
1. Add Legion GO support 83E1 variant

## What's New as of April 25 2025
1. Add Legion GO S support with different variants - 83Q2 83Q3 83N6 83L3
2. automatically set config.plist to enable mouse and use screen resolution 1920x1200 when running on Legion GO S
3. add support for DeckSight OLED panel
4. Clover 5161

## What's New (as of December 31 2024)
1. Windows to GO SDCARD config updated. [Use this guide to configure Clover for Windows to GO SDCARD](https://youtu.be/DPUEjOTkTDY)
2. Cleanup the README.

<details>
<summary><b>Old Changelog - Click here for more details</b></summary>
<p><b>October 25 2024</b><br>
1. Updated Clover EFI from 5159 to 5160. <br>
2. Implemented Clover whitelist - make sure you are on SteamOS 3.6.x for the whitelist to work correctly! <br>
3. Script can now be installed in Bazzite! <br>
4. Updated icons for Bazzite. <br>
5. Added sanity check - make sure SteamOS / Bazzite is installed before Windows! (sorry WinDeckOS users) </p><br>

<p><b>May 19 2024</b>b<br>
1. Removed the 7z sanity check as this is now installed by default in SteamOS 3.5.x / 3.6.x <br>
2. Added ESP sanity check - make sure there is enough space in ESP before doing anything <br>
3. Removed option for Windows To Go sdcard - you shouldn't run Windows from sdcard anyways! This will also fix the issue of intermittently showing Windows To Go sdcard when Windows is updated. <br>
4. code cleanup </p><br>

<p><b>January 21 2024</b></br>
1. Minor update to easily change config between Batocera v38 and the upcoming Batocera v39. <br>

Launch Clover Toolbox and select Batocera to choose between Batocera v38 or Batocera v39 - <br>
![image](https://github.com/ryanrudolfoba/SteamDeck-Clover-dualboot/assets/98122529/e256e284-5643-419e-9ed0-267b6210d17a)

Select v39 or v38 - <br>
![image](https://github.com/ryanrudolfoba/SteamDeck-Clover-dualboot/assets/98122529/804dbd8d-067e-41da-b8c3-ab7b828cb94e)

Config will be updated based on user selection - <br>
![image](https://github.com/ryanrudolfoba/SteamDeck-Clover-dualboot/assets/98122529/ba82a2b5-9035-4705-86bd-a2a7ef283061)

![image](https://github.com/ryanrudolfoba/SteamDeck-Clover-dualboot/assets/98122529/471ee338-956a-4e9c-9e5c-af115a98cdca)
</p>

<p><b>January 15 2024)</b></br>
1. Updated for Clover release 5157. <br>
2. Added an option in Clover Toolbox to use custom Clover 5157. This hides the OPTIONS button. <br>
3. Added an option in Clover Toolbox to select the default grey embedded theme. </p><br>

<p><b>December 12 2023</b><br>
1. Updated for Clover release 5156 <br>
2. New Steam Deck OLED BGRT Logo </p><br>

<p><b>October 28 2023</b><br>
1. Updated the script to fix the issue of theme names not getting parsed correctly. Thanks to u/Brian_H8951 for pointing out the issue and the fix! </p><br>

<p><b>October 26 2023</b><br>
1. add sanity check for 7z binary. If the binary doesnt exist then the SteamOS is very old need to update SteamOS first! <br>
2. Clover Toolbox - capture the free space on EFI partition. Useful when doing troubleshooting. <br>
3. Custom BGRT / Logo will be displayed when the Steam Deck is powered on. </p><br>

<p><b>September 26 2023</b><br>
1. Does not rely on HackBGRT anymore! I've integrated my [BGRT Logo Changer script.](https://github.com/ryanrudolfoba/SteamDeck-Logo-Changer) <br>
2. Added SteamOS version number, build number and kernel number on the custom systemd script (useful when troubleshooting) <br>
3. Code cleanup on the Clover Toolbox <br>
4. Updated config.plist </p><br>
 
<p><b>September 13 2023</b><br>
1. added notification dialog box after changing themes <br>
2. resized BMPs and new config for HackBGRT </p><br>
   
<p><b>September 12 2023</b><br>
1. Perform best effort to automatically remove rEFInd if it is previously installed <br>
2. Clover 5155 - thanks @imfelixlaw for the [PR #23.](https://github.com/ryanrudolfoba/SteamDeck-Clover-dualboot/pull/23) <br>
3. Updated config.plist to use Apocalypse theme by default (I chose this theme as this looks good on my Switch Deck!) <br>
4. Updated config.plist to support Pop!_OS <br>
5. Updated config.plist to reflect Nobara and Bazzite <br>
6. New config and new logos for HackBGRT (Windows Internal SSD only) <br>
7. Clover Toolbox - option to set static theme or random theme <br>
8. Clover Toolbox - option for DeckHD 1200p screen mod </p><br>
   
<p><b>July 30 2023</b><br>
1. Updated Clover from 5151 to 5154 </p><br>

<p><b>May 24 2023</b><br>
1. cleanup the Clover Toolbox menu so it is easier to read <br>
2. cleanup the config.plist </p><br>
   
<p><b>May 19 2023</b><br>
1. bugfix - fixed the issue where it shows duplicate Windows icon when Windows is installed on sdcard / external SSD. <br>
2. Clover Toolbox - a simple GUI to toggle settings. <br>
3. added desktop shortcut to easily access Clover Toolbox. <br>
4. added several Linux distros - CentOS, Debian, Manjaro. </p><br>

<p><b>April 23 2023</b><br>
1. added new themes - Apocalypse, Crystal, Gothic, Rick and Morty. <br>
2. re-write the inject systemd service on the other rootfs. <br>
3. added custom splash screen when booting Windows from the internal SSD. <br>
4. add Clover Boot Manager Service status as non-Steam game to easily check the systemd service from within Game Mode. </p><br>

<p><b>March 31 2023</b><br>
1. have a simple menu during install to select which OS will be the default in the Clover GUI boot menu. <br>
2. implement systemd service / inject systemd service on the other rootfs. </p><br>

<p><b>March 11 2023</b><br>
1. rewrote the script <a href="https://github.com/ryanrudolfoba/SteamDeck-Clover-dualboot/issues/7">(thanks arkag!)</a> so it pulls the ISO directly from the Clover repositories. <br>
2. updated the config.plist so it supports more OS automatically - Kali, Ubuntu and Fedora. </p><br>
   
<p><b>February 20 2023</b><br>
1. added more sanity checks and cleanup in the post-install script. <br>
2. cleaned up the config.plist so it is more manageable and easier to read. <br>
3. changed the mouse pointer speed to 20 to close the <a href="https://github.com/ryanrudolfoba/SteamDeck-Clover-dualboot/issues/3">issue reported here.</a> </p><br>

<p><b>January 26 2023</b><br>
1. <b>added experimental version (this is what i use)</b> - no need for Windows powershell script / scheduled task. <br>
2. color coded the install script - if the output is RED then something went wrong. <br>
3. updated script and scheduled task on the Windows side. <br>
4. updated config.plist to support Windows, Batocera and Ventoy on microSD / external SSD. <br>
5. easily add / remove themes via drag and drop / copy-paste in Dolphin file manager. <br>
6. add multiple themes and Clover will automatically choose a random theme on each reboot. <br>
7. Catalina and Mojave theme bundled by default. <br>
8. community contributed icons / logos for SteamOS and Batocera (thanks to WindowsOnDeck reddit members u/ch3vr0n5 and u/ChewyYui). <br>
9. re-wrote and re-organized the README. </p><br>

<p><b>January 11 2023</b><br>
1. Initial Release based on <a href="https://github.com/CloverHackyColor/CloverBootloader/releases/tag/5151">Clover v5151.</a> <br>
2. Does not rename / move Windows EFI entries. <br>
3. When the dual boot breaks, just boot back manually to SteamOS and it will fix the dual boot entries on its own. <br>
4. Makes as few changes as possible - doesn't rely on pacman repositories, no systemd scripts and no EasyUEFI. <br>
5. All-in-One script - install, disable / re-enable, uninstall. </p><br>
</details>


> **NOTE**\
> If you are going to use this script for a video tutorial, PLEASE reference on your video where you got the script! This will make the support process easier!
> And don't forget to give a shoutout to [@10MinuteSteamDeckGamer](https://www.youtube.com/@10MinuteSteamDeckGamer/) / ryanrudolf from the Philippines!
>

<b> If you like my work please show support by subscribing to my [YouTube channel @10MinuteSteamDeckGamer.](https://www.youtube.com/@10MinuteSteamDeckGamer/) </b> <br>
<b> I'm just passionate about Linux, Windows, how stuff works, and playing retro and modern video games on my Steam Deck! </b>
<p align="center">
<a href="https://www.youtube.com/@10MinuteSteamDeckGamer/"> <img src="https://github.com/ryanrudolfoba/SteamDeck-Clover-dualboot/blob/main/10minute.png"/> </a>
</p>

<b>Monetary donations are also encouraged if you find this project helpful. Your donation inspires me to continue research on the Steam Deck! Clover script, 70Hz mod, SteamOS microSD, Secure Boot, etc.</b>

<b>Scan the QR code or click the image below to visit my donation page.</b>

<p align="center">
<a href="https://www.paypal.com/donate/?business=VSMP49KYGADT4&no_recurring=0&item_name=Your+donation+inspires+me+to+continue+research+on+the+Steam+Deck%21%0AClover+script%2C+70Hz+mod%2C+SteamOS+microSD%2C+Secure+Boot%2C+etc.%0A%0A&currency_code=CAD"> <img src="https://github.com/ryanrudolfoba/SteamDeck-Clover-dualboot/blob/main/QRCode.png"/> </a>
</p>

## Disclaimer
1. Do this at your own risk! <br>
2. This is for educational and research purposes only! <br>

I've created and has been using this script since December 2022 and a lot of users are reporting success too. You are in good hands - I know what I'm doing but I just need the standard disclaimer to protect myself from any liability.

## [Video Tutorial - How to Install Clover for Steam Deck dual boot](https://www.youtube.com/watch?v=HDnxOw6j3EY&t=975s)
[Click the image below for a video tutorial and to see the functionalities of the script!](https://www.youtube.com/watch?v=HDnxOw6j3EY&t=975s)
</b>
<p align="center">
<a href="https://www.youtube.com/watch?v=heo2yFycnsM"> <img src="https://github.com/ryanrudolfoba/SteamDeck-Clover-dualboot/blob/main/banner.png"/> </a>
</p>

## Quick Install Steps - if you are in a hurry then this is what you need (but really you should read the rest of the README!)
Perform some Windows config first! Boot to Windows and open elevated command prompt or PowerShell -
1. ```cmd
   bcdedit.exe -set "{globalsettings}" highestmode on
   ```
2. ```cmd
   reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\TimeZoneInformation" /v RealTimeIsUniversal /d 1 /t REG_DWORD /f
   ```

Once done, boot to SteamOS to install Clover!
1. Boot into SteamOS, then go into Desktop Mode and open a konsole terminal.<br>
2. Clone the github repo. <br>
   ```cmd
   cd ~/
   ```
   ```cmd
   git clone https://github.com/ryanrudolfoba/SteamDeck-Clover-dualboot
   ```
   
   If it errors that folder already exists, delete the old folder first - <br>
   ```cmd
   rm -rf ~/SteamDeck-Clover-dualboot
   ```
   
   Then perform the clone again - <br>
   ```cmd
   git clone https://github.com/ryanrudolfoba/SteamDeck-Clover-dualboot
   ```
   
3. Execute the script! <br>
   ```cmd
   cd ~/SteamDeck-Clover-dualboot
   ```
   ```cmd
   chmod +x install-Clover.sh
   ```
   ```cmd
   ./install-Clover.sh
   ```
   
     ![image](https://github.com/user-attachments/assets/043d8e7c-9d57-48b2-a1ad-f93c94cf3e9f)

4. The script will check if sudo passwword is already set. <br>
    - If it is already set, enter the current sudo password and the script will continue.
    - If wrong password is provided the script will exit immdediately. Re-run the script and enter the correct sudo password!
    - If the sudo password is blank / not yet set by the end user, the script will prompt to setup the sudo password. Re-run the script to continue.
    - Script will continue to run and perform sanity checks all throughout the install process.
                     
5. Reboot the Steam Deck. Clover is installed and you should see a GUI to select which OS to boot from! Use the DPAD and press A to confirm your choice. You can also use the trackpad to control the mouse pointer and use the RIGHT SHOULDER BUTTON for LEFT-CLICK.<br>
![image](https://user-images.githubusercontent.com/98122529/214861561-bb63c209-14ee-492a-a506-2a87665f52d3.png)<br>

**6a. OPTIONAL - If you have Windows installed on SDCARD (not recommended) or External SSD you need to do this additional step -**\
`sudo cp custom/config_sdcard_plist /esp/efi/clover/config.plist`

<b>6b. OPTIONAL - Scheduled Task for Windows. Use this only if you have Windows installed on microSD / external SSD and if Windows keeps hijacking the bootloader!</b>
<details>
<summary><b>Use this only if you have Windows installed on microSD / external SSD and if Windows keeps hijacking the bootloader!</b></summary>

1. Download the ZIP by pressing the GREEN CODE BUTTON, then select Download ZIP.<br>

![image](https://user-images.githubusercontent.com/98122529/212368293-2b5f59ac-b480-4f72-b7c5-3122e57476e4.png)<br>

2. Go to your Downloads folder and then extract the zip.<br>
3. Right click CloverWindows.bat and select RUNAS Administrator.<br>
![image](https://user-images.githubusercontent.com/98122529/212368736-c9b10eb0-ecfe-4ccb-b035-1aa55f959d94.png)<br>

4. The script will automatically create the C:\1Clover-tools folder and copy the files in there. <br>
5. It will also automatically create the Scheduled Task called CloverTask-donotdelete. <br>
![image](https://user-images.githubusercontent.com/98122529/212368944-9be9e55a-ce96-43d8-9fb0-bf5f17a2bcc8.png)<br>

6. Go to Task Scheduler and the CloverTask will show up in there.<br>
7. Right-click the CloverTask and select Properties.<br>
![image](https://user-images.githubusercontent.com/98122529/212369284-76266936-d9d6-495e-aaf9-44d3abb7b129.png)<br>

8. Under the General tab, make sure it looks like this. Change it if it doesn't then press OK.<br>
![image](https://user-images.githubusercontent.com/98122529/212369626-8a02f229-3a94-45d0-ad1f-929a4a7e51be.png)<br>

9. Right click the task and select RUN.<br>
![image](https://user-images.githubusercontent.com/98122529/212369786-6a973906-a849-4c60-85cb-556963754997.png)<br>

10. Close Task Scheduler. Go to C:\1Clover-tools and look for the file called status.txt.<br>
11. Open status.txt and the Clover GUID should be the same as the bootsequence. Sample below.<br>
![image](https://user-images.githubusercontent.com/98122529/212370053-2bd6dbd8-3d21-43a9-8498-cd0f156c6b9c.png)<br>

12. Reboot and you should see a GUI to select which OS to boot from! Use the DPAD and press A to confirm your choice. You can also use the trackpad to control the mouse pointer and use the RIGHT SHOULDER BUTTON for LEFT-CLICK.<br>
![image](https://user-images.githubusercontent.com/98122529/214861561-bb63c209-14ee-492a-a506-2a87665f52d3.png)<br>
</details>

## Why Use this Clover install script for dual boot?!?
1. Makes as little changes as possible to the SteamOS / Windows installation.
2. Makes dual boot with SteamOS / Windows easy with a nice GUI.
3. No extra config needed for Ventoy, Batocera, Kali, Ubuntu and Fedora. (if there are other OS you want to be added just let me know)
4. Automatically and easily re-create the dual boot entries if it gets broken by a BIOS / SteamOS / Windows update. No need to type manual commands!
5. Supports random themes (Mojave and Catalina bundled in the install script), add / remove themes, icons, background using Dolphin File Manager.

## Screenshots
**Apocalypse - SteamOS, Windows and Batocera (microSD)**
![image](https://user-images.githubusercontent.com/98122529/233867354-4d554a4e-1e1f-42f7-968a-31a8c0b677b2.png)

**Clover Toolbox**
![image](https://github.com/ryanrudolfoba/SteamDeck-Clover-dualboot/assets/98122529/8308d81f-99f6-4751-abf1-3ebb8436322a)

<details>
<summary><b>More Screenshots Here</b></summary>

<b>Custom Windows Splash Screen</b><br>
![image](https://user-images.githubusercontent.com/98122529/233867095-5946c34a-5e63-41e4-bc56-5e8d6a261d0f.png)<br>

<b>Gothic - SteamOS, Windows, Batocera (microSD) and Fedora</b><br>
![image](https://user-images.githubusercontent.com/98122529/233867306-15377bfa-91e7-4f9d-abea-d346be6099be.png)<br>

<b>Catalina - SteamOS, Windows, and Batocera (microSD)</b><br>
![image](https://user-images.githubusercontent.com/98122529/214861561-bb63c209-14ee-492a-a506-2a87665f52d3.png)<br>

<b>Crystal - SteamOS, Windows, Batocera (microSD) and Fedora</b><br>
![image](https://user-images.githubusercontent.com/98122529/233867450-b87b0704-38b7-41a5-89e6-b39567b440ac.png)<br>

<b>Rick and Morty - SteamOS, Windows, Batocera (microSD) and Fedora</b><br>
![image](https://user-images.githubusercontent.com/98122529/233867485-d91f4bae-4139-431a-9fb1-730f3c74f5f1.png)<br>

<b>Select which OS will be the default in the Clover GUI boot menu</b><br>
![image](https://user-images.githubusercontent.com/98122529/229242673-0966ef48-9b6b-41ba-8269-2e8c1d9caca1.png)<br>

<b>Catalina - SteamOS, Windows, Batocera (microSD) and Fedora</b><br>
![image](https://user-images.githubusercontent.com/98122529/224508836-c170c472-da02-441e-9709-6950d3d47332.png)<br>

<b>Mojave - SteamOS, Windows, Ventoy (microSD) and Fedora</b><br>
![image](https://user-images.githubusercontent.com/98122529/224508862-6fd10d7c-eb96-4a0e-aeff-d59034e6bd7c.png)<br>

<b>Mojave - SteamOS, Windows and Batocera (microSD)</b><br>
![image](https://user-images.githubusercontent.com/98122529/214861730-66b21114-09bd-43f4-ae30-f1c3efb24d4a.png)<br>

<b>Mojave - SteamOS, Windows on Internal SSD and Windows on External SSD / microSD</b><br>
![image](https://user-images.githubusercontent.com/98122529/232523110-77cd7616-cca4-40c4-9a5e-cbc003afae80.png)
![image](https://user-images.githubusercontent.com/98122529/232523294-21c5ed46-ee02-4688-b65f-e3ea15b6bcd8.png)

<b>Mojave - SteamOS, Windows, Ubuntu and Kali (pic not mine)</b><br>
![image](https://user-images.githubusercontent.com/98122529/224509169-ae7e41ae-a870-4227-a16f-d79e7877bea5.png)<br>

<b>Easily add / remove themes using Dolphin File Manager</b><br>
![image](https://user-images.githubusercontent.com/98122529/214928509-7d6cae5e-107e-4bcd-baa7-2051f6ddb269.png)<br>
</details>

## How to Add / Remove Themes
<details>
<summary><b>Read this first - ESP partition size</b></summary>
The esp partition is only 64MB in size. This is where SteamOS, Windows and Clover EFI entries are saved.<br>
The free space on the esp partition is around ~25MB. Make sure the themes you download don't exceed this size!<br>
You can have multiple themes installed and Clover will automatically pick a random theme on every reboot!<br>
</details>

<details>
<summary><b>Read this first - custom icons</b></summary>
When adding your own theme, make sure to name your custom SteamOS and Batocera icons as follows - <br>
os_steamos.icns<br>
os_batocera.icns<br>
This are just regular PNG files, but you have to rename them to have the icns file extension.<br>
Sample icons are saved in custom\iconset folder. Thanks to WindowsOnDeck reddit members u/ch3vr0n5 and u/ChewyYui !!!<br>
</details>

<details>
<summary><b>Steps to Add / Delete Themes</b></summary>
1. Boot into Desktop Mode and then open Dolphin File Manager.<br>
2. Navigate to /esp on the lower left side. It will say "Could not enter folder /esp"<br>

   ![image](https://user-images.githubusercontent.com/98122529/214927546-75e5cd14-1c0a-499d-8491-d5221e20f3a8.png)<br>

3. Right-click and select "Open as Root."<br>
   ![image](https://user-images.githubusercontent.com/98122529/214929527-f9e9a435-f715-4803-88f9-5b30e043a84c.png)<br>

4. Enter the sudo password when prompted.<br>

   ![image](https://user-images.githubusercontent.com/98122529/214928042-eda04c7e-41d0-4d0f-9ae8-6aa3003b5032.png)<br>
   

5. A new folder will appear for the esp partition.<br>
   Take note of the free space located in the lower right side. On this example the free space is around 26MB.<br>
   ![image](https://user-images.githubusercontent.com/98122529/215268989-56a661dc-e2c5-40fb-b57e-9b49a4de93a7.png)<br>

6. Visit the [Clover Themes github](https://github.com/CloverHackyColor/CloverThemes) to download the themes. Make sure the themes you download doesn't exceed the free space of the esp partition from step5.<br>

7. Navigate to efi > clover > themes. It will show a list of themes installed. By default it will show 3 - random, Catalina and Mojave.<br>
   ![image](https://user-images.githubusercontent.com/98122529/214928509-7d6cae5e-107e-4bcd-baa7-2051f6ddb269.png)<br>

8. **Don't delete the random folder!** It is needed so that when there are multiple themes installed, Clover will randomly pick a theme on every reboot.<br>
9. Delete the themes you don't want and copy / paste new themes that you have downloaded.<br>
10. Reboot and enjoy the new theme!<br>
</details>

## FAQ / Troubleshooting
Read this for your Common Questions and Answers! This will be regularly updated and some of the answers in here are contributions from the [WindowsOnDeck reddit community!](https://www.reddit.com/r/WindowsOnDeck/)

### How to Update to a Newer Version?!?
From time to time I update this repo for new version of the script. It may include bug fixes, new features or an updated Clover EFI version. \
To update to a new version -
1. Go to Desktop Mode and launch Clover Toolbox.
2. Select Uninstall
3. Clone the repo again to get the latest version and perform the install steps.

<details>
<summary><b>Q0. Windows on microSD / external SSD doesn't get picked up automatically!</b></summary>
1. Make sure that it is setup as GPT and Windows-to-Go in Rufus. <br>

![image](https://user-images.githubusercontent.com/98122529/229247790-8511dc09-b56e-4e3f-ae59-bd11b21fc07c.png)<br>
</details>

<details>
<summary><b>Q1. Windows shows strange vertical lines at the center when booting up!</b></summary>

![image](https://user-images.githubusercontent.com/98122529/211201387-36311ba8-7ac4-44e7-938c-25d5ed2a3e5f.png)<br>
1. Boot to Windows.<br>
2. Open command prompt with admin privileges and enter the command -<br>
   bcdedit.exe -set {globalsettings} highestmode on<br>
</details>
      
<details>
<summary><b>Q2. Windows boots up in garbled graphics!</b></summary>
   
![image](https://user-images.githubusercontent.com/98122529/211198222-5cce38ff-3f20-4386-8715-c408fea6a4b0.png)<br>

1. Boot to SteamOS.<br>
2. Go to Desktop Mode.<br>
3. Double-click Clover Toolbox desktop icon. <br>
4. Select the item called Service and press OK. <br>

![image](https://github.com/ryanrudolfoba/SteamDeck-Clover-dualboot/assets/98122529/f7299f1a-989b-4f0b-864f-3a527162a6b5)
   
5. Press the item called Disable and press OK. <br>
![image](https://github.com/ryanrudolfoba/SteamDeck-Clover-dualboot/assets/98122529/0be15a60-6513-4608-8642-412dd0a7646e)
   
![image](https://github.com/ryanrudolfoba/SteamDeck-Clover-dualboot/assets/98122529/decb3a9d-7499-4df1-b7a4-abd3e23fa892)

6. Reboot and it will automatically boot to Windows. <br>

7. Open command prompt with admin privileges and enter the command -<br>
   bcdedit.exe -set {globalsettings} highestmode on <br>

8. Make sure screen orientation is set to Landscape.<br>
9. If everything looks good then shutdown the Steam Deck.<br>
10. Press VOLDOWN + POWER and select SteamOS from the list.<br>
11. Follow step2 onwards, and on step 5 select the item called Enable. <br>
   
![image](https://github.com/ryanrudolfoba/SteamDeck-Clover-dualboot/assets/98122529/2fd5b3ef-5247-49da-886c-2095e3ce44f3)
   
![image](https://github.com/ryanrudolfoba/SteamDeck-Clover-dualboot/assets/98122529/d9c5ecd2-0426-40fd-8fb0-88f38ba54b55)
   
12. Reboot and it will go back to Clover!
</details>

<details>
<summary><b>Q3. I need to perform a GPU / APU driver upgrade in Windows. What do I do?</b></summary>
1. Boot to SteamOS.<br>
2. Go to Desktop Mode.<br>
3. Double-click Clover Toolbox desktop icon. <br>
4. Select the item called Service and press OK. <br>

![image](https://github.com/ryanrudolfoba/SteamDeck-Clover-dualboot/assets/98122529/f7299f1a-989b-4f0b-864f-3a527162a6b5)
   
5. Press the item called Disable and press OK. <br>
![image](https://github.com/ryanrudolfoba/SteamDeck-Clover-dualboot/assets/98122529/0be15a60-6513-4608-8642-412dd0a7646e)
   
![image](https://github.com/ryanrudolfoba/SteamDeck-Clover-dualboot/assets/98122529/decb3a9d-7499-4df1-b7a4-abd3e23fa892)

6. Reboot and it will automatically boot to Windows. <br>
7. Install the GPU / APU driver upgrade and reboot Windows.<br>
8. Make sure screen orientation is set to Landscape.<br>
9. If everything looks good then shutdown the Steam Deck.<br>
10. Press VOLDOWN + POWER and select SteamOS from the list.<br>
11. Follow step2 onwards, and on step 5 select the item called Enable. <br>
   
![image](https://github.com/ryanrudolfoba/SteamDeck-Clover-dualboot/assets/98122529/2fd5b3ef-5247-49da-886c-2095e3ce44f3)
   
![image](https://github.com/ryanrudolfoba/SteamDeck-Clover-dualboot/assets/98122529/d9c5ecd2-0426-40fd-8fb0-88f38ba54b55)
   
12. Reboot and it will go back to Clover!
</details>
       
<details>
<summary><b>Q4. I reinstalled Windows and now it boots directly to Windows instead of Clover!</b></summary>
1. Shutdown the Steam Deck. While powered OFF, press VOLDOWN + POWER and select SteamOS from the list.<br>
2. Script will automatically fix the dual boot entries! Reboot and it will go back to Clover!<br>
</details>

<details>
<summary><b>Q5. Windows automatically installed updates and on reboot it goes automatically to Windows!</b></summary>
1. Shutdown the Steam Deck. While powered OFF, press VOLDOWN + POWER and select SteamOS from the list.<br>
2. Script will automatically fix the dual boot entries! Reboot and it will go back to Clover!<br>
</details>

<details>
<summary><b>Q6. There was a SteamOS update and it wiped all my boot entries!</b></summary>
This happens even if not using dualboot / Clover / rEFInd.<br>
1. Shutdown the Steam Deck. While powered OFF, press VOLUP + POWER.<br>
2. Go to Boot from File > efi > steamos > steamcl.efi<br>
3. Script will automatically fix the dual boot entries! Reboot and it will go back to Clover!<br>
</details>

<details>
<summary><b>Q7. The time is always getting messed up!</b></summary>
1. Boot to Windows. <br>
2. Open command prompt with admin privileges and enter the command -<br>
   reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\TimeZoneInformation" /v RealTimeIsUniversal /d 1 /t REG_DWORD /f <br> <br>
3. Reboot the Steam Deck for changes to take effect. <br>
</details>

<details>
<summary><b>Q8. I see 'Error mounting ISO!' when attempting to run the Clover script!</b></summary>
This can happen if you have an old version of SteamOS installed or have installed SteamOS from the recovery image which is missing 7zip.<br>
1. Boot to SteamOS. <br>
2. Perform a System Update by going to Steam > Settings > System > Check for Updates <br>
3. Once update has completed, restart in to SteamOS. <br>
4. Go to Desktop Mode and rerun the Clover script. <br>
</details>

<details>
<summary><b>Q9. I hate Clover / I want to just dual boot the manual way / A better script came along and I want to uninstall your work!</b></summary>
1. Boot into SteamOS.<br>
2. Go to Desktop Mode.<br>
3. Double-click Clover Toolbox desktop icon. <br>
4. Select the item called Uninstall and press OK. <br>
   
![image](https://github.com/ryanrudolfoba/SteamDeck-Clover-dualboot/assets/98122529/dced41a9-74e3-4dca-a90d-38e0e373614a)

4. Clover will be uninstalled and on next reboot it will automatically load Windows. Clover has been uninstalled!<br>
</details>

<details>
<summary><b>Q10. I like your work how do I show a token of appreciation?</b></summary>
If you like my work please show support by subscribing to my <a href="https://www.youtube.com/@10MinuteSteamDeckGamer">YouTube channel @10MinuteSteamDeckGamer.</a> <br>
</details>

<details>
<summary><b>Q11. Do you accept donations?</b></summary>
Monetary donations are also encouraged if you find this project helpful. Your donation inspires me to continue research on the Steam Deck! Clover script, 70Hz mod, SteamOS microSD, Secure Boot, etc.

Scan the QR code or click the image below to visit my donation page.

<p align="center">
<a href="https://www.paypal.com/donate/?business=VSMP49KYGADT4&no_recurring=0&item_name=Your+donation+inspires+me+to+continue+research+on+the+Steam+Deck%21%0AClover+script%2C+70Hz+mod%2C+SteamOS+microSD%2C+Secure+Boot%2C+etc.%0A%0A&currency_code=CAD"> <img src="https://github.com/ryanrudolfoba/SteamDeck-Clover-dualboot/blob/main/QRCode.png"/> </a>
</p>
</details>

## Known issues
### Issues with external display with resolution higher than 1080p
If Steam Deck is connected to an external display with a resolution **higher than 1080p** (1440p, 4K, etc.), there are some issues that Clover may cause.
* Clover screen **will be rotated**. See images below for examples. Once an OS is started, the screen should show in the correct orientation.
* Windows **may show BSoD** or otherwise **fail to boot**. See these issues for the reference: [#43](https://github.com/ryanrudolfoba/SteamDeck-Clover-dualboot/issues/43), [#85](https://github.com/ryanrudolfoba/SteamDeck-Clover-dualboot/issues/85)

| Resolution | Clover screen |
|-|-|
| 1080p | ![Clover on 1080p display](https://user-images.githubusercontent.com/98122529/230472962-0c981a47-2677-4766-80ad-c2b27d7f62c7.png) |
| 4K | ![Clover on 4K display](https://user-images.githubusercontent.com/98122529/230472728-b73bc18f-563d-4149-9d18-27792d6031b7.png) |

Because of these issues, when using an external display, it is recommended to use a display with 1080p or lower resolution.

If you use a display with a resolution higher than 1080p anyway, a workaround for these issues is available to make Windows boot normally and make Clover screen show in the correct orientation only on the external display.
1. Open Clover Toolbox.
1. Select "Resolution".
1. Change the resolution option to "DeckSight".

Note that this workaround **will make Clover screen rotated on Steam Deck's built-in display** when it is not connected to an external display.

## Acknowledgement / Thanks
Thanks to jlobue10 for his rEFInd script [available here.](https://github.com/jlobue10/SteamDeck_rEFInd) This Clover script was inspired by jlobue10's rEFInd script.

And in no particular order -<br>
- the Clover team / sergey for creating this awesome software. <br>
- Christoph Pfisterer for creating rEFIt which Clover is a fork of. <br>
- ss64.com for my quick online reference guide on command line switches! I also use this at work when scripting using bash / batch / powershell. <br>
- deckwizard for testing the initial Clover script. <br>
- arkag for the code enhancement to pull the ISO directly from Clover repo. <br>
- community contributed icons / logos for SteamOS and Batocera (thanks to WindowsOnDeck reddit members u/ch3vr0n5 and u/ChewyYui). <br>
- baldsealion for creating the custom splash screen for Windows. <br>
- Kodi Ross from FB Steam Deck Community for the Rick and Morty theme. <br>
- insanelymac and its forum members for creating beautiful Clover themes. <br>
- and the rest of WindowsOnDeck reddit community / discord server!<br>
- PS I forgot to mention LOUP the author of the OpenAsRoot KDE extension.
