﻿

$job1 = {  dir c:\windows}
$job2 = {  Get-Service }
$job3 = {  Get-Process }



$j1 = Start-JobInProcess -ScriptBlock $job1
$j3 = Start-JobInProcess -ScriptBlock  $job3


$ej2 = & $job2


$null = Wait-Job -Job $J1, $j3


$ej1 = Receive-Job -Job $j1
$ej3 = Receive-Job -Job $j3

Remove-Job -Job $j1, $j3

#$ej1, $ej2, $ej3