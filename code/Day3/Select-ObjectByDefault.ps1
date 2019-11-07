
# This is a proxy function for the cmdlet 'Out-Default'
# The proxy function will behave exactly like the underlying cmdlet.
# You can however adjust the code and add custom functionality like
# additional parameters etc.



function Out-Default
{
[CmdletBinding(HelpUri='https://go.microsoft.com/fwlink/?LinkID=113362', RemotingCapability='None')]
param(
    [switch]
    ${Transcript},

    [Parameter(ValueFromPipeline=$true)]
    [psobject]
    ${InputObject})

begin
{
    try {
        $outBuffer = $null
        if ($PSBoundParameters.TryGetValue('OutBuffer', [ref]$outBuffer))
        {
            $PSBoundParameters['OutBuffer'] = 1
        }
        $wrappedCmd = $ExecutionContext.InvokeCommand.GetCommand('Microsoft.PowerShell.Core\Out-Default', [System.Management.Automation.CommandTypes]::Cmdlet)
        $scriptCmd = { Select-Object -Property * | & $wrappedCmd @PSBoundParameters  }
        $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
        $steppablePipeline.Begin($PSCmdlet)
    } catch {
        throw
    }
}

process
{
    try {
        $steppablePipeline.Process($_)
    } catch {
        throw
    }
}

end
{
    try {
        $steppablePipeline.End()
    } catch {
        throw
    }
}
<#

.ForwardHelpTargetName Microsoft.PowerShell.Core\Out-Default
.ForwardHelpCategory Cmdlet

#>

}
