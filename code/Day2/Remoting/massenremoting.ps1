$cred = Get-Credential -UserName Administrator -Message Anmelden


Invoke-Command {
  Get-WmiObject -Class Win32_BIOS 
} -ComputerName cl03 -Credential $cred


Invoke-Command {
  Get-Process 
} -ComputerName cl03 -Credential $cred


Invoke-Command {
  get-service 
} -ComputerName cl03 -Credential $cred




Invoke-Command {
  ipconfig 
} -ComputerName cl03 -Credential $cred



$o = Invoke-Command {
  systeminfo.exe /FO CSV | ConvertFrom-CSV 
} -ComputerName cl03 -Credential $cred


$liste = 10, 3,4,9,8,6,1,2 | ForEach-Object { 'CL{0:d2}' -f $_ }
$liste = $liste -ne $env:COMPUTERNAME

<#
    Import-Module -Name \\absender\c$\test\...
#>


Invoke-Command {
  systeminfo.exe /FO CSV | ConvertFrom-CSV 
} -ThrottleLimit 20 -ComputerName $liste -Credential $cred |
Out-GridView




Invoke-Command {
  "Klick mich" > "C:\users\Public\Desktop\hallo.txt"
} -ThrottleLimit 20 -ComputerName $liste -Credential $cred |
Out-GridView