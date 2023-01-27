$daysInactive = 90
$path = "C:\Reports\"
$logfile = $path+'Inactive_Users_'+$DaysInactive+'_Days.csv'

$time = (Get-Date).Adddays(-($daysInactive))

#get-aduser -filter * -searchscope subtree -searchbase "dc=wilco,dc=org" -properties DisplayName,lastlogontimestamp | ? {(((Get-date) - ([datetime]::FromFileTime($_.lastlogontimestamp))).TotalDays -gt 90)} | select DisplayName,samaccountname,@{Exp={([datetime]::FromFileTime($_.lastlogontimestamp))};label="Last logon time stamp"},Userprincipalname,DistinguishedName,Name,SID,Enabled | Export-CSV $logfile –NoTypeInformation
$Do = Get-ADUser -Filter {LastLogonTimeStamp -lt $time} -ResultPageSize 2000 -resultSetSize $null -Properties *  | select DisplayName, samaccountname, Description, CanonicalName, Enabled, LastLogonDate, Created, Modified, PasswordLastSet, PasswordExpired, PasswordNeverExpires, CannotChangePassword, PasswordNotRequired, ProtectedFromAccidentalDeletion, LockedOut, AccountLockoutTime, LastBadPasswordAttempt, BadLogonCount, AccountExpirationDate, PrimaryGroup, primaryGroupID, extensionAttribute10, EmailAddress, msExchWhenMailboxCreated, OfficePhone, Company, Department, Office, StreetAddress, City, State, PostalCode, Manager, DistinguishedName, LastKnownParent | Export-CSV $logfile –NoTypeInformation
