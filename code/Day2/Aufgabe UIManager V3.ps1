
function Pin-Program
{
   [CmdletBinding()]
  param
  (
    [Parameter(Mandatory)]
    [string]
    $Path,
    
    [Parameter(Mandatory)]
    [ValidateSet('Start','Taskbar')]
    [string]
    $Target,
    
    [Parameter(Mandatory)]
    [string]
    [ValidateSet('Pin','Unpin')]
    $Mode
  )

  $Path = (Get-Command -Name $Path).Source

  $key = "$Target$Mode"
  $command = @{
    StartPin = 'startpin'
    StartUnpin = 'startunpin'
    TaskbarPin = 'taskbarpin'
    TaskbarUnpin = 'taskbarunpin'
  }[$key]

    (New-Object -ComObject Shell.Application).
    NameSpace(0).
    ParseName($Path).
    InvokeVerb($command)
  
}
