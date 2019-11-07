


$code =
{
  Get-HotFix
  Start-Sleep -Seconds 10
}


[PowerShell]$ps = [PowerShell]::Create()
$null = $ps.AddScript($code)
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

