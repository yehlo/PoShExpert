# hier geht es los
function Invoke-Comment
{
    $file = $psise.CurrentFile                              
    $kommentar = ($file.Editor.SelectedText -split '\n' | ForEach-Object { "#$_" }) -join "`n"                                                 
    $file.Editor.InsertText($kommentar)                     
}

$psise.CurrentPowerShellTab.AddOnsMenu.Submenus.Add('Comment Out', { Invoke-Comment }, 'CTRL+K')#

