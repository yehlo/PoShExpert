Function New-ShortCut {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]
        $Path,

        [Parameter(Mandatory = $true, Position = 1)]
        [ValidateScript({Test-Path $(Get-command $_ | select-object -ExpandProperty Source)})]
        [string]
        $TargetPath, 

        [Parameter(Mandatory = $false, Position = 2)]
        [string]
        $ShortcutArguments = "",

        [Parameter(Mandatory = $false, Position = 3)]
        [String]
        $desc = "this is a description created by $env:USERNAME",
        
        [Parameter(Mandatory = $false, Position = 4)]
        [String]
        $workingDir = "C:\Windows\System32",

        [Parameter(Mandatory = $false, Position = 5)]
        [String]
        $WindowStyle = 9,

        [Parameter(Mandatory = $false, Position = 6)]
        [String]
        $Icon,

        [Parameter(Mandatory = $false, Position = 7)]
        [String]
        $HotKey = "",

        [Parameter(Mandatory = $false, Position = 8)]
        [switch]
        $force = $false
    )
    try {
        # check if link already exists and stop if force is not set
        if ((Test-Path $path) -and (! $force)){
            throw "file exists, please use force"
        }

        # initialize Link Object
        $shell = New-Object -ComObject WScript.Shell
        $link = $Shell.CreateShortcut($path)

        # mandatory arguments
        $link.TargetPath = $TargetPath
        
        # optional arguments
        $link.Arguments = $ShortcutArguments
        $link.Description = $desc
        $link.WorkingDirectory = $workingDir
        $link.WindowStyle = $WindowStyle
        $link.HotKey = $HotKey

        # if no icon was defined set default icon of target application
        if (! $icon){
            $source = Get-command $TargetPath | select-object -ExpandProperty Source
            $link.IconLocation = "$source,0"
        }
        
        # create shortcut
        $link.Save()
    }
    catch {
        "Error was $_"
        $line = $_.InvocationInfo.ScriptLineNumber
        "Error was in Line $line"

        # return error further out of function
        throw $_ 
    }
}

