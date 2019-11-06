﻿#requires -RunAsAdmin

function Protect-SBLLog
{
  $channelAccess = 'O:BAG:SYD:(A;;0x2;;;S-1-15-3-1024-3153509613-960666767-3724611135-2725662640-12138253-543910227-1950414635-4190290187)(A;;0xf0007;;;SY)(A;;0x7;;;BA)(A;;0x7;;;SO)(A;;0x3;;;S-1-5-3)'
  
  $Path = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\winevt\Channels\Microsoft-Windows-PowerShell/Operational"
  #$channelAccess = ((wevtutil gl security) -like 'channelAccess*').Split(' ')[-1]
  Set-ItemProperty -Path $Path -Name ChannelAccess -Value $channelAccess
  Restart-Service -Name EventLog -Force
}

function Unprotect-SBLLog
{
  $channelAccess = 'O:BAG:SYD:(A;;0x2;;;S-1-15-2-1)(A;;0x2;;;S-1-15-3-1024-3153509613-960666767-3724611135-2725662640-12138253-543910227-1950414635-4190290187)(A;;0xf0007;;;SY)(A;;0x7;;;BA)(A;;0x7;;;SO)(A;;0x3;;;IU)(A;;0x3;;;SU)(A;;0x3;;;S-1-5-3)(A;;0x3;;;S-1-5-33)(A;;0x1;;;S-1-5-32-573)'
  $Path = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\winevt\Channels\Microsoft-Windows-PowerShell/Operational"
  Set-ItemProperty -Path $Path -Name ChannelAccess -Value $channelAccess
  Restart-Service -Name EventLog -Force
}
