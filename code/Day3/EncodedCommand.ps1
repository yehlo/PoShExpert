$code = {
  $sapi = New-Object -ComObject Sapi.SpVoice
      $sapi.Rate = 0
      $sapi.Speak("I just hacked you dude.")

}

$bytes = [System.Text.Encoding]::Unicode.GetBytes($Code)
$encodedCommand = [Convert]::ToBase64String($bytes)
$encodedCommand | Set-Clipboard

powershell -noprofile -encodedcommand $encodedCommand