

$Path = "C:\Windows\Logs\DISM\dism.log"
$Pattern = "(?<Date>\d{4}-\d{2}-\d{2})\s(?<Time>\d{2}:\d{2}:\d{2}).*?=(?<PID>\d{1,5})"

Get-Content -Path $Path |
  Where-Object { $_ -match $pattern } |
  ForEach-Object {
    $null = $matches.Remove(0)
    [PSCustomObject]$matches
  }