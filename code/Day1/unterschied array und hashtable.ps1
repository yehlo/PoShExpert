﻿
# Hashtable
# Mavigation über selbstgewählten Keys

$a =@{
  Name = 'test'
  id = 12
}

# Array
# navigation über zahlen, start immer bei 0, negativ = rückwärts
$b = @(
  1,
  2,
  10,
  "Hallo"
)

$a.Count
$b.Count


$a['Name']
$b[0]