<#
install-module -name psonetools -Scope CurrentUser -Force
Install-Module -name PSParallel -Scope CurrentUser -Force
#>


$all = 1..255 | ForEach-Object { "192.168.88.$_" }
$all | Invoke-Parallel -ScriptBlock { 

  $online =  Test-PSOnePort -ComputerName $_ -Port 5985 -Timeout 1000 -ExitOnSuccess
  
  [PSCustomObject]@{
    Online=$online
    ComputerName=$_
    Port=5985} 
    
    } -ThrottleLimit 80

