$liste = 10, 3,4,9,8,6,1,2 | ForEach-Object { 'CL{0:d2}' -f $_ }
$liste = $liste -ne $env:COMPUTERNAME

function Invoke-PowerShellAsInteractiveUser 
{
    param(
        [Parameter(Mandatory)]
        [ScriptBlock]
        $ScriptCode,
    
        [Parameter(Mandatory)]
        [String[]]
        $Computername
    )

    $code = { 
      
        param($ScriptCode)

        $bytes = [System.Text.Encoding]::Unicode.GetBytes($ScriptCode)
        $encodedCommand = [Convert]::ToBase64String($bytes)
        
        $os = Get-WmiObject -Class Win32_ComputerSystem
        $username = $os.UserName

        $xml = @"  
<?xml version="1.0" encoding="UTF-16"?>
<Task version="1.2" xmlns="http://schemas.microsoft.com/windows/2004/02/mit/task">
  <RegistrationInfo />
  <Triggers />
  <Settings>
    <MultipleInstancesPolicy>IgnoreNew</MultipleInstancesPolicy>
    <DisallowStartIfOnBatteries>false</DisallowStartIfOnBatteries>
    <StopIfGoingOnBatteries>false</StopIfGoingOnBatteries>
    <AllowHardTerminate>true</AllowHardTerminate>
    <StartWhenAvailable>false</StartWhenAvailable>
    <RunOnlyIfNetworkAvailable>false</RunOnlyIfNetworkAvailable>
    <IdleSettings />
    <AllowStartOnDemand>true</AllowStartOnDemand>
    <Enabled>true</Enabled>
    <Hidden>false</Hidden>
    <RunOnlyIfIdle>false</RunOnlyIfIdle>
    <WakeToRun>false</WakeToRun>
    <ExecutionTimeLimit>PT72H</ExecutionTimeLimit>
    <Priority>7</Priority>
  </Settings>
  <Actions Context="Author">
    <Exec>
      <Command>powershell.exe</Command>
      <Arguments>-windowstyle minimized -encodedCommand $EncodedCommand</Arguments>
    </Exec>
  </Actions>
  <Principals>
    <Principal id="Author">
      <UserId>$username</UserId>
      <LogonType>InteractiveToken</LogonType>
      <RunLevel>HighestAvailable</RunLevel>
    </Principal>
  </Principals>
</Task>
"@
      
      
          
        $jobname = 'remotejob' + (Get-Random)
        $xml | Out-File -FilePath "$env:temp\tj1.xml"
        $null = schtasks.exe /CREATE /TN $jobname /XML $env:temp\tj1.xml 
        Start-Sleep -Seconds 1
        $null = schtasks.exe /RUN /TN $jobname 
        $null = schtasks.exe /DELETE /TN $jobname  /F 
    }
    
    Invoke-Command -ScriptBlock $code -ComputerName $computername -ArgumentList $ScriptCode -ErrorAction SilentlyContinue -ErrorVariable connectError
    $connectError | Select-Object -Property TargetObject,ErrorDetails 
    
}




$code = {
    
      $sapi = New-Object -ComObject Sapi.SpVoice
      $sapi.Rate = 0
      $sapi.Speak("i")
      
    

}


Invoke-PowerShellAsInteractiveUser -ScriptCode $code -Computername localhost
