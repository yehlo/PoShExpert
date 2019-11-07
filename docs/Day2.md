---
permalink: /day2
---

# Day 2
[Checkout the code of Tobias on this day.]({{ site.github.repository_url | relative_url }}/blob/master/code/Day2){:target="_blank" rel="noopener"}

## Topics
1. [Profile](#profile)
1. [Execution Policy](#exPol)
1. [Scriptblock analyzer](#scriptblocklogginganalyzer)
1. [Powershell 2](#Powershellv2)
1. [Remoting](#psremoting)

## Profile <a name="profile"></a>
The profile of powershell resets everytime a new session is launched. 
Every tool (ISE, VScode, etc.) has a different profile. 
To get the profile path you can parse the ```$profile``` variable. 
```powershell
$profile  # Local profile
$profile.CurrentUserAllHosts # Writes into roaming profile of current user
$profile.AllUsersCurrentHost # Writes into local profiles
$profile.AllUsersAllHosts # Writes into romaing profile of all users
```

Example profile:
```powershell
# Update PoSh prompt
# The prompt function is run after every command
function prompt{
    'PS> '
    $host.UI.RawUI.WindowTitle = Get-Location # show current directory
}

# Change color of errors to green to calm down stress of errors
$host.PrivateData.ErrorAccentColor = 'Green'

# Initialize some company repository
$exists = Get-PSRepository -Name RepoName -ErrorAction SilentlyContinue
if ($exists -eq $null)
{
  Register-PSRepository -Name RepoName -SourceLocation \\share\Repo -InstallationPolicy Trusted
}

# Default parameter values
# Every cmdlet with parameter computerName should fill this by default with 'someHost01'
$PSDefaultParameterValues['*:ComputerName'] = 'someHost01' 
```

## Execution Policy <a name="exPol"></a>
The execution policy is no firewall, it just limits the scripts that can be run.
If a script is run powershell checks each scope and the respective execution policy. The first policy that is not 'undefined' will be applied. 

```powershell
Get-ExecutionPolicy -List
#         Scope ExecutionPolicy
#         ----- ---------------
# MachinePolicy       Undefined
#    UserPolicy       Undefined
#       Process       Undefined
#   CurrentUser       Undefined
#  LocalMachine          Bypass
```

A lot of installation scripts nowadays use powershell and hence are restricted to the ExecutionPolicy. The following is advised for an examplary executionPolicy:
```
         Scope ExecutionPolicy
         ----- ---------------
 MachinePolicy       Undefined # so that install scripts can run
    UserPolicy       Undefined # so that install scripts can run
       Process       Undefined # the script will set this itself 
   CurrentUser    RemoteSigned # so that all local scripts can be run for any user but remote scripts need to be signed
  LocalMachine          Bypass # so that an admin can do whatever he pleases
```

### Modes explained: 

| ExecutionPolicy        | Explanation           |
| ------------- | ------------- |
| Undefined | No protection whatsoever on this level, if everything is set to undefined no scripts can be run |
| Bypass | Bypass allows for any script to be run | 
| All Signed | All scripts need to be signed, usually never used |
| Unrestrycted | Runs all scripts but messages the user if the remote script is not signed |
| Restricted | No script can run |
| RemoteSigned | Das Script muss remote signiert werden |

### Scopes explained

| ExecutionPolicy | Explanation |
| ------------- | ------------- |
| MachinePolicy | Set by a Group Policy for all users of the computer. |
| UserPolicy | Set by a Group Policy for the current user of the computer. |
| Process | Current Powershell session |
| CurrentUser | Affects only the current user and can be overwritten by admin | 
| LocalMachine | Affects all users on the current computer |

## Scriptblock analyzer <a name="scriptblocklogginganalyzer"></a>
To analyse any powershell codeblocks that were run on the machine the module ```scriptblocklogginganalyzer``` can be used. 
Logged is any scriptblock of powershell 5+. 

Install and Enable: 
```powershell
# enable script Analyzer
Install-Module -name scriptblocklogginganalyzer -Scope CurrentUser -force
Set-SBLLogSize -MaxSizeMB 1000
Enable-SBL
Get-SBLStatus 
# shoud print
#EnableScriptBlockLogging EnableScriptBlockInvocationLogging SettingsKeyExists ScriptBlockLoggingActive
#------------------------ ---------------------------------- ----------------- ------------------------
#                    True                               True              True                     True
```
Doing a reboot after installation is advised. 

Read Events
```powershell
# show all events in Gridview that are from unlikely locations
Get-SBLEvent | 
  Where-Object { $_.Name -notmatch '(\[from memory\]|\.ps1|\.psd1|\.psm1)$' } |
  Out-GridView
```

### Protect the log
Since the log contains any scriptblock that is run on the machine the log needs to be protected from malicious attacks. 
To limit the access of the log local admin rights are needed. 

```powershell
# to protect the log
function Protect-SBLLog
{
  $channelAccess = 'O:BAG:SYD:(A;;0x2;;;S-1-15-3-1024-3153509613-960666767-3724611135-2725662640-12138253-543910227-1950414635-4190290187)(A;;0xf0007;;;SY)(A;;0x7;;;BA)(A;;0x7;;;SO)(A;;0x3;;;S-1-5-3)'
  
  $Path = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\winevt\Channels\Microsoft-Windows-PowerShell/Operational"
  #$channelAccess = ((wevtutil gl security) -like 'channelAccess*').Split(' ')[-1]
  Set-ItemProperty -Path $Path -Name ChannelAccess -Value $channelAccess
  Restart-Service -Name EventLog -Force
}

# to allow users to access the log
function Unprotect-SBLLog
{
  $channelAccess = 'O:BAG:SYD:(A;;0x2;;;S-1-15-2-1)(A;;0x2;;;S-1-15-3-1024-3153509613-960666767-3724611135-2725662640-12138253-543910227-1950414635-4190290187)(A;;0xf0007;;;SY)(A;;0x7;;;BA)(A;;0x7;;;SO)(A;;0x3;;;IU)(A;;0x3;;;SU)(A;;0x3;;;S-1-5-3)(A;;0x3;;;S-1-5-33)(A;;0x1;;;S-1-5-32-573)'
  $Path = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\winevt\Channels\Microsoft-Windows-PowerShell/Operational"
  Set-ItemProperty -Path $Path -Name ChannelAccess -Value $channelAccess
  Restart-Service -Name EventLog -Force
}
```

## Powershell 2 <a name="Powershellv2"></a>
Per default Powershellv2 is installed on any windows machine to help with backwards compatibility. 
Powershell 2 was the last version without any security features, hence it gives malicious users a lot of additional attack vectors. 

Some of the security breaches are that there is no connector to any anti virus, no Scriptblocklogging etc. 

To disable Powershell 2 run the following code: 
```powershell
Disable-WindowsOptionalFeature -FeatureName MicrosoftWindowsPowerShellV2, MicrosoftWindowsPowerShellV2Root -Online -NoRestart
```

## Remoting <a name="psremoting"></a>
In the world of psremoting there is the differentiation between legacy and universal psremoting. 

<b>Legacy:</b> Legacy psremoting used with a lot of old commands like ```Get-WmiObject -computername```. It works on a process and command level and developers all did their own magic.   
<b>Universal:</b> Remoting needs to be configured once through wsman and then is able to remote any command locally on the computer. A lot of the newer commands utilize wsman per default but you could also fallback to ```Invoke-Command``` which opens a connection through wsman and does the necessary calls. 

Commands to enable remoting: 
```powershell
    netsh firewall set service remoteadmin enable
    Set-Service -name RemoteRegistry -StartupType Manual -Status Running 
    # trust the target if it isn't in the same domain 
    # be careful with trusting, here * is trusted in production only specific devices should be trusted
    Set-Item WSMan:\localhost\Client\TrustedHosts -Value * -Force 
```

### Sessions
If multiple commands need to be invoked in different places of the script a pssession ```New-PSSession``` is the way to go. It initiates the session at a starting point and ```invoke-command -Session $s``` only redirects the specified command without having to (de-)construct the session. 

![CmdletWorkflow]({{site.github.repository_url | relative_url }}/tree/master/assets/images/psremoting.png)
The communication is done through the wsman only. It returns XML patterns which are then interpeted by wsman and transformed to readable powershell objects. 

### Enter-* 
To enter the session interactively you can use the command ```Enter-PSSession```. No GUI can be started through this session. 
In Powershell there is the additional possibility to enter existing powershell processes through ```Enter-PSHostProcess -id $id``` 

Example: 
```powershell
PS > Enter-PSSession -ComputerName <hostname>
[hostname]: PS > Get-Process powershell* 
# prints 
# Handles  NPM(K)    PM(K)      WS(K)     CPU(s)     Id  SI ProcessName
# -------  ------    -----      -----     ------     --  -- -----------
#    1889      99   315616     374828      21.75   5888   1 powershell_ise
#    1547      93   301408     365064      15.31  10024   1 powershell_ise
[hostname]: PS > Enter-PSHostProcess 10024 
[hostname]: [Process:10024]: PS> # now you can do anything in the context of the signed in user
[hostname]: [Process:10024]: PS> Start-Process notepad.exe "test" # will start notepad.exe on the user 

# now to have fun with it: 
[hostname]: [Process:10024]: PS> $sapi = New-Object -ComObject Sapi.SpVoice
[hostname]: [Process:10024]: PS> $sapi.Speak("You are hacked!")
```

To stop this from happening the local administrator rights should be kept to either a small user group or restrict the ways of accessing the poweshell from remote overall. 

### Double-Hop
To resolve the issues around double-Hop authentication you can make use of CredSSP and endpoints. 

<b>CredSSP</b> 
Adds another layer of complexity and functionality to psremmoting. 
To enable CredSSP: 

```powershell
# sets the current machine as Client and allows the target to be used as double-hop
Enable-WSManCredSSP -Role "Client" -DelegateComputer $ComputerName
# sets the target to allow connections for double-hop
$code = { Enable-WSManCredSSP -Role Server -Force }
Invoke-Command -ScriptBlock $code -ComputerName $ComputerName 
```

<b>Endpoints</b>
When connecting to another device you always end up with the same default endpoint (connector). This endpoint restricts the possibilities of the session. 
Endpoints are an easier way of working around this issue. 

```powershell
# read current configuration
Get-PSSessionConfiguration 

# add new endpoint with extended configuration
Register-PSSessionConfiguration -Name DoubleHopFree -RunAsCredential Administrator -ShowSecurityDescriptorUI -Force
# this sets the connected user to automatically run as Administrator (-RunAsCredential) 
# The allowed users are then configured manually with usual microsoft permissions

# to enter this sessions
Invoke-Command -ComputerName $ComputerName -ConfigurationName DoubleHopFree
```

The already mentioned restriction of ways to access the remote powershell is doable through endpoints. Endpoints won't be covered any further and googling is your ally here. 
