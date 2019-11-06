$LogName = 'System'
$Type = 'Error'
$Count = 56


$code =
{
  param
  (
    $LogNameRemote,
    $TypeRemote,
    $CountRemote
  )
  
  Get-EventLog -LogName $LogNameRemote -EntryType $TypeRemote -Newest $CountRemote


}

Invoke-Command -ScriptBlock $code -ComputerName cl02 -ArgumentList $LogName, $Type, $Count | Out-GridView