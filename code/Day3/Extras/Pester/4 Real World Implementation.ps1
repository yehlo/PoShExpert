function Restart-InactiveComputer
{
  # wird ein Explorer ausgeführt?
  $explorer = Get-Process -Name explorer -ErrorAction SilentlyContinue
  # nein, also neu starten
  if ($explorer.Count -eq 0)
  {
    Restart-Computer -Force
  }
}

