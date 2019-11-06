$cred = Get-Credential -UserName Administrator -Message Anmelden



$liste = 10, 3,4,9,8,6,1,2 | ForEach-Object { 'CL{0:d2}' -f $_ }
$liste = $liste -ne $env:COMPUTERNAME


Invoke-Command {
  

  $Path = 'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*',
    'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*'
  Get-ItemProperty -Path $Path |
  Select-Object -Property DisplayName, DisplayVersion, UninstallString |
  Where-Object -Property DisplayName |
  Sort-Object -Property DIsplayName
   
} -ThrottleLimit 20 -ComputerName $liste -Credential $cred |
 Select-Object -Property DisplayName, DisplayVersion, UninstallString, PSComputerName |
 Sort-Object -Property DisplayName, PSComputername |
Out-GridView

