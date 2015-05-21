## Change Path Policy on LeftHand 12 Storages for a single ESXi 5.x host
## 
## By: Daniel Carrascosa
##
## I'M NOT RESPONSIBLE FOR ANY MISCONFIGURATION, DATA LOSS, etc..
## PLEASE TEST IN LAB BEFORE PRODUCTION


## Define new policy added after installing the VIB into the ESXi Host

$policy = new-object VMware.Vim.HostMultipathInfoLogicalUnitPolicy
$policy.policy = "HP_PSP_LH"


## Select single host to change all its LeftHand's LUNs

$esxihost = "ESXi-HOST-To-Update"

## Get Views and storage system for the ESXi

$vmh = get-vmhost "$esxihost"
$hostview = Get-View $vmh.id
$storageSystem = Get-View $hostview.ConfigManager.StorageSystem

## The command performs a trim in the "Key" value to obtain the Id that will be used for the last command to change the policy

Get-VMHost $vmh | Get-ScsiLun | where { $_.Vendor -eq "LEFTHAND"} | Select -ExpandProperty Key | foreach {$_.Trim("key-vim.host.ScsiDisk-")} | foreach {%{$storageSystem.SetMultipathLunPolicy($_, $policy)}}

## Refresh Storage System after the changes

$storageSystem.RefreshStorageSystem()

## Perform a full rescan on all HBAs

Get-VMHost $esxihost | Get-VMHostStorage -RescanAllHba -RunAsync
