function Resolve-IP
{
  [cmdletBinding()]
  param
  (
    [String]
    [Parameter(Mandatory=$true, Position=0, ValueFromPipelineByPropertyName=$true, ValueFromPipeline=$true)]
    $ComputerName
  )
  begin
  {
    #Content
  
  }
  process
  {
    try
    {
      # resolves computername given by parameter
      Write-Verbose -Message "Resolving for $Computername"
      [System.Net.DNS]::GetHostEntry($ComputerName)
    }
    catch
    {
      "Error was $_"
      $line = $_.InvocationInfo.ScriptLineNumber
      "Error was in Line $line"
      # return error further out of function
      throw $_ 
    }
  }
  end
  {
    Remove-Variable ComputerName
  }  
}


# Get-ADComputer -Filter * | Resolve-IP

$ComputerName = 'cl10'
'127.0.0.1', 'CL01', 'CL03' | Resolve-IP