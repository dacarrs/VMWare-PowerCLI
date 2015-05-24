## Bulk change of NTP server across all ESXi of a vCenter
## Requires to be connected to a vCenter with Connect-VIServer previously

## For a fully automated script replace $NTPData with the NTP server data itself so the script don't ask for the NTP Server

## For a multiple NTP servers run multiple times or add multiple $NTPData variables and then separate with commas in the Add-VMHostNtpServer line (Add-VmHostNtpServer -NtpServer $NTPData1, $NTPData2 -VMHost $HostA | Out-Null)

$Hosts = Get-VMHost
$NTPData = read-host "Enter NTP server"
ForEach ($HostA in $Hosts) 
{ 
Add-VmHostNtpServer -NtpServer $NTPData -VMHost $HostA | Out-Null
Get-VmHostService -VMHost $HostA | Where-Object {$_.key -eq "ntpd"} | Restart-VMHostService -Confirm:$false | Out-Null
write-output "NTP Server was changed on $HostA"
}