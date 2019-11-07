# threadsicherer Hashtable
$syncHash = [hashtable]::Synchronized(@{})

$syncHash.MyUI = $host.Ui.RawUI



$Code = {
    $datentauscher.MyUI.WindowTitle = Get-Date
    $datentauscher.Result = Get-Process
}


[PowerShell]$ps = [PowerShell]::Create()
$null = $ps.AddScript($Code)
$ps.Runspace.SessionStateProxy.SetVariable("datentauscher",$syncHash)
$handle = $ps.Invoke()
$ps.Runspace.Close()
$ps.Dispose()
$syncHash.Result


   