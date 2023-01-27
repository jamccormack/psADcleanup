$daysInactive = 90 # <---------------------------------- Set the number of days 
$targetOU = 'OU=WIN10,OU=GPOBuild,DC=iridium,DC=org' # <-- Set the OU that you want to limit scope (SearchBase) for.
$logPath = "C:\Reports\" # <-----------------------------Set the file path location of where the log/report will be generated
$logfile = $logPath+'Inactive_Computers_'+$DaysInactive+'_Days_'+(get-date -format yyyyMMdd_HHmm)+'.csv' #This is the file name that appends the Number of inactive days varible and the date and time stamp to the file name.

$time = (Get-Date).Adddays(-($daysInactive)) # This Variable calculates time

Get-ADComputer -Filter {LastLogonTimeStamp -lt $time} -ResultPageSize 2000 -resultSetSize $null -Properties Name, Description, CanonicalName, IPv4Address, LastLogonDate, lastLogonTimestamp, OperatingSystem, OperatingSystemVersion, Created, Modified, PasswordLastSet, Enabled, ProtectedFromAccidentalDeletion, DistinguishedName, ManagedBy -SearchBase $targetOU | select Name, Description, CanonicalName, IPv4Address, @{Exp={([datetime]::FromFileTime($_.lastlogontimestamp))};label="Last logon Time Stamp"}, OperatingSystem, OperatingSystemVersion, LastLogonDate,Created, Modified, PasswordLastSet, Enabled, ProtectedFromAccidentalDeletion, DistinguishedName, ManagedBy | Export-CSV $logfile –NoTypeInformation