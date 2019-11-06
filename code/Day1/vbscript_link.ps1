


Set Shell = CreateObject("WScript.Shell")
DesktopPath = Shell.SpecialFolders("Desktop")
Set link = Shell.CreateShortcut(DesktopPath & "\test.lnk")
link.Arguments = "1 2 3"
link.Description = "test shortcut"
link.HotKey = "CTRL+ALT+SHIFT+X"
link.IconLocation = "app.exe,1"
link.TargetPath = "c:\blah\app.exe"
link.WindowStyle = 3
link.WorkingDirectory = "c:\blah"
link.Save