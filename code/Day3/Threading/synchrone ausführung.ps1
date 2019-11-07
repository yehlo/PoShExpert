


$code =
{
  Get-Variable
}


[PowerShell]$ps = [PowerShell]::Create()

$null = $ps.AddScript($code)
$defaultVariables = $ps.Invoke()

$meine = Get-Variable
Compare-Object -ReferenceObject $defaultVariables -DifferenceObject $meine -Property Name -PassThru |
  Out-GridView

$ps.Runspace.Close()
$ps.Dispose()



