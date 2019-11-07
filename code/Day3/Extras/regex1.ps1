

$Path = "C:\Windows\Logs\DISM\dism.log"
$text = "2019-10-26 12:29:43, Info                  DISM   API: PID=8292 TID=8460 DismApi.dll:                                            - DismInitializeInternal"
$Pattern = "(?<Date>\d{4}-\d{2}-\d{2})\s(?<Time>\d{2}:\d{2}:\d{2}).*?=(?<PID>\d{1,5})"
$text -match $pattern
$null = $matches.Remove(0)
[PSCustomObject]$matches