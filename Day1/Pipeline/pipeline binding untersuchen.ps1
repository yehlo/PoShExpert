# Tür 1
# streaming

1..49 | Get-Random -Count 6

# Tür 2
# downloading

$zahlen = 1..49

Get-Random -InputObject $zahlen -Count 6


# sonderfall: tee-object


1..49 | 
  Tee-Object -Variable alles |
  Get-Random -Count 6




Get-Service -name a* | Stop-Service -WhatIf
'spooler'  | Stop-Service -WhatIf
Get-Content -Path $dienste  | Stop-Service -WhatIf
Get-Process | Stop-Service -WhatIf -ErrorAction SilentlyContinue