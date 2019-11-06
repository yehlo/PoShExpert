
Pin-Path -Path <string> -Target [Start|Taskbar] -Mode [Pin/UnPin]

function Pin-Path
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
  
  
  # TODO: place your function code here
  # this code gets executed when the function is called
  # and all parameters have been processed
  
  
}


<#  Script-Version: 1.0  /  Autor: sre  #>
function Pin-ProgramToStart
{
  <#
    .SYNOPSIS
    Describe purpose of "Pin-ProgramToStart" in 1-2 sentences.

    .DESCRIPTION
    Add a more complete description of what the function does.

    .PARAMETER Path
    Describe parameter -Path.

    .PARAMETER Anheften
    Describe parameter -Anheften.

    .PARAMETER Loesen
    Describe parameter -Loesen.

    .EXAMPLE
    Pin-ProgramToStart -Path Value -Anheften
    Describe what this call does

    .EXAMPLE
    Pin-ProgramToStart -Loesen
    Describe what this call does

    .NOTES
    Place additional notes here.

    .LINK
    URLs to related sites
    The first link is opened by Get-Help -Online Pin-ProgramToStart

    .INPUTS
    List of input types that are accepted by this function.

    .OUTPUTS
    List of output types produced by this function.
  #>


  [CmdletBinding(DefaultParameterSetName='Anheften')]
  param
  (
    [Parameter(ParameterSetName='Anheften', Position=0, Mandatory=$true)]
    [Parameter(ParameterSetName='Loesen', Position=0, Mandatory=$true)]
    [string]
    $Path,
    
    [Parameter(ParameterSetName='Anheften', Position=1, Mandatory=$false)]
    [switch]
    $Anheften,
    
    [Parameter(ParameterSetName='Loesen', Position=1, Mandatory=$false)]
    [switch]
    $Loesen
  )

  $Program = (Get-Command -Name $program).Source

  $ErrorActionpreference = "SilentlyContinue"
  


  # ===== Beginn Funktions-Routinen ======================================================================================

  Function Anheften($Anheften)
  {
    (New-Object -ComObject Shell.Application).
    NameSpace(0).
    ParseName($Anheften).
    Verbs() | 
    Where-Object {$_.Name.replace('&','') -match 'Pin to Start|An "Start" anheften'} | 
    ForEach-Object {$_.DoIt()}
  }





  Function Loesen($Loesen)
  {
    (New-Object -Com Shell.Application).NameSpace(0x0).ParseName($Loesen).Verbs() | ?{$_.Name.replace('&','') -match 'Unpin from Start|Von "Start" lösen'} | %{$_.DoIt()}
  }

  $chosenParameterSet = $PSCmdlet.ParameterSetName
  switch($chosenParameterSet)
  {
    'Anheften'    { Anheften $Path } 
    'Loesen'    { Loesen $Path } 
  }
}
