Import-Module ActiveDirectory

#$ou = "CN=Computers,DC=iridium,DC=org" # <--- Use to get all BitlockerRecoveryPasswords This will take some time.
$ou = "OU=WIN10,OU=GPOBuild,DC=iridium,DC=org" #Replace StagedForDeletion ou when created
$path = "C:\Reports\"
$logfile = $path+'BitlockerRecoveryPasswords_'+(get-date -format yyyyMMdd_HHmm)+'.csv'

#This section checks is the path exixts if not creates it. This section can be commented out or removed if not needed.
#if (!(Test-Path $path)) {
#    New-Item -ItemType Directory -Path $path
#}

#Start-Sleep -Seconds 2

$computers = Get-ADComputer -SearchBase $ou -Filter *
foreach ($computer in $computers) {
Get-ADObject -Filter 'objectClass -eq "msFVE-RecoveryInformation"' -SearchBase $computer.DistinguishedName -Properties whenCreated, msFVE-RecoveryPassword | `
Sort whenCreated -Descending | Select DistinguishedName, whenCreated, msFVE-RecoveryPassword | Export-CSV $logfile –NoTypeInformation
}
