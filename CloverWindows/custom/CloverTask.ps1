# This will make the Clover boot entry to be the next available option on boot!
# put a sleep delay so it doesnt interfere with rEFInd if it is present.
# but ideally the rEFInd scheduled task should be disabled.
# sleep 60
#
# some crazy string manipulation to filter for the SteamOS EFI entry
$CloverStatus="C:\1Clover-tools\status.txt"
$CloverTmp="C:\1Clover-tools\CloverTmp.txt"
$queryClover = bcdedit.exe /enum firmware | Select-String -pattern cloverx64.efi -Context 2 | out-file $CloverTmp
$Clover = get-content $CloverTmp | select-string -pattern Volume -context 2 | findstr "{" ; `
$Clover = $Clover -replace '.*\{' -replace '\}.*'
rm $CloverTmp
bcdedit /set "{fwbootmgr}" bootsequence "{$Clover}" /addfirst
#
# create log file for troubleshooting
"*** Clover log file for troubleshooting ***" | out-file $CloverStatus
"Provide the contents of this text file when reporting issues." | out-file -append $CloverStatus
get-date | out-file -append $CloverStatus
"Clover GUID $Clover" | out-file -append $CloverStatus
bcdedit /enum firmware | Select-String -pattern bootsequence | out-file -append $CloverStatus
