

$cred = Get-Credential test



Get-WmiObject -ComputerName clxx -Class Win32_BIOS -ErrorAction SilentlyContinue
Get-WmiObject -ComputerName cl01 -Class Win32_BIOS -ErrorAction SilentlyContinue

try
{
  # security probleme lösen SOFORT terminierende fehler aus, die sich absolut NICHT um
  # -ErrorAction scheren:
  Get-WmiObject -ComputerName cl01 -Class Win32_BIOS -ErrorAction SilentlyContinue -Credential $cred

}
catch
{
  'Ups!'
}



try
{
  # wandelt nicht-terminierende in termininerende fehler
  Get-WmiObject -ComputerName cl082563 -Class Win32_BIOS -ErrorAction stop

}
catch
{
  # kann ausschliesslich terminierende fehler behandeln
  'Rechner nicht da!'
}