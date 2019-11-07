

$text = 'PC678 had a problem'
$pattern = 'PC(\d{3})'if ($text -match $pattern){  $matches[1]}else{  'nicht gefunden.'}