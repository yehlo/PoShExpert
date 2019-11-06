function New-RemoteFunction {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]
        $function, 

        [Parameter(Mandatory = $true, Position = 1)]
        [psobject]
        $session
    )
    try{
        $functionRaw = (get-command $function).ScriptBlock
        $functionAsStr = "function $function{"
        $functionAsStr += $functionRaw
        $functionAsStr += "}"
        $functionAsSb = [Scriptblock]::Create($functionAsStr)
        Invoke-Command -session $session -ScriptBlock $functionAsSb
    }
    catch{
        "Error was $_"
        $line = $_.InvocationInfo.ScriptLineNumber
        "Error was in Line $line"

        # return error further out of function
        throw $_ 
    }
}