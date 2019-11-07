


Get-WmiObject -Class Win32_ComputerSystem


Get-CimInstance -Class Win32_ComputerSystem -ComputerName cl01,cl02,cl03


Get-WmiObject -Class Win32_OperatingSystem -ComputerName cl01,cl02,cl03 | Select-Object -Property *Date*, PSComputerName
Get-CimInstance -Class Win32_OperatingSystem -ComputerName cl01,cl02,cl03 | Select-Object -Property *Date*, PSComputerName

# DCOM
Get-WmiObject -Class Win32_Process -Filter 'Name LIKE "%powershell%"' -ComputerName cl03 |
ForEach-Object {
  $user = $_.GetOwner()
  [PSCustomObject]@{
    Name = $_.Name
    Owner = '{0}\{1}' -f $user.Domain, $user.User
  }
}
  
# WinRM
Get-CimInstance -Class Win32_Process -Filter 'Name LIKE "%powershell%"' -ComputerName cl03 |
ForEach-Object {
  $prozess = $_
  $prozess | 
  Invoke-CimMethod -MethodName GetOwner | 
  Select-Object Domain, User |
  Add-Member -MemberType NoteProperty -Name ProcessName -Value $prozess.Name -PassThru
}



[PSCustomObject]@{
  BIOS = Get-WmiObject -Class Win32_BIOS -ComputerName cl03
  Shares = Get-WmiObject -Class Win32_Share -ComputerName cl03
  OS = Get-WmiObject -Class Win32_OperatingSystem -ComputerName cl03
  PC = Get-WmiObject -Class Win32_ComputerSystem -ComputerName cl03
} | Out-GridView


# alter Standard
$option = New-CimSessionOption -Protocol Dcom
# neuer Standard (Default)
$option = New-CimSessionOption -Protocol Wsman

$session = New-CimSession -ComputerName cl03 -SessionOption $option 
[PSCustomObject]@{
  BIOS = Get-CimInstance -Class Win32_BIOS -CimSession $session
  Shares = Get-CimInstance -Class Win32_Share -CimSession $session
  OS = Get-CimInstance -Class Win32_OperatingSystem -CimSession $session
  PC = Get-CimInstance -Class Win32_ComputerSystem -CimSession $session
} | Out-GridView


Remove-CimSession -CimSession $session




$option = New-CimSessionOption -Protocol Wsman

$session = New-CimSession -ComputerName cl03, cl02, cl01, cl09 -SessionOption $option 

$bios = Get-CimInstance -ClassName Win32_BIOS -CimSession $session | Sort-Object -Property PSComputerName
$Shares = Get-CimInstance -Class Win32_Share -CimSession $session | Sort-Object -Property PSComputerName
$OS = Get-CimInstance -Class Win32_OperatingSystem -CimSession $session | Sort-Object -Property PSComputerName
$PC = Get-CimInstance -Class Win32_ComputerSystem -CimSession $session | Sort-Object -Property PSComputerName

$bios | ForEach-Object { $c = 0 } {
  
  [PSCustomObject]@{
    BIOS = $_
    Shares = $Shares[$c]
    OS = $os[$c]
    PC = $pc[$c]
  
  } | Out-GridView -Title $_.PSComputerName
  $c++
}

Remove-CimSession -CimSession $session

$Path = "$env:temp\report.xlsx"

$option = New-CimSessionOption -Protocol Wsman

$session = New-CimSession -ComputerName cl03, cl02, cl01, cl09 -SessionOption $option 

$bios = Get-CimInstance -ClassName Win32_BIOS -CimSession $session | Sort-Object -Property PSComputerName
$Shares = Get-CimInstance -Class Win32_Share -CimSession $session | Sort-Object -Property PSComputerName
$OS = Get-CimInstance -Class Win32_OperatingSystem -CimSession $session | Sort-Object -Property PSComputerName
$PC = Get-CimInstance -Class Win32_ComputerSystem -CimSession $session | Sort-Object -Property PSComputerName

$bios | ForEach-Object { $c = 0 } {
  
  [PSCustomObject]@{
    BIOS = $_
    Shares = $Shares[$c]
    OS = $os[$c]
    PC = $pc[$c]
  
  } | Export-Excel -Path $Path -WorksheetName $_.PSComputerName -FreezeTopRow -BoldTopRow -AutoSize
  $c++
}

Remove-CimSession -CimSession $session
Start-Process -FilePath excel -ArgumentList $Path