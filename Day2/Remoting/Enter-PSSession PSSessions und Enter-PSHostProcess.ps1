

$cred = Get-Credential -UserName Administrator -Message Anmelden

$session = New-PSSession -ComputerName cl03, cl04, cl01 -Credential $cred


Invoke-Command -ScriptBlock { $env:COMPUTERNAME } -Session $session

Enter-PSSession -Session $session[0]

Get-Process -Name *powershell* 
Enter-PSHostProcess -id 5604

$sapi = New-Object -ComObject Sapi.SpVoice
$sapi.Speak("You are hacked!")
Exit-PSHostProcess
Exit-PSSession