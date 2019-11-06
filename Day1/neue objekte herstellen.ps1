

# Objekte herstellen

# Add-Member 

$obj = New-Object -TypeName PSObject | 
Add-Member -MemberType NoteProperty -Name Name -Value $env:username -PassThru |
Add-Member -MemberType NoteProperty -Name ID -Value $pid -PassThru |
Add-Member -MemberType NoteProperty -Name Date -Value (Get-Date) -PassThru
$obj 

# New-Object
$obj =  New-Object -TypeName PSObject -Property @{
  Name = $env:username
  ID = $pid
  Date = Get-Date
}
$obj

# Bart Simpson'sche Staubsauger:
$obj = 1 | Select-Object -Property Name, ID, Date | ForEach-Object {
  $_.Name = $env:username
  $_.ID = $pid
  $_.Date = Get-Date
  $_
}
$obj


$obj =  [PSCustomObject]@{
  Name = $env:username
  ID = $pid
  Date = Get-Date
}
$obj

# class
class Datensatz
{
  [string]$Name
  [int]$ID
  [DateTime]$Date



}

$neu = [Datensatz]::new()
$neu 

[Datensatz]::new() 


# class
class Datensatz2
{
  [string]$Name
  [int]$ID
  [DateTime]$Date

  Datensatz2([string]$Name, [int]$Id)
  {
    $this.Name = $Name
    $this.ID = $Id
    $this.Date = Get-Date
  }
  
  Datensatz2()
  {
  }

  static [Datensatz2]NewRecord([string]$Name, [int]$Id)
  {
    return [Datensatz2]::new($Name, $Id)
  }
}


[Datensatz2]::new()
[Datensatz2]::new($env:username, $pid)
