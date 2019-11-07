
. ($PSCommandPath -replace '\.tests\.ps1$', '.ps1')

Describe 'Get-Name' {

  Context 'Running without arguments'   {
    It 'runs without errors' {
      { Get-Name } | Should Not Throw
    }
    It 'does something' {
    }
    It 'returns "Hello World"'     {
      Get-Name | Should Be 'Hello World'
    }
  }
  Context 'Running with argument -Name Tobias'   {
    It 'runs without errors' {
      { Get-Name -Name test } | Should Not Throw
    }
    
    It 'returns "Hello World Tobias'     {
      Get-Name -Name Tobias | Should Be 'Hello World Tobias'
    }
  }
}
