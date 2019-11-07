
# This is a proxy function for the cmdlet 'Out-Default'
# The proxy function will behave exactly like the underlying cmdlet.
# You can however adjust the code and add custom functionality like
# additional parameters etc.



function Out-Default
{
  [CmdletBinding(RemotingCapability='None')]
  param(
    [switch]
    ${Transcript},

    [Parameter(ValueFromPipeline=$true)]
    [psobject]
  ${InputObject})

  begin
  {
    $scriptCmd = { Select-Object -Property * | & Microsoft.PowerShell.Core\Out-Default @PSBoundParameters  }
    $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
    $steppablePipeline.Begin($PSCmdlet)
  }

  process
  {
    $steppablePipeline.Process($_)
  }

  end
  {
          $steppablePipeline.End()
  }

}
