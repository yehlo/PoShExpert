
$code = @'
public class Person2
{
  public string Name;
  public int ID;
  public System.DateTime Date;

  public Person2(string Name, int Id)
  {
    this.Name = Name;
    this.ID = Id;
  }
  
}
'@

$klasse = Add-Type -TypeDefinition $code -PassThru

[Person]::new("Tobias", 12)