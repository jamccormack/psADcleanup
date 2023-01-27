$daysInactive = 0
$OU = 'OU=WIN10,OU=GPOBuild,DC=iridium,DC=org'
$stagedOU = 'OU=StagedForDeletion,OU=GPOBuild,DC=iridium,DC=org'
$path = "C:\Reports\"
$logfile = $path+'Inactive_Computers_'+$DaysInactive+'_Days_'+(get-date -format yyyyMMdd_HHmm)+'.csv'

$time = (Get-Date).Adddays(-($daysInactive))

$inactiveComputers = Get-ADComputer -Filter {LastLogonTimeStamp -lt $time} -ResultPageSize 2000 -resultSetSize $null -Properties Name, Description, CanonicalName, IPv4Address, LastLogonDate, lastLogonTimestamp, OperatingSystem, OperatingSystemVersion, Created, Modified, PasswordLastSet, Enabled, ProtectedFromAccidentalDeletion, DistinguishedName, ManagedBy -SearchBase $OU | select Name, Description, CanonicalName, IPv4Address, @{Exp={([datetime]::FromFileTime($_.lastlogontimestamp))};label="Last logon Time Stamp"}, OperatingSystem, OperatingSystemVersion, LastLogonDate,Created, Modified, PasswordLastSet, Enabled, ProtectedFromAccidentalDeletion, DistinguishedName, ManagedBy

foreach($computer in $inactiveComputers) {
Disable-ADAccount -Identity $computer.DistinguishedName
Move-ADObject -Identity $computer.DistinguishedName -TargetPath $stagedOU
}
$inactiveComputers | Export-CSV $logfile –NoTypeInformation