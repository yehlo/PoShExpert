

function Get-Something
{
  [CmdletBinding()]
  param
  (
    # 1. Parameter bestimmen, die die Pipeline-Eingaben erhalten sollen:
    [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [string]
    $Name
    
  )
  
  
  # Code in process{} block stellen, der pro Pipeline-Element wiederholt werden soll
  process {
    "Hallo $Name"
  }
}


$env:COMPUTERNAME | Get-Something
Get-Process | Get-Something