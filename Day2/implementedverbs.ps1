

Get-ChildItem -Path Registry::HKEY_CLASSES_ROOT -Recurse -ErrorAction SilentlyContinue |
  Where-Object { $_.Property -contains 'ImplementsVerbs' } |
  ForEach-Object {
    [PSCustomObject]@{
      Path = (Convert-Path -LiteralPath $_.PSPath)
      Verbs = $_.GetValue('ImplementsVerbs')
    }
  }