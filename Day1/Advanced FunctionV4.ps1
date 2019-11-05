


function Resolve-IP
{
  param
  (
    # 1. Parameter bestimmen, die die Pipeline-Eingaben erhalten sollen:
    [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [string[]]
    $ComputerName = $env:COMPUTERNAME
    
  )
  
  
  # Code in process{} block stellen, der pro Pipeline-Element wiederholt werden soll
  process {
       foreach($Computer in $ComputerName)
       {
         try
         {
           [Net.DNS]::GetHostEntry($Computer)
         }
         # NOTE: When you use a SPECIFIC catch block, exceptions thrown by -ErrorAction Stop MAY LACK
         # some InvocationInfo details such as ScriptLineNumber.
         # REMEDY: If that affects you, remove the SPECIFIC exception type [System.Net.Sockets.SocketException] in the code below
         # and use ONE generic catch block instead. Such a catch block then handles ALL error types, so you would need to
         # add the logic to handle different error types differently by yourself.
         catch [System.Net.Sockets.SocketException]
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

'127.0.0.1', 'CL01', 'CL03', "ups" | Resolve-IP
Resolve-IP -ComputerName '127.0.0.1', 'CL01', 'CL03', "ups"