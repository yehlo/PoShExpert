function Invoke-CodeWithProgress
{
  <#
    .SYNOPSIS
    Short Description
    .DESCRIPTION
    Detailed Description
    .EXAMPLE
    Invoke-CodeWithProgress
    explains how to use the command
    can be multiple lines
    .EXAMPLE
    Invoke-CodeWithProgress
    another example
    can have as many examples as you like
  #>
  [CmdletBinding()]
  param
  (
    [Parameter(Mandatory=$false, Position=0)]
    [Object]
    $code =
    {
      Get-HotFix
      Start-Sleep -Seconds 10
    }
  )
  
  [PowerShell]$ps = [PowerShell]::Create()
  $null = $ps.AddScript($code)
  $handle = $ps.BeginInvoke()
  do
  {
    Write-Host '.' -NoNewline
    Start-Sleep -Milliseconds 300
  } while ($handle.IsCompleted -eq $false)
  
  
  
  $result = $ps.EndInvoke($handle)
  $ps.Runspace.Close()
  $ps.Dispose()
  
  $result
}

