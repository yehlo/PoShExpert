

$exists = Get-PSRepository -Name Team1 -ErrorAction SilentlyContinue
if ($exists -eq $null)
{
  Register-PSRepository -Name Team1 -SourceLocation \\cl10\Repo -InstallationPolicy Trusted
}