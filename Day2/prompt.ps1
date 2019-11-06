
function prompt 
{
  'PS> '
  $freq = Get-Random -Minimum 300 -Maximum 10000
  #[Console]::Beep($freq,300)
  $host.UI.RawUI.WindowTitle = Get-Location
}

$host.PrivateData.ErrorForegroundColor = 'Green'

$PSDefaultParameterValues['*:ComputerName'] = 'CL03'