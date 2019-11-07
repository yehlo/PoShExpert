#region XAML window definition
# Right-click XAML and choose WPF/Edit... to edit WPF Design
# in your favorite WPF editing tool
$xaml = @'
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Width="400"
        MinWidth="200"
        SizeToContent="Height"
        Title="Service Stopper"
        Topmost="True">
  <Grid Margin="10,40,10,10">
    <Grid.ColumnDefinitions>
      <ColumnDefinition Width="Auto" />
      <ColumnDefinition Width="0.433560371517028*" />
      <ColumnDefinition Width="0.566439628482972*" />
    </Grid.ColumnDefinitions>
    <Grid.RowDefinitions>
      <RowDefinition Height="Auto" />
      <RowDefinition Height="Auto" />
      <RowDefinition Height="0.233333333333333*" />
      <RowDefinition Height="0.23030303030303*" />
      <RowDefinition Height="0.193939393939394*" />
      <RowDefinition Height="0.342424242424243*" />
    </Grid.RowDefinitions>
    <TextBlock Margin="10" Grid.Column="1">
      Dienst aussuchen:
    </TextBlock>
    <TextBlock Margin="5" Grid.Column="0" Grid.Row="1">
      Service
    </TextBlock>
    <ComboBox Name="ComboService"
              Margin="5"
              Grid.Column="1"
              Grid.Row="1" />
    <StackPanel Margin="0,0,98,32"
                HorizontalAlignment="Right"
                VerticalAlignment="Bottom"
                Orientation="Horizontal"
                Grid.Column="1"
                Grid.ColumnSpan="2"
                Grid.Row="5">
      <Button Name="ButOk" Height="22" Margin="5" MinWidth="80">
        Stop Service
      </Button>
      <Button Name="ButCancel" Height="22" Margin="5" MinWidth="80">
        Cancel
      </Button>
    </StackPanel>
    <Calendar Name="Calendar1"
              Height="168"
              Margin="98,42,46,0"
              HorizontalAlignment="Stretch"
              VerticalAlignment="Top"
              Grid.Column="1"
              Grid.ColumnSpan="2"
              Grid.Row="2"
              Grid.RowSpan="3" />
  </Grid>
</Window>
'@

function Convert-XAMLtoWindow
{
    param
    (
        [Parameter(Mandatory=$true)]
        [string]
        $XAML
    )
  
    Add-Type -AssemblyName PresentationFramework
  
    $reader = [XML.XMLReader]::Create([IO.StringReader]$XAML)
    $result = [Windows.Markup.XAMLReader]::Load($reader)
    $reader.Close()
    $reader = [XML.XMLReader]::Create([IO.StringReader]$XAML)
    while ($reader.Read())
    {
        $name=$reader.GetAttribute('Name')
        if (!$name) { $name=$reader.GetAttribute('x:Name') }
        if($name)
        {$result | Add-Member NoteProperty -Name $name -Value $result.FindName($name) -Force}
    }
    $reader.Close()
    $result
}


function Show-WPFWindow
{
    param
    (
        [Parameter(Mandatory=$true)]
        [Windows.Window]
        $Window
    )

    $result = $null
    $null = $window.Dispatcher.InvokeAsync{
        $result = $window.ShowDialog()
        Set-Variable -Name result -Value $result -Scope 1
    }.Wait()
    $result
}

$window = Convert-XAMLtoWindow -XAML $xaml 

# add click handlers
$window.ButOk.add_Click{
    # when clicked, take the selected item from the combo box and stop the service
    # using -whatif to just simulate for now
    # TODO: Remove -whatif in next line to actually stop a service
    $window.ComboService.SelectedItem | Stop-Service -WhatIf
    # update the combo box (if we really stopped a service, the list would now be shorter)
    $window.ComboService.ItemsSource = Get-Service | Where-Object Status -eq Running | Sort-Object -Property DisplayName
    $window.ComboService.SelectedIndex = 0
}

$window.ButCancel.add_Click{
    # close window
    $window.DialogResult = $false
}
$window.ButOk.add_MouseEnter{
    # remove param() block if access to event information is not required
    param
    (
        [Parameter(Mandatory)][Object]$sender,
        [Parameter(Mandatory)][Windows.Input.MouseEventArgs]$e
    )
  
    [Console]::Beep()
}


# fill the combobox with some powershell objects
$window.ComboService.ItemsSource = Get-Service | Where-Object Status -eq Running | Sort-Object -Property DisplayName
# tell the combobox to use the property "DisplayName" to display the object in its list
$window.ComboService.DisplayMemberPath = 'DisplayName'
# tell the combobox to preselect the first element
$window.ComboService.SelectedIndex = 0

Show-WPFWindow -Window $window
#endregion