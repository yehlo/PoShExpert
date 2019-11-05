

Register-PSRepository -Name Team1 -SourceLocation \\cl10\repo -InstallationPolicy Trusted 


Publish-Module -Name Netzwerktools -Repository team1

Find-Module -Repository team1
Install-Module -Name Netzwerktools -Repository team1 -Scope CurrentUser

Find-Module -Repository team1 -AllVersions -Name Netzwerktools


Update-Module -Name Netzwerktools


# alle Module, die aus dem Repository "Team1" installiert wurden, auf Updates überprüfen
Get-InstalledModule  | Where-Object Repository -eq Team1 | Update-Module

