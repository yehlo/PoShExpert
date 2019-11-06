
function Set-PinnedApplication 
{ 
  <#  
      .SYNOPSIS  
      This function are used to pin and unpin programs from the taskbar and Start-menu in Windows 7 and Windows Server 2008 R2 
      .DESCRIPTION  
      The function have to parameteres which are mandatory: 
      Action: PinToTaskbar, PinToStartMenu, UnPinFromTaskbar, UnPinFromStartMenu 
      FilePath: The path to the program to perform the action on 
      .EXAMPLE 
      Set-PinnedApplication -Action PinToTaskbar -FilePath "C:\WINDOWS\system32\notepad.exe" 
      .EXAMPLE 
      Set-PinnedApplication -Action UnPinFromTaskbar -FilePath "C:\WINDOWS\system32\notepad.exe" 
      .EXAMPLE 
      Set-PinnedApplication -Action PinToStartMenu -FilePath "C:\WINDOWS\system32\notepad.exe" 
      .EXAMPLE 
      Set-PinnedApplication -Action UnPinFromStartMenu -FilePath "C:\WINDOWS\system32\notepad.exe" 
  #>  
       [CmdletBinding()] 
       param( 
      [Parameter(Mandatory=$true)][string]$Action,  
      [Parameter(Mandatory=$true)][string]$FilePath 
       ) 
       if(-not (test-path $FilePath)) {  
           throw "FilePath does not exist."   
    } 
    
       function InvokeVerb { 
           param([string]$FilePath,$verb) 
        $verb = $verb.Replace("&","") 
        $path= split-path $FilePath 
        $shell=new-object -com "Shell.Application"  
        $folder=$shell.Namespace($path)    
        $item = $folder.Parsename((split-path $FilePath -leaf)) 
        $itemVerb = $item.Verbs() | ? {$_.Name.Replace("&","") -eq $verb} 
        if($itemVerb -eq $null){ 
            throw "Verb $verb not found."             
        } else { 
            $itemVerb.DoIt() 
        } 
            
       } 
    function GetVerb { 
        param([int]$verbId) 
        try { 
            $t = [type]"CosmosKey.Util.MuiHelper" 
        } catch { 
            $def = [Text.StringBuilder]"" 
            [void]$def.AppendLine('[DllImport("user32.dll")]') 
            [void]$def.AppendLine('public static extern int LoadString(IntPtr h,uint id, System.Text.StringBuilder sb,int maxBuffer);') 
            [void]$def.AppendLine('[DllImport("kernel32.dll")]') 
            [void]$def.AppendLine('public static extern IntPtr LoadLibrary(string s);') 
            add-type -MemberDefinition $def.ToString() -name MuiHelper -namespace CosmosKey.Util             
        } 
        if($script:CosmosKey_Utils_MuiHelper_Shell32 -eq $null){         
            $script:CosmosKey_Utils_MuiHelper_Shell32 = [CosmosKey.Util.MuiHelper]::LoadLibrary("shell32.dll") 
        } 
        $maxVerbLength=255 
        $verbBuilder = new-object Text.StringBuilder "",$maxVerbLength 
        [void][CosmosKey.Util.MuiHelper]::LoadString($CosmosKey_Utils_MuiHelper_Shell32,$verbId,$verbBuilder,$maxVerbLength) 
        return $verbBuilder.ToString() 
    } 
 
    $verbs = @{  
        "PintoStartMenu"=5381 
        "UnpinfromStartMenu"=5382 
        "PintoTaskbar"=5386 
        "UnpinfromTaskbar"=5387 
    } 
        
    if($verbs.$Action -eq $null){ 
           Throw "Action $action not supported`nSupported actions are:`n`tPintoStartMenu`n`tUnpinfromStartMenu`n`tPintoTaskbar`n`tUnpinfromTaskbar" 
    } 
    InvokeVerb -FilePath $FilePath -Verb $(GetVerb -VerbId $verbs.$action) 
} 






#Pin-Path -Path <string> -Target [Start|Taskbar] -Mode [Pin/UnPin]

function Pin-Path
{

  
  [CmdletBinding()]
  param
  (
    [Parameter(Mandatory)]
    [string]
    $Path,
    
    [Parameter(Mandatory)]
    [ValidateSet('Start','Taskbar')]
    [string]
    $Target,
    
    [Parameter(Mandatory)]
    [string]
    [ValidateSet('Pin','Unpin')]
    $Mode
  )

  $Path = (Get-Command -Name $Path).Source

  $ErrorActionpreference = "SilentlyContinue"
  

  
  # ===== Beginn Funktions-Routinen ======================================================================================
  # https://github.com/Disassembler0/Win10-Initial-Setup-Script/issues/8
  # Bring pinning / unpinning handler into '*' class scope
  $pinHandler = Get-ItemPropertyValue -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\Windows.taskbarpin" -Name "ExplorerCommandHandler"
  $null = New-Item -Path "HKCU:\Software\Classes\*\shell\pin" -Force
  Set-ItemProperty -LiteralPath "HKCU:\Software\Classes\*\shell\pin" -Name "ExplorerCommandHandler" -Type String -Value $pinHandler
  
  
     
  $Verbs = @{
    "StartPin" = 'pintostartscreen'
    "StartUnpin" = 'startunpin'
    "TaskbarPin" = 'pin'
    "TaskbarUnpin" = 'taskbarunpin'
  }

  $verb = $Verbs["$Target$Mode"]
  Write-Warning $verb
  if ($Target -eq 'Start')
  {
    $LinkPath = "$env:AppData\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar"
  }
else
{
  $LinkPath = "$env:AppData\Microsoft\Internet Explorer\Quick Launch\User Pinned\StartMenu"
}  

$link = Get-ChildItem -Path $LinkPath -Filter *.lnk | Test-LinkExists | Select-Object -First 1
  

  (New-Object -ComObject Shell.Application).
  NameSpace(0).
  ParseName($Path).
    InvokeVerb($verb) 
  # Remove the handler
  Remove-Item -LiteralPath "HKCU:Software\Classes\*\shell\pin" -Recurse
  
}


function Test-LinkExists
{
  param
  (
    [Parameter(Mandatory, ValueFromPipeline,ValueFromPipelineByPropertyName)]
    [string]
    [Alias('FullName')]
    $Path,
    
    [Parameter(Mandatory)]
    [string]
    $TargetPath
  )

  begin
  {
    $obj = New-Object -ComObject WScript.Shell
  }
  process
  {
    $lnk = $obj.CreateShortcut($Path)
    if ($lnk.TargetPath -eq $TargetPath)
    {
      Get-Item -Path $Path
    }
  }
}