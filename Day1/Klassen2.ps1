
# class
class Person
{
  [string]$Name
  [int]$ID
  [DateTime]$Date

  Person([string]$Name, [int]$Id)
  {
    $this.Name = $Name
    $this.ID = $Id
    $this.Date = Get-Date
  }
  
  Person()
  {
    
  }
  
  Person([string]$Name)
  {
    $this.Name = $Name
  }
}

class Chef : Person
{
  [bool]$Dienstwagen = $true
  

}

[Chef]@{
  Name = 'Tobias'
  ID = 100
  Date = '2019-10-12'
}
