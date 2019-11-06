

# Get-ADComputer -Filter * | Resolve-IP
# '127.0.0.1', 'CL01', 'CL03' | Resolve-IP



$ComputerName = 'cl10'


[System.Net.DNS]::GetHostEntry($ComputerName)