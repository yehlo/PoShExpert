$Text = 'Feueralarm!'
$Delay = 8

$label = [System.Windows.Controls.Label]::new()
$label.Content = $Text
$label.FontSize = 50
$label.FontFamily = 'Stencil'
$label.Foreground = 'Yellow'
$label.HorizontalAlignment = 'Center'
$label.VerticalAlignment = 'Center'


$fenster = [System.Windows.Window]::new()
$fenster.Title = $null
$fenster.Opacity = 0.8
$fenster.AllowsTransparency = $true
$fenster.WindowStyle = 'None'
$fenster.Topmost = $true
$fenster.WindowStartupLocation = 'CenterScreen'

$fenster.Content = $label
$fenster.SizeToContent = 'WidthAndHeight'
$fenster.MinHeight = 300
$fenster.MinWidth = 800
$fenster.Background = 'Green'
$fenster.Show()
Wait-Event -Timeout $Delay
$fenster.Close()