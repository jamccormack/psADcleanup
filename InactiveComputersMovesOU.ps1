$daysInactive = 90 # <--- Set the number of days that a computer has not been logged into.

#OU Information
$targetOU = 'OU=WIN10,OU=GPOBuild,DC=iridium,DC=org' # <--- Set the OU that you want to limit scope (SearchBase) for Note you can add multible OU's to this line by seperating with a comma outside of quotes 'OU=WIN10,DC=iridium,DC=org','OU=VDI,DC=iridium,DC=org'.
$stagedOU = 'OU=StagedForDeletion,OU=GPOBuild,DC=iridium,DC=org'

# log file
$logPath = "C:\Reports\" # <--- Set the file path location of where the log/report will be generated
$logfile = $logPath+'Inactive_Computers_'+$DaysInactive+'_Days_'+(get-date -format yyyyMMdd_HHmm)+'.csv' #This is the file name that appends the number of inactive days varible and the date time stamp to the file name.

#Time Calculation used in search
$time = (Get-Date).Adddays(-($daysInactive))

#Search (get) Computers in AD
$inactiveComputers = Get-ADComputer -Filter {LastLogonTimeStamp -lt $time} -ResultPageSize 2000 -resultSetSize $null -Properties Name, Description, CanonicalName, IPv4Address, LastLogonDate, lastLogonTimestamp, OperatingSystem, OperatingSystemVersion, Created, Modified, PasswordLastSet, Enabled, ProtectedFromAccidentalDeletion, DistinguishedName, ManagedBy -SearchBase $targetOU | select Name, Description, CanonicalName, IPv4Address, @{Exp={([datetime]::FromFileTime($_.lastlogontimestamp))};label="Last logon Time Stamp"}, OperatingSystem, OperatingSystemVersion, LastLogonDate,Created, Modified, PasswordLastSet, Enabled, ProtectedFromAccidentalDeletion, DistinguishedName, ManagedBy

#loop that moves and/or disables computers from $targetOU to $stagedOU. Actions on each computer foud in Search (get)
foreach($computer in $inactiveComputers) {
#Disable-ADAccount -Identity $computer.DistinguishedName # <--- Comment Out if you do not want to disable the Computer Account
Move-ADObject -Identity $computer.DistinguishedName -TargetPath $stagedOU
}

#Output to log.
$inactiveComputers | Export-CSV $logfile –NoTypeInformation
