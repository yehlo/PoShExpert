$label = [System.Windows.Controls.Label]::new()
$label.Content = 'Guten Tag!'
$label.FontSize = 50
$label.FontFamily = 'Stencil'
$label.Foreground = 'Yellow'
$label.HorizontalAlignment = 'Center'
$label.VerticalAlignment = 'Center'


$fenster = [System.Windows.Window]::new()
$fenster.Title = 'Warnung'
$fenster.Content = $label
$fenster.SizeToContent = 'WidthAndHeight'
$fenster.MinHeight = 300
$fenster.MinWidth = 800
$fenster.Background = 'Green'
$fenster.ShowDialog()

