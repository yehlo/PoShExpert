$Path = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\winevt\Channels\Microsoft-Windows-PowerShell/Operational"
$sddlSecurity = ((wevtutil gl security) -like 'channelAccess*').Split(' ')[-1]
Set-ItemProperty -Path $Path -Name ChannelAccess -Value $sddlSecurity
Restart-Service -Name EventLog -Force