[CmdletBinding()]
param (
    [Parameter(Mandatory)]
    [ValidateScript( {Test-Path -Path $_})]
    [string]
    $TemplatePath
)
$JsonFiles = Get-ChildItem -Path $TemplatePath -Filter *.json | Where-Object {$_.Name -notlike "*.parameters.json"}


Describe "Security check" {
    $JsonFiles.foreach{
        Context "Verify password parameters in $($_.Name)" {
            $template = $_ | Get-Content | ConvertFrom-Json
            $PasswordParams = $template.parameters.PSObject.Members.where{$_.Name -like '*password*'}
            foreach ($param in $PasswordParams) {
                It "Password parameters should be SecureString" {
                    $param.value.type | Should -Be 'SecureString'
                }
            }
        }
    }
}