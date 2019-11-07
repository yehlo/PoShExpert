---
permalink: /day1
---

# Day 1
[Checkout the code of Tobias on this day.]({{ site.github.repository_url | relative_url }}/blob/master/code/Day1){:target="_blank" rel="noopener"}

## Topics
1. [Invoke-WebRequest vs Invoke-RestMethod](#Invoke)
1. [Powershell Cmdlet Structure](#cmdletStructure)
1. [ISE Steroids](#steroids)
1. [Pipelines](#pipelines)
1. [Custom Select-Object](#select)
1. [Begin / Process / End](#FunctionWorkflow)
1. [Advanced Functions](#advFunctions)
1. [Classes](#classes)
1. [Powershell LifeCycle](#PoShLifeCycle)
1. [Non-Terminating Errors](#errorhandlig)

## Invoke-WebRequest vs Invoke-RestMethod <a name="Invoke"></a>
We learned that these both are basically the same with some minor differences.  
The notable difference is that webRequest returns the raw data and RestMethod converts the output to a psObject. 

As for when to use which I prefer always using RestMethod since there are no typeconversions needed. 

## Powershell Cmdlet Structure <a name="cmdletStructure"></a>  
The following is the order of what a powershell commandlet does: 


![CmdletWorkflow](https://raw.githubusercontent.com/yehlo/PoShExpert/master/assets/images/Cmdlet_Workflow.png)

1. The uppermost priority is the pipeline, whenever one is defined the data is sent there
2. If no pipeline is defined, the command tries to send the output to a variable 
3. If there is no variable assignment and no pipeline the output is posted to the console

### Special Case: Tee-Object
To make use of case 1 and 2 you can use the cmdlet ```Tee-Object```. 
This sends the output to the next pipeline and allows writing the output out to a variable or a file. 

```powershell
Get-Process | Tee-Object -Variable processes | Stop-Process -WhatIf
Write-Output $processes
# prints all processes found
```

This allows for log entries or variables from "not fully processed" data. 

## ISE Steroids <a name="steroids"></a>
If you are using a windows machine there is the opportunity to use ISE steroids which adds a lot of extended functionalities to the powershell. 
[ISE Steroids](https://powershell.one/isesteroids/quickstart/overview){:target="_blank" rel="noopener"}

A notable feature is the possibility to inspect the source code of classes and functions. 

## Custom Select-Object <a name="select"></a>
Sometimes there are situations where the object properties need to be renamed for further computation. 
To make use of this properties can be filtered with a hashtable. 
To following object is used as baseline: 
```powershell
$process = Get-Process | select-object -property id, ProcessName -first 1 
write-output $process
# Prints
#   Id ProcessName         
#   -- -----------         
# 6160 ApplicationFrameHost
```

Now only ID and ProcessName are needed and for clearification the ID is renamed to pid. 
```powershell
# first a hashtable doing the necessary computation is needed
$id =  @{
    Name = 'pid'
    Expression = { $_.Id }
}

# this defines that if called the scriptblock of expression is run and the property is renamed
$processes = Get-Process | select-object -property $id, ProcessName -first 1
write-output $processes
# Prints:
#  pid ProcessName         
#  --- -----------         
# 6160 ApplicationFrameHost
```

## Pipelines <a name="pipelines"></a>
Pipelines are not only there to process the output of the foregoing cmdlet it also changes the way the output is forwarded to subsequent cmdlet. 
If for example ```Get-Proces | Select-Object -property Name``` the select-object is executed foreach process object. 

## Begin / Process / End <a name="FunctionWorkflow"></a>
These blocks are the definition on how code is run.
They are really only needed if working with pipelines.  
<b>Begin:</b> Code stored in the begin block is executed before anything. It is used to initialize variables etc. 
<b>Process:</b> In the primary block code is executed n-times. Which comes in handy if you have a function that is called by a pipeline that streams an array and hence needs this part to be executed foreach element. 
<b>End:</b> The end block is run at the total end of code execution. Which means that it the execution has 4 Cmdlets in pipelines the end part is only then executed when the last cmdlet is done. 

```powershell
function Get-Something { 
    param 
    (
        [String] 
        [Parameter(
            Mandatory = $true, 
            Position = 0, 
            ValueFromPipeline = $true, 
            ValueFromPipelineByPropertyName = $true)] 
        $name 
    ) 

    begin 
    { 

        # runs before parameter allocation etc.  
        Write-Output "Hi $name"  
        # prints blank, because it runs before 
    } 

    process 
    { 
        # runs for all elements of array  
        Write-Output "Hi $name" 
        # prints each name  
    } 

    end 
    { 
        # return last element of array only  
        Write-Output "Hi $name" 
        # prints only last element in array  
    }   
}
```

## Advanced Functions <a name="advFunctions"></a>
An advanced function is a function that has "advanced" options enabled like ```-verbose```. 
These are made possible through the wishlist ```[CmdletBinding()]``` 
It is only then needed if the function actually allows for any of the features. 
So you actually have to create verbose output ```Write-Verbose```to make use of ```-verbose```. 

```powershell
# some basic function to show an example
Function Write-Something {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true, Position=0)]
        [String]
        $something
    )
    Write-Output $something
    Write-Verbose "some verbose output"
}

Write-Something -something "hello world"
# prints:
# hello world

Write-Something -something "hello world" -Verbose
# prints:
# hello world
# VERBOSE: some verbose output
```

For other advanced parameters checkout [this](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_functions_advanced_parameters){:target="_blank" rel="noopener"}. 

## Classes <a name="classes"></a>
You can use the commonly known classes in powershell to construct objects but you will lose on performance. 
If you want to use classes you should also refactor your powershell code to reflect the object-oriented way of programming. 

## Powershell LifeCycle <a name="PoShLifeCycle"></a>
The powershell workflow coud be defined as flollows: 

![PoShLifeCycle](https://raw.githubusercontent.com/yehlo/PoShExpert/master/assets/images/PoSh_LifeCycle.png)

From powershell 5 onwards or just with the module ```PowershellGet``` you can make use of powershell repositories, which allows for a centralized access point for different modules: 
```powershell
# register the new repository to the user
Register-PSRepository -Name RepoName -SourceLocation \\some\share -InstallationPolicy Trusted
# publish the newly finished module to the repository
publish-module -name ModuleName -repository RepoName
# find the module on the repository
Find-Module -repository RepoName -name ModuleName
# Update the module
Update-Module -name ModuleName 
# remove module from repository
# actually only possible throught deletion of the module file on the share
```

## Non-Terminating Errors <a name="errorhandlig"></a>
There are errors that are actually uncatchable if the cmdlet is not specifically told to have ```-ErrorAction Stop```. 
This is because some of the error types are listed as non-terminating error and these are not catched if the errorAction stop is not specified. 
Without having to call ```-ErrorAction stop``` on every command you can make use of the global variable ```$ErrorActionPreference```. 

### ErrorVariable
Another way of working around non-terminating errors is to silence the errors on the command and write all errors out a variable. 
```powershell
# this overwrites the errors variable with every new error
Get-Childitem C:\ -Recurse -ErrorAction SilentlyContinue -ErrorVariable errors
# this appends the variable errors with all errors
Get-Childitem C:\ -Recurse -ErrorAction SilentlyContinue -ErrorVariable +errors
```
