function Out-Slow($text)
{
  Write-Host $text
  Start-Sleep -Seconds 1

}

function Test-PipeSimple
{
   Begin 
  { 
    Out-Slow "Start 3"
  } 
  
  Process 
  { 
    Out-Slow "Process 3 $_"
    $_
  } 
  
  End 
  { 
    Out-Slow "End 3"
  }
}


function Test-PipeAdv
{
  [CmdletBinding()]
  param
  (
    [Parameter(Mandatory,ValueFromPipeline)]
    $Received
  )
   Begin 
  { 
    Out-Slow "Start 4"
  } 
  
  Process 
  { 
    Out-Slow "Process 4 $Received"
    $Received
  } 
  
  End 
  { 
    Out-Slow "End 4"
  }
}

1..10 | 
  ForEach-Object -Begin { Out-Slow "Start 1"} -Process { Out-Slow "Process 1  $_"; $_} -End { Out-Slow "End 1"} |
  & {  Begin { Out-Slow "Start 2"} Process { Out-Slow "Process 2 $_"; $_} End { Out-Slow "End 2"} } |
  Test-PipeSimple |
  Test-PipeAdv |
  Out-GridView