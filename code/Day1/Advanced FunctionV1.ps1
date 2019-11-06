

function Get-Something
{
  [CmdletBinding()]
  param
  (
    [Parameter(ValueFromPipeline)]
    [string]
    $Name
    
  )
  
  "Hallo $Name"
}


$env:COMPUTERNAME | Get-Something