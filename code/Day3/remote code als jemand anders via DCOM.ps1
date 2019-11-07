
function Start-ProcessInteractive {
    <#
            .SYNOPSIS
            Launches a program interactively in the visible context of a remote user
            Requires the caller to have full Admin privs on target computer

            .EXAMPLE
            Start-ProcessInteractive -filepath powershell -arguments '[Console]::Beep()' -computername server12
            runs PowerShell and executes the given argument on the specified computer
            in the context of the person currently logged on to that machine

    #>


    param(
        $filepath = 'C:\Program Files (x86)\Internet Explorer\iexplore.exe',
        $arguments = 'www.powershellmagazine.com',
        [Parameter(Mandatory=$true)]
        $computernames
    )

    $computernames | ForEach-Object {
        $computername = $_

  
        $username = Get-WmiObject Win32_ComputerSystem -ComputerName $computername | 
        Select-Object -ExpandProperty UserName
   
        Write-Warning $username
        if ($username -eq $null) {
            Write-Warning "On $computername no user is currently physically logged on."
            $username = Read-Host "Enter username of logged on user at the remote system"
        }
        if ($username -ne '') {

      
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
      <Command>$filepath</Command>
      <Arguments>$arguments</Arguments>
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

      
      
            $jobname = 'remotejob{0}' -f (Get-Random)
      
      
            $xml | Out-File "$env:temp\tj1.xml"
            $null = schtasks /CREATE /TN $jobname /XML $env:temp\tj1.xml /S $computername
            Start-Sleep -Seconds 1
            $null = schtasks /RUN /TN $jobname /S $computername
            $null = schtasks /DELETE /TN $jobname /s $computername /F
        }
    }
}

Start-ProcessInteractive -computername cl03 -filepath 'C:\Program Files (x86)\Internet Explorer\iexplore.exe' -arguments 'https://powershell.one'