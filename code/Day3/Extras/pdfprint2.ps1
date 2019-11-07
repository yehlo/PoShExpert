function Out-PDF($Path ="$home\Desktop\result.pdf", [Switch]$Show, $Timeout = 5)
{
  # validate output path:
  if ($Path -notlike '*.pdf')
  {
    throw 'Out-PDF: You must specify a path to a PDF file.'
  }

  $parent = Split-Path -Path $Path
  $exists = Test-Path -Path $parent -PathType Container
  
  if (!$exists)
  {
    throw "Out-PDF: Parent folder missing: $parent"
  }
    
  try
  {
    $null = New-Item -Path $path -ItemType File -Force -ErrorAction Stop
    Remove-Item -Path $path
  }
  catch
  {
    throw "Out-PDF: $_ Choose a different output path and check permissions."
  }
  # original printer driver to be used:
  $PrinterDefaultName = 'Microsoft Print to PDF'
  # create a temporary printer
  $printerName = (New-Guid).Guid
  
  # there is a chance that the port may already exist (if someone else happened to use it to print to the file specified)
  Add-PrinterPort -Name $Path -ErrorAction SilentlyContinue
  # printer is always unique because it is "ours", and we are deleting it:
  Add-Printer -DriverName $PrinterDefaultName -Name $printerName -PortName $Path 

  # send pipeline input to printer
  $input | Out-Printer -Name $printerName

  # remove printer and port once not in use anymore
  # wait a max of 10 sec
  $start = Get-Date
  
  do
  {    
    # if the output file exists AND if the file is no longer locked, we are good
    $exists = Test-Path -Path $Path
    if ($exists)
    {
      $file = Get-Item -Path $Path
      try
      {
        $oStream = $file.Open('Open','ReadWrite','None')
        $oStream.Close() 
        $oStream.Dispose()
        
        # remove printer and port
        Remove-Printer -Name $printerName 
        Remove-PrinterPort -Name $Path -ErrorAction SilentlyContinue
        
        # exit loop
        break 
      }
      catch
      { 
        # wait a bit, and try again
        Start-Sleep -Milliseconds 200
      }
    }
    
    $tooLong = ((Get-Date) - $start).TotalSeconds -gt $Timeout
    if ($tooLong) 
    { 
      # remove printer and port
      Remove-Printer -Name $printerName 
      Remove-PrinterPort -Name $Path -ErrorAction SilentlyContinue
      
      throw "Timeout. Printing took more than $Timeout seconds." 
    }
  } while ($true)
    
  # return file
  $file    
  
  # open file if specified:
  if ($Show) { Invoke-Item -Path $Path }
}   


return
Get-Service | Out-PDF -Show