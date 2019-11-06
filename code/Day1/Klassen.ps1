
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



[Datensatz2]@{
  Name = 'Tobias'
  ID = 100
  Date = '2019-10-12'
}
return

Get-process | ForEach-Object {

  [Datensatz2]::new($_.Name, $pid)

}