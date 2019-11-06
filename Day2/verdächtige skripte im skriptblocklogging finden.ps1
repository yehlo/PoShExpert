Get-SBLEvent | 
  Where-Object { $_.Name -notmatch '(\[from memory\]|\.ps1|\.psd1|\.psm1)$' } |
  ogv