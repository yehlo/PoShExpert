$cred = get-credential

$liste = 10, 3,4,9,8,6,1,2 | ForEach-Object { 'CL{0:d2}' -f $_ }
$liste = $liste -ne $env:COMPUTERNAME

Invoke-Command {
    $GetUserName = [Environment]::UserName
    $CmdMessage = {C:\windows\system32\msg.exe * 'Hello'}
    $CmdMessage | Invoke-Expression
} -ThrottleLimit 20 -ComputerName $liste -Credential $cred 