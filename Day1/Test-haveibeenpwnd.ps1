$password = 'Zumsel'

# SSL / http erlauben:
[Net.ServicePointManager]::SecurityProtocol='Tls12'

# kennwort in Daten schreiben, damit Get-FileHash es hashen kann:
$Path = "$env:temp\file.txt"
Set-Content -Value $password -Path $Path -NoNewline

#$totalHash = Get-FileHash -Path $Path -Algorithm SHA1 | ForEach-Object h*
$totalHash = Get-FileHash -Path $Path -Algorithm SHA1 | Select-Object -ExpandProperty Hash

$a,$b=$totalHash -split '(?<=^.{5})'
$WebSiteResponse = Invoke-RestMethod -Uri api.pwnedpasswords.com/range/$a
$parts = $WebSiteResponse -split "$b`:(\d{1,})"
$parts[1]

Remove-Item -Path $Path 
