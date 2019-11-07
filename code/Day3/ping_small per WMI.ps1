function Test-OnlineFast
{
    param
    (
        [Parameter(Mandatory)]
        [string[]]
        $ComputerName,
 
        $TimeoutMillisec = 1000
    )
    
    # convert list of computers into a WMI query string
    $query = $ComputerName -join "' or Address='"
 
    Get-WmiObject -Class Win32_PingStatus -Filter "(Address='$query') and timeout=$TimeoutMillisec" | Select-Object -Property Address, StatusCode
 }
 
 $l = 1..10 | ForEach-Object { "cl{0:d2}" -f $_ }
 Test-OnlineFast -ComputerName $l -TimeoutMillisec 1000