
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
    StartPin = 'Pin to Start|An "Start" anheften'
    StartUnpin = 'Unpin from Start'
    TaskbarPin = 'Pin to taskbar'
    TaskbarUnpin = 'Unpin from taskbar'
  }[$key]

    (New-Object -ComObject Shell.Application).
    NameSpace(0).
    ParseName($Path).
    Verbs() | 
    Where-Object {$_.Name.replace('&','') -match $command} | 
    ForEach-Object {$_.DoIt()}
  
}
