@echo off
cls
echo Clover Windows install script by ryanrudolf
echo https://github.com/ryanrudolfoba/SteamDeck-Clover-dualboot
echo.
ping -n 3 localhost > nul

rem - remove / re-create 1Clover-tools folder and copy the powershell script
mkdir C:\1Clover-tools
copy "%~dp0custom\CloverTask.ps1" C:\1Clover-tools > nul

rem - delete / re-create the CloverTask
schtasks /delete /tn CloverTask-donotdelete /f 2> nul
schtasks /create /tn CloverTask-donotdelete /xml "%~dp0custom\CloverTask.xml"

if %errorlevel% equ 0 goto :success
if %errorlevel% neq 0 goto :accessdenied
:accessdenied
echo Make sure you right-click the CloverWindows.bat and select RUNAS ADMIN!
pause
goto :end

:success
echo.
bcdedit.exe -set {globalsettings} highestmode on
echo 1. Go to Windows Administrative Tools, then Scheduled Task.
echo 2. Right-click the task called CloverTask, then select Properties.
echo 3. Under the General Tab, change the option to RUN WHETHER USER IS LOGGED IN OR NOT.
echo 4. Put a check mark on DO NOT STORE PASSWORD.
echo 5. Press OK. Right click the task and select RUN.
echo 6. Go to C:\1Clover-tools and look for a file called status.txt
echo 7. Open the file and compare the Clover GUID and bootsequence they should be the same!
echo 8. Windows configuration is done!
pause

:end
