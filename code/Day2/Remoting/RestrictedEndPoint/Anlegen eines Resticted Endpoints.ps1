#requires -runasadmin

$msg = 'Geben Sie das Konto an, unter dem dieser Endpunkt ausgeführt werden soll!'
$Credential = Get-Credential -UserName "Administrator" -Message $msg


$Path = "$env:temp\session1.pssc"
$EndpointName = 'ElevatedUsers'



$getUserInfo = @{
  Name='Get-UserInfo'
  ScriptBlock=
  {
    $PSSenderInfo
  }
}

$getUserInfo2 = @{
  Name='Get-UserInfo2'
  ScriptBlock=
  {
    $env:username
  }
}




$test1 = @{
  Name='Test-AdminAccess'
  ScriptBlock=
  {
     Get-Date | Set-Content "$env:windir\Iwashere.txt"
  }
}


# Datei anlegen
New-PSSessionConfigurationFile -Path $Path -SessionType RestrictedRemoteServer -LanguageMode NoLanguage -ExecutionPolicy Restricted -FunctionDefinitions $getUserInfo, $getUserInfo2, $test1 -VisibleCmdlets get-help #-VisibleProviders FileSystem
# Endpunkt anlegen:
# ACHTUNG: Win10-Security-Baseline erlaubt nicht das Speichern von Credentials
# "WinRM nicht gestatten, 'RunAs'-Anmeldeinformationen zu speichern"
Register-PSSessionConfiguration -Name $EndpointName -Path $Path -RunAsCredential $Credential -ShowSecurityDescriptorUI -Force