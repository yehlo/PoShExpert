function Test-Admin
{
	$wid = [System.Security.Principal.WindowsIdentity]::GetCurrent()
	$prp = New-Object System.Security.Principal.WindowsPrincipal($wid)
	$adm = [System.Security.Principal.WindowsBuiltInRole]::Administrator
	$prp.IsInRole($adm)  
}

Describe 'Prerequisites' {

	Context 'PS Configuration ok'   {
		It 'uses current PS Version' {
			$host.Version.Major | Should Be 5
			$host.Version.Minor | Should Be 1
		}
		It 'enables script execution' {
			Get-ExecutionPolicy | Should not be 'Restricted'
			Get-ExecutionPolicy | Should not be 'AllSigned'
			Get-ExecutionPolicy | Should not be 'Restricted'
		}
		It 'has PowerShellGet installed' {
			Get-Module PowerShellGet | Should not be $null
		}
	}
	Context 'Remoting Config ok'   {
		It 'runs WinRM Service' {
			Get-Service WinRM | Select-Object -ExpandProperty Status | Should be 'Running'
		}
    
	}
	Context 'Admin Privileges'   {
		It 'runs with full Admin privileges' {
			Test-Admin | Should be $true
		}
    
	}
}
