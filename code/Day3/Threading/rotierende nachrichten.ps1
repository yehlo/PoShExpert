
$nachrichten = Invoke-RestMethod -Uri https://www.srf.ch/news/bnf/rss/1978 -UseBasicParsing
$title = $nachrichten.title

# threadsicherer Hashtable
$syncHash = [hashtable]::Synchronized(@{})

$syncHash.MyUI = $host.Ui.RawUI
$syncHash.Nachrichten = $title



$Code = {
    do
    {
      $datentauscher.MyUI.WindowTitle = $datentauscher.Nachrichten | Get-Random
      Start-Sleep -Seconds 10
    } while ($true)
}


[PowerShell]$ps = [PowerShell]::Create()
$null = $ps.AddScript($Code)
$ps.Runspace.SessionStateProxy.SetVariable("datentauscher",$syncHash)
$handle = $ps.BeginInvoke()