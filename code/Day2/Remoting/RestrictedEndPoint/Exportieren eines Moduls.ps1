

$session = New-PSSession -ConfigurationName ElevatedUsers -ComputerName cl10
Export-PSSession -Session $session -OutputModule ElevatedUsers -CommandName Test-AdminAccess 

Remove-PSSession -Session $session