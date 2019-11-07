. .\testing.ps1

describe 'Write-Test'{

    Context 'Running with arguments' {
        $name = 'pester'
        It 'runs without errors' {
            { Write-Test -Name $name } | Should Not Throw
        }
        It 'writes the parameter with hello' {
            Write-Test -Name $name | Should Be "hello $name"
        }
    }
}