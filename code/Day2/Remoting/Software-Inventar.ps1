






$Path = 'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*',
    'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*'
Get-ItemProperty -Path $Path |
Select-Object -Property DisplayName, DisplayVersion, UninstallString |
Where-Object -Property DisplayName |
Sort-Object -Property DIsplayName |
Out-GridView
