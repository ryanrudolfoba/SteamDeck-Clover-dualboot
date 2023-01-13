# This will make the Clover boot entry to be the next available option on boot!
# put a sleep delay so it doesnt interfere with rEFInd if it is present.
# but ideally the rEFInd scheduled task should be disabled.
# sleep 60
$clover = bcdedit.exe /enum firmware | Select-String -pattern cloverx64.efi -Context 2 | findstr identifier ; `
$clover = $clover -replace 'identifier' ; $clover = $clover -replace ' '
bcdedit /set "{fwbootmgr}" bootsequence "$clover" /addfirst
#
# create log file for troubleshooting
"*** Clover log file for troubleshooting ***" | out-file C:\1Clover-tools\status.txt
"Provide the contents of this text file when reporting issues." | out-file -append C:\1Clover-tools\status.txt
get-date | out-file -append C:\1Clover-tools\status.txt
"Clover GUID $clover" | out-file -append C:\1Clover-tools\status.txt
bcdedit /enum firmware | Select-String -pattern bootsequence | out-file -append C:\1Clover-tools\status.txt
