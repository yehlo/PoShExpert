Get-WindowsOptionalFeature -FeatureName *PowerShell* -Online
Disable-WindowsOptionalFeature -FeatureName MicrosoftWindowsPowerShellV2, MicrosoftWindowsPowerShellV2Root -Online -NoRestart
