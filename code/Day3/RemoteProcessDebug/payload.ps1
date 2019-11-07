

$Pid


for ($x = 1000; $x -lt 15000; $x += 100) 
{
  "Frequency $x Hz"
  [Console]::Beep($x, 500)
  Start-Sleep -Seconds 1
}
