Import-Module ActiveDirectory

# Read computer names from a list
$ComputerListFilePath = "C:\Reports\computerlist.txt"
$path = "C:\Reports\"
$logfile = $path+'BitlockerRecoveryPasswords_'+(get-date -format yyyyMMdd_HHmm)+'.csv'


$computers = Get-Content $ComputerListFilePath
foreach ($computer in $computers) {
Get-ADObject -Filter 'objectClass -eq "msFVE-RecoveryInformation"' -SearchBase (Get-ADComputer $computer).DistinguishedName -Properties whenCreated, msFVE-RecoveryPassword | `
Sort whenCreated -Descending | Select DistinguishedName, whenCreated, msFVE-RecoveryPassword | Export-CSV $logfile –NoTypeInformation
}
