function New-RSLink
{
  <#
      .SYNOPSIS
      Creates a Shortcut File
    
      .EXAMPLE
      New-RSLink -Path "$home\desktop\klickme.lnk" -TargetPath notepad 
      creates a new link on the desktop which launches notepad
  #>
  [CmdletBinding()]
  param
  (
    [Parameter(Mandatory=$true, HelpMessage='Path to executable', ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [String]
    [Alias('FullName')]
    $TargetPath,
    
    
    [Parameter(Mandatory)]
    [System.String]
    $OutFolder,
    
    [System.String]
    $Arguments = $null,
    
    [System.String]
    $Description = $null,
    
    [Parameter(Mandatory=$false, Position=6)]
    [System.String]
    $WorkingDirectory = 'C:\',
    
    [Switch]
    $Open
  )
  
  
  begin
  {
    $shell = New-Object -ComObject WScript.Shell
    $exists = Test-Path -Path $OutFolder
    if (!$exists)
    {
      $null = New-Item -Path $OutFolder -ItemType Directory
    }
  }
  
  process
  {
    $FileName = '{0}.lnk' -f [System.IO.Path]::GetFileNameWithoutExtension($_.Name)
    $Path = Join-Path -Path $OutFolder -ChildPath $FileName
    $link = $Shell.CreateShortcut($Path)
    $link.Arguments = $Arguments
    $link.Description = $Description
    
  
    $link.TargetPath = $TargetPath
    $link.WindowStyle = 9
    $link.WorkingDirectory = $WorkingDirectory
    $link.Save()
  }
  
  end
  {
     if ($Open)
     {
      explorer $OutFolder
     }
  }
}


dir c:\windows -Recurse -Filter *.exe -ErrorAction SilentlyContinue |
  Sort-Object -Property Name -Unique |
  New-RSLink -OutFolder c:\links -Open
  