




try
{
  Get-ChildItem c:\windows -Recurse -Filter *.log -File -ErrorAction Stop
}
catch [System.UnauthorizedAccessException]
{
  "Ups: $_"
}
