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