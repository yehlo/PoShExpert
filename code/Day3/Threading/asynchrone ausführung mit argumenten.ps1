
$Arguments = 20

$code =
{
  param
  (
    $SecondsToDelay
  )
  Get-HotFix
  Start-Sleep -Seconds $SecondsToDelay
}


[PowerShell]$ps = [PowerShell]::Create()
$null = $ps.AddScript($code).AddArgument($Arguments)
$handle = $ps.BeginInvoke()
do
{
  Write-Host '.' -NoNewline
  Start-Sleep -Milliseconds 300
} while ($handle.IsCompleted -eq $false)



$result = $ps.EndInvoke($handle)
$ps.Runspace.Close()
$ps.Dispose()

$result

