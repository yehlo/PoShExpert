
# DCOM
Get-WmiObject -Class Win32_BIOS -ComputerName cl03
netsh firewall set service remoteadmin enable


Get-Process -ComputerName cl03
<#
  netsh firewall set service remoteadmin enable
  Start-Service RemoteRegistry
  Set-Service -name RemoteRegistry -StartupType Manual -Status Running 
#>

get-service -ComputerName cl03