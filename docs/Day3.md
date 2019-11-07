---
permalink: /day3
---

# Day 3
[Back to main](/index)

## Topics
1. [Encrypted code](#encCode)
1. [Working with WMI](#wmi)
1. [Powershell 6/7](#pwsh)
1. [Crossprocess debugging](#crProcDeb)
1. [Speeding Up the Pipeline](#pipeline)
1. [Unit Tests](#pester)
1. [GUI](#gui)

## Encrypted code <a name="encCode"></a>
Start a powershell session with ```powershell -noprofile -encodedcommand $encodedComannd```

To encode a command checkout the following: 
```powershell
$code = {
  $sapi = New-Object -ComObject Sapi.SpVoice
      $sapi.Rate = 0
      $sapi.Speak("I just hacked you dude.")

}

$bytes = [System.Text.Encoding]::Unicode.GetBytes($Code)
$encodedCommand = [Convert]::ToBase64String($bytes)
$encodedCommand
```

This comes in handy if you want to run a long code bit in a scheduled task without having to work around complex bits. 

## Working with WMI <a name="wmi"></a>
There are two possible ways of working with WMI. 
<b>Get-WmiObject: </b>The legacy command to work with wmi. 

```powershell
# example output
Get-Wmi-Object -Class Win32_ComputerSystem
# prints: 
# Domain              : EXPERTCLASS
# Manufacturer        : MSI
# Model               : MS-7971
# Name                : CL02
# PrimaryOwnerName    : RealStuff eXpert Class
# TotalPhysicalMemory : 34245910528
```

<b>Get-CimInstance: </b>The mordern way to work with wmi. 

```powershell
# example output
Get-CimInstance -ClassName Win32_ComputerSystem
# prints: 
# Name             PrimaryOwnerName                          Domain                                    TotalPhysicalMemory                       Model                                    Manufacturer
# ----             ----------------                          ------                                    -------------------                       -----                                    ------------
# CL02             RealStuff eXpert Class                    EXPERTCLASS                               34245910528                               MS-7971                                  MSI
```

### comparison
| Functionality | WMIObject | CimInstance |
| ------------- | --------- | ----------- |
| Readability   | Output as List | Output as table |
| Properties of Objects | Formated in their base way | Formated as powershell objects |
| Calling methods | Directly doable on the returned objects | Needs ```Invoke-CimMethod``` to invoke a method |
| Remoting | Remotes with the old DCOM way seperately foreach command | Supports legacy and mordern remoting with ```New-CimSession``` the protocol is set through ```New-CimSessionOption -Protocol $protocol``` |
| Speed | Tends to be slower because all methods etc. need to be loaded on ```Get-WmiObject``` | Only does what is needed and as such is faster in general |

## FormatEnumerationLimit <a name="FormatEnumerationLimit"></a>
A common problem in powershell is, that long values of properties end with ... like: 

```powershell
Get-Process w* | sort pagedmemorysize | ft name, threads -Wrap –AutoSize
# prints: 
# Name                                                           Threads
# ----                                                           -------
# winlogon                                                       {944, 1264, 3068, 66292...}
# WindowsInternal.ComposableShell.Experiences.TextInput.InputApp {1512, 8948, 1472, 1388...}
```

These dots are a consequence of the default value from ```$FormatEnumerationLimit```

```powershell
$FormatEnumerationLimit
# prints: 4

# now set this to the maximum value: 
$FormatEnumerationLimit = -1
# rerun the command from above
Get-Process w* | sort pagedmemorysize | ft name, threads -Wrap –AutoSize 
# now prints: 
Name                                                           Threads
----                                                           -------
# winlogon                                                       {944, 1264, 3068, 88340, 11376}
# WindowsInternal.ComposableShell.Experiences.TextInput.InputApp {1512, 8948, 1472, 1388, 1384, 11064, 5704, 10480, 10588, 4780, 9560, 4680, 5032, 4956, 4668, 4496, 5600, 5840, 4504, 3256, 3232, 3260, 7432, 1020, 10432, 3220, 11204, 3408, 3424, 9912, 10812, 8164}
```

The variable always needs to be changed on a global level. 
So if you want to edit this limit in a function only, do as follows: 

```powershell
Function Get-Something {
  $oldLimit = $FormatEnumerationLimit
  $global:FormatEnumerationLimit = -1
  # do something
  $global:FormatEnumerationLimit = $oldLimit
}
```

## Powershell 6/7 <a name="pwsh"></a>
Along with being able to run on linux the .exe changed to ```pwsh.exe```. 
Some of the restriction are that built-in GUIs like ```Out-GridView```. Other restrictions include the missing of several windows .net classes that are not available in pwsh. 

```powershell
# install Powershell from online 
# the -Preview parameter installs the newest available version
Invoke-Expression "& { $(irm https://aka.ms/install-powershell.ps1) } -UseMSI -Preview"
```

modules are stored in a different place: 

```powershell
$env:PSModulePath -split ';'
# prints: 
# C:\Users\Administrator\Documents\PowerShell\Modules
# C:\Program Files\PowerShell\Modules
# c:\program files\powershell\7-preview\Modules
# C:\windows\system32\WindowsPowerShell\v1.0\Modules

# visible is, that it is installed in the default location of powershell 
``` 

A new feature is the ternary operator to shorten the spelling of ```if```: 

```powershell
# without ternary
$result = If ($condition) {"true"} Else {"false"}
# ternary 
($condition) ? "true" : "false"
```

Another new feature is the built-in parallelization of Foreach-Object

```powershell
Get-Process | ForEach-Object -Parallel {} -ThrottleLimit #numberOfParallelProcesses

# in comparison in powershell < 6 it looked like this
Install-Module -name PSParallel -Scope CurrentUser -Force
Get-Process | Invoke-Parallel -ScriptBlock {} -ThrottleLimit #numberOfParallelProcesses
```

## Threading <a name="threading"></a>
To make use of true multithreading new processes need to be created. 
Create a thread as follows: 

```powershell
$code = {
  Get-ChildItem -Path C:/ -ErrorAction SilentlyContinue -Filter *.log -Recurse
}
[PowerShell]$ps = [PowerShell]::Create()
$null = $ps.AddScript($code)
$handle = $ps.Invoke()
# process is now running

# wait for process to finish 
do
{
  Start-Sleep -Seconds 5
} while ($handle.IsCompleted -eq $false)

$result = $ps.EndInvoke($handle)
```

If arguments are needed you can make use of ```$null = $ps.AddScript($code).AddArgument($Arguments)```.
To then synchronize data between different thread a synchronized hash is needed which is given to the thread through ```Runspace.SessionStateProxy.SetVariable('dstVar', 'srcVar')```

```powershell
$syncHash = [hashtable]::Synchronized(@{})
$syncHash["OuterData"] = ""

$code = {
  $InnerSyncHash
  $InnerSyncHash["OuterData"] = Get-ChildItem -Path C:/ -ErrorAction SilentlyContinue -Filter *.log -Recurse
}

$null = $ps.AddScript($code)
$handle = $ps.Invoke()
$ps.Runspace.SessionStateProxy.SetVariable("InnerSyncHash",$syncHash)
# check hash for data while the thread is running
```

### Powershell jobs
Default powershell jobs are per default way slower than indifferent powershell processes like above because they exchange their data with the main through wsman and hence all data needs to be serialized and deserialized. 
Commands always have the noun ```Job```. 

This performance impact is compensated with the simplicity of working with these jobs. 
To boost the performance of these jobs they can be run inside the memory but this won't be covered in this article. 

## Crossprocess debugging <a name="crProcDeb"></a>
To debug processes that are run parallel the debuggin always tends to be really complex. 
To work around this issue ```Debug-RunSpace``` can be used. 

Checkout this example: 

```powershell
# start some random script in the background that loops endessly
# Get the process of the script 
# see all powershell processes running 
Get-ChildItem "\\.\pipe\" -Filter '*pshost*'
# or
Get-Process powershell*

# enter the process 
Enter-PSHostProcess -id $id

# get all runspaces 
Get-Runspace

# enter runspace 1
# runspaces ID 1+ are backgroud processes
Debug-Runspace -Id 1
```

Through this method you can then step through this process. 

## Speeding Up the Pipeline <a name="pipeline"></a>
See blog article of Tobias: 

https://powershell.one/tricks/performance/pipeline

##  Unit Tests <a name="pester"></a>
Unit tests check the functionality of a function. This allows the developers to edit functions and check these with existing pester checks without having to built a seperate dev environment. 

```powershell
# install pester
Install-Module -Name Pester -Scope CurrentUser -Force
```


Tests can only be run on function, the following function is used as test: 

```powershell
# scriptname: Write-Test.ps1
function Write-Test {
    [CmdletBinding()]
    param (
        $Name
    )
    try{
        "hello $Name"
    }
    catch{
        throw $_
    }
}
```

An example unit test could look like this: 

```powershell
# scriptname: Write-Test.tests.ps1
. .\Write-Test.ps1

describe 'Write-Test'{

    Context 'Running with arguments' {
        $name = 'pester'
        It 'runs without errors' {
            { Write-Test -Name $name } | Should Not Throw
        }
        It 'writes the parameter with hello' {
            Write-Test -Name $name | Should Be "hello $name"
        }
    }
}
```
All checks are prepended with ```should``` these tell pester on what guidelines these tests work. 

<i>Beware</i>: The script to test is sourced directly ```. .\scriptname.ps1``` which also means that everything is executed right away without any tests.  As such the script should contain functions only like a module. 

### PSkoans
To train pester unit tests the module PSkoans can be utilized. It is a module which presents the user with extensive examples to write tests. 
Per default vsCode is used to play around with unit-tests. 

```powershell
# installing the module
Install-Module -Name PSKoans -Scope CurrentUser -Force

# checks how many unit-tests were written correct
Show-Karma

# opens up VsCode per default and presents the user will all the tests
Show-Karma -Meditate
```
## GUI <a name="gui"></a>
To create a UI in powershell the class ```[System.Windows.Window]``` can be used. 
This is currently available on all windows systems with powershell version >=3. 

Create an example UI

```powershell
# load WPF to make sure it is there 
Add-Type -AssemblyName PresentationFramework

$window = [System.Windows.Window]::new()
$window.Title = 'Info'
$window.Content = 'Hello World'
$window.SizeToContent = 'WidthAndHeight'
$window.MinHeight = 300
$window.MinWidth = 800
$window.ShowDialog()
```

It is best to use an online generator for the WPF xaml and then use powershell to do any necessary computation. 
ISESteroids contains several templates for Powershell WPF templates to automatically generate code. 

Since I don't intend to do much with UIs I wont further indulge into it. 

## Regex <a name="regex"></a>
Powershell supports regex out of the box and allows the use of regex on many operators. 

```powershell
"part1,part2-part3,part4" -replace '[,-]', ';'
```

A special tool in powershell when working with regex through ```-match``` is the ```$Matches``` hashtable. 
It contains the results of the match and creates a new index foreach sub expression. 

```powershell
$toFilter = "I am yehlo and my user ID is U-1502"
$pattern = "I am (?<Name>.+) and my user ID is (U-\d{4})"

$toFilter -match $pattern # returns a boolean
$Matches
# prints: 
# Name                           Value
# ----                           -----
# Name                           yehlo
# 1                              U-1502
# 0                              I am yehlo and my user ID is U-1502
```

Each ```()``` pair is considered as sub expression and is as such storead in a seperate index of the ```$Matches``` hashtable. 
The ```0``` index always contains the match of the whole pattern. 
Through the expression ```(?<Name>.+)``` the index ```name``` is created in the hashtable and everything that matched the subsequent pattern (here ```.+```) is then stored as the value of the key. If no key is specified through ```?<keyName>``` like ```(U-\d{4})```  the index is incremented starting from ```0``` and the subsequent pattern is stored as value. 