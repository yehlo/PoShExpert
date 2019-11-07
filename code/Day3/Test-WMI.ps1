function Convert-ObjectToHash
{
    param
    (
        [Parameter(Mandatory,ValueFromPipeline)]
        $object,

        [Switch]
        $ExcludeEmpty
    )

    process
    {
        $object.PSObject.Properties | 
        # sort property names
        Sort-Object -Property Name |
        # exclude empty properties if requested
        Where-Object { $ExcludeEmpty.IsPresent -eq $false -or $_.Value -ne $null } |
        ForEach-Object { 
            $hash = [Ordered]@{}} { 
            $hash[$_.Name] = $_.Value 
            } { 
            $hash 
            } 
    }
}


function Find-WmiClass
{
  # show all properties, not just 4
  $oldLimit = $FormatEnumerationLimit
  $global:FormatEnumerationLimit = -1
  # list all WMI classes...
  Get-WmiObject -Class * -List | 
  # ...with at least 4 properties
  Where-Object { $_.Properties.Count -gt 4 } |
  # let the user select one 
  Out-GridView -Title 'Select a class that seems interesting' -OutputMode Single |
  ForEach-Object {
    # query the selected class
    $Name = $_.name
    $props = Get-CimInstance -Class $Name | 
    # take the first instance
    Select-Object -Property * -First 1 |
    ForEach-Object {
      # turn the object into a hashtable, and exclude empty properties
      $_ | & {
              $_.PSObject.Properties | 
        Sort-Object -Property Name |
        Where-Object { $_.Value -ne $null } |
        ForEach-Object { 
            $hash = [Ordered]@{}} { $hash[$_.Name] = $_.Value } { $hash } 
        } | 
        # show the properties and let the user select
        Out-GridView -Title "$name : Select all properties you need (hold CTRL)" -PassThru |
        ForEach-Object {
          # return the selected property names
          $_.Name
        }
    } 
    # take all selected properties
    $prop = $props -join ', '
    # create the command for it:
    $a = "Get-CIMInstance -Class $Name | Select-Object -Property $prop" 
    # place it into the clipboard
    $a | Set-ClipBoard
    Write-Warning "Command is also available from the clipboard"
    $a
  }
  # reset format limit
  $global:FormatEnumerationLimit = $oldLimit
}
