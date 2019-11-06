$Path = '\\cl03\c$'

$code =
{
  param
  (
    $Path
  )
  
    Get-ChildItem -Path $Path 


}

Invoke-Command -ScriptBlock $code -ComputerName cl02 -ArgumentList $Path  -Authentication Credssp -Credential $cred

