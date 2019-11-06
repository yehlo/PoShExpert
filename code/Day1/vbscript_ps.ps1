


#Set Shell = CreateObject("WScript.Shell")
$shell = New-Object -ComObject WScript.Shell

$link = $Shell.CreateShortcut("$home\desktop\test.lnk")
$link.Arguments = "1 2 3"
$link.Description = "test shortcut"
$link.HotKey = "CTRL+ALT+SHIFT+X"
$link.IconLocation = "C:\Windows\WinSxS\amd64_microsoft-windows-ie-internetexplorer_31bf3856ad364e35_11.0.17763.1_none_541964c6dd01ca9c\bing.ico"
$link.TargetPath = "notepad"
$link.WindowStyle = 9
$link.WorkingDirectory = "c:\"
$link.Save()