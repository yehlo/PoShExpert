


$p= {  Out-GridView -Title 'Meine Ausgabe' }.GetSteppablePipeline()

$p.Begin($true)
$p.Process("Hallo Test")
$p.End()

