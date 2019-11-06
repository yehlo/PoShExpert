#requires -Version 3.0 -Modules ImportExcel
 
<#
  Install-Module -Name ImportExcel -scope CurrentUser -Force
#>

function Resolve-IP
{
  <#
      .SYNOPSIS
      Resolves a computername or IP address

      .DESCRIPTION
      Uses synchrodnous DNS queries to return current IP address and host name

      .EXAMPLE
      Resolve-IP -ComputerName 127.0.0.1, 'microsoft.com', 'google.com'
      resolves all three computers

      .EXAMPLE
      '127.0.0.1', 'microsoft.com', 'google.com' | Resolve-IP 
      resolves all three computers
  #>

  param
  (
    # one or more computer names or IP addresses
    [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [string[]]
    $ComputerName = $env:COMPUTERNAME
    
  )
  
  
  begin
  {
  
    $HostName =  @{
      Name = 'ComputerName'
      Expression = { $_.HostName }
    }
    
     $AddressList =  @{
       Name = 'IPAddress'
       Expression = { 
         $_.AddressList.IPAddressToString -join ','
       }
     }
  
  
  }
  
  # Code in process{} block stellen, der pro Pipeline-Element wiederholt werden soll
  process {
       foreach($Computer in $ComputerName)
       {
         try
         {
           return [Net.DNS]::GetHostEntry($Computer) | 
            Select-Object -Property $HostName, $AddressList
         }
         # NOTE: When you use a SPECIFIC catch block, exceptions thrown by -ErrorAction Stop MAY LACK
         # some InvocationInfo details such as ScriptLineNumber.
         # REMEDY: If that affects you, remove the SPECIFIC exception type [System.Net.Sockets.SocketException] in the code below
         # and use ONE generic catch block instead. Such a catch block then handles ALL error types, so you would need to
         # add the logic to handle different error types differently by yourself.
         catch [Net.Sockets.SocketException]
         {
           # get error record
           [Management.Automation.ErrorRecord]$e = $_

           # retrieve information about runtime error
           $info = [PSCustomObject]@{
             Exception = $e.Exception.Message
             Reason    = $e.CategoryInfo.Reason
             Target    = $e.CategoryInfo.TargetName
             Script    = $e.InvocationInfo.ScriptName
             Line      = $e.InvocationInfo.ScriptLineNumber
             Column    = $e.InvocationInfo.OffsetInLine
           }
         
           # output information. Post-process collected info, and log info (optional)
           Write-Host ($info | Out-String) 
         }
         catch
         {
           throw "Neuer unbekannter Fehler: $_"
         }
       }
       
  }
}

$Path = "$home\Desktop\report.xlsx"
'127.0.0.1', 'CL01', 'CL03' | Resolve-IP | Export-Excel -WorksheetName IPList -Path $Path -ClearSheet -FreezeTopRow -BoldTopRow -AutoSize -NoNumberConversion * -Show

