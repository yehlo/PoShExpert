






$ergebnis = Get-ChildItem c:\windows -Recurse -Filter *.log -File -ErrorAction SilentlyContinue -ErrorVariable meineFehler
$meineFehler.Count
$ergebnis = Get-Process -FileVersionInfo -ErrorAction SilentlyContinue -ErrorVariable +meineFehler

$meineFehler.CategoryInfo | Select-Object -Property Category, TargetName