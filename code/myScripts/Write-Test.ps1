
function Write-Test {
    [CmdletBinding()]
    param (
        $Name
    )
    try{
        "hello $Name"
    }
    catch{
        throw $_
    }
}