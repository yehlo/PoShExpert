

$hash = @{
  6 = 'Verboten'
  12 = 'OK'
  1000 = 'tausend'
  123312 = 'superhoch'
}


function Test
{
  6,12,1000,123312  | Get-Random
}

$rv = test
$hash[$rv]