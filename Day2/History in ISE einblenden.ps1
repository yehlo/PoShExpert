

$action = {
    $file = $psise.CurrentPowerShellTab.Files.Add()
    $file.Editor.Text = Get-History | Select-Object -ExpandProperty CommandLine
    $file.Editor.SetCaretPosition(1,1)
}

$psise.CurrentPowerShellTab.AddOnsMenu.Submenus.Add('Befehle auflisten', $action, 'Alt+F11')


