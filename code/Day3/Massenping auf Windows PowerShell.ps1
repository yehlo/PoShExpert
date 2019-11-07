<#
    install-module -name psonetools -Scope CurrentUser -Force
    Install-Module -name PSParallel -Scope CurrentUser -Force
#>


$all = 1..255 | ForEach-Object { "192.168.88.$_" }
$all | Invoke-Parallel -ScriptBlock { 
  $computer = $_
  Test-PSOnePing -ComputerName $_ -Timeout 1000 |
    Where-Object Online |
    Add-Member -MemberType NoteProperty -Name DNSName -Value $(try { [System.Net.DNS]::GetHostEntry($computer).HostName } catch { '(???)'}) -PassThru
    
    } -ThrottleLimit 80

