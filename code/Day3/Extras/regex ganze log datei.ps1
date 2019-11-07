$hex = '[a-f0-9]'
$guid = "$hex{8}-$hex{4}-$hex{4}-$hex{4}-$hex{12}"
$pattern = "global id of ($guid)"


$Path = "C:\Users\Administrator\Desktop\WindowsUpdate.log"

Get-Content -Path $Path |
  Where-Object { $_ -match $pattern} |
  ForEach-Object { $matches[1]}