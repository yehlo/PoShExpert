

function Get-Something
{
  [CmdletBinding()]
  param
  (
    [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [string]
    $Name
    
  )
  
  end {
    "Hallo $Name"
  }
}


$env:COMPUTERNAME | Get-Something
Get-Process | Get-Something