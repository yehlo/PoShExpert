[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") 

$window = [System.Windows.Window]::new()
$window.Title = 'Info'
$window.Content = 'Hello World'
$window.SizeToContent = 'WidthAndHeight'
$window.MinHeight = 300
$window.MinWidth = 800
$window.ShowDialog()