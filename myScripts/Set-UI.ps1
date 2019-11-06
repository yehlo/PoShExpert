Function Set-UI{
    <#
    .SYNOPSIS
    Either pins or unpins a program the user wants

    .PARAMETER Path
    Path defines the program to be pinned

    .PARAMETER Target
    Choose either the startmenu or the taskbar as location for the action

    .PARAMETER Mode
    Either pin or unpin the defined program to the target

    .EXAMPLE
    Pin-ProgramToStart -Path Value -Anheften

    .EXAMPLE
    Set-UI -Path powershell -Target Start -Mode UnPin
    Unpins powershell from the start

    .NOTES
    The code will fail if the program is already pinned / not pinned
    Currently the script is unable to bin to the taskbar
    #>
    [CmdletBinding()]
    param (
        # Parameter help description
        [Parameter(Mandatory = $true, Position = 0)]
        [String]
        $Path,

        [Parameter(Mandatory = $true, Position = 1)]
        [String]
        [ValidateSet('Start', 'Taskbar')]
        $Target, 

        [Parameter(Mandatory = $true, Position = 2)]
        [String]
        [ValidateSet('Pin', 'UnPin')]
        $Mode
    )
    try{
        # Stop on any error
        $ErrorActionpreference = "Stop"

        $Program = (Get-Command -Name $Path).Source

        $obj = (New-Object -ComObject Shell.Application).
            NameSpace(0).
            ParseName($Program)

        if ($Mode -eq 'Pin'){
            $obj.verbs() |
            Where-Object {$_.Name.replace('&','') -like "Pin*$Target*"} | 
            Tee-Object -Variable out |
            ForEach-Object {$_.DoIt()}
        }
        else{
            $obj.verbs() |
            Where-Object {$_.Name.replace('&','') -like "UnPin*$Target*"} | 
            Tee-Object -Variable out |
            ForEach-Object {$_.DoIt()}
        }

        # if no action was found the program is either already pinned or already unpinned
        if (! $out){
            throw "$program is already $($Mode)ed please adjust your settings"
        }
    }
    catch{
        "Error was $_"
        $line = $_.InvocationInfo.ScriptLineNumber
        "Error was in Line $line"

        # return error further out of function
        throw $_ 
    }
}