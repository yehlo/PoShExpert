


function test
{
  param
  (
    $Name
  )

  "Hallo $Name!"
}


$source = (Get-Command -Name test).ScriptBlock



New-Item -Path function:MyTest2 -Value $source -Options AllScope, Constant

