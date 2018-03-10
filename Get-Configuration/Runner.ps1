clear
Write-Host "pawel"

#cd $PSScriptRoot
Import-Module D:\GitHub\PSGet-Configuration\Get-Configuration\Get-Configuration.psm1 -force
Remove-Item env:PSGetConfiguration

Set-SqlConfigurationSource -SqlServerInstance ".\sql2017" -SqlServerDatabase "xxx" -SqlServerTable "pawel"

Get-ConfigValue "Example"
