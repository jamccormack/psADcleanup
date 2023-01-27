Import-Module ActiveDirectory

$computer = Get-ADComputer COMPUTERNAME
Get-ADObject -Filter 'objectClass -eq "msFVE-RecoveryInformation"' -SearchBase $computer.DistinguishedName -Properties whenCreated, msFVE-RecoveryPassword | `
  Sort whenCreated -Descending | Select Name, whenCreated, msFVE-RecoveryPassword