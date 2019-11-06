#requires -runasadministrator

$computer = 'CL02'
Enable-WSManCredSSP -Role Client -DelegateComputer $computer
$code = { Enable-WSManCredSSP -Role Server -Force }
Invoke-Command -ScriptBlock $code -ComputerName $computer 