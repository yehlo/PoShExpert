# Achtung: Process-ID des zu debuggenden Prozesses einsetzen:

Enter-PSHostProcess -id 15572
Get-Runspace
Debug-Runspace -Id 1