

Get-Service |
 Where-Object Status -eq Running  |
 Out-GridView -Title 'Welcher soll weg?' -OutputMode Single |
 Stop-Service