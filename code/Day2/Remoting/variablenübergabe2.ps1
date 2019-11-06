$LogName = 'System'
$Type = 'Error'
$Count = 56


$code =
{
  
  Get-EventLog -LogName $using:LogName -EntryType $using:Type -Newest $using:Count


}

Invoke-Command -ScriptBlock $code -ComputerName cl02  | Out-GridView