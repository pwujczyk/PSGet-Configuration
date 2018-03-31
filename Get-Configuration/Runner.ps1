clear
Write-Host "pawel"
Import-Module D:\GitHub\PSGet-Configuration\Get-Configuration\Get-Configuration.psm1 -Force
#Set-SqlConfigurationSource -SqlServerInstance ".\sql2017" -SqlServerDatabase "testdb" -SqlServerSchema "adm" -SqlServerTable "config" -Verbose
Set-Configuration -Key "ke" -Value v -Verbose
Get-Configuration -Key "ke" -verbose

#cd $PSScriptRoot
Import-Module D:\GitHub\PSSQLCommands\PSSQLCommands\SQLCommands.psm1 -Force
Import-Module D:\GitHub\PSGet-Configuration\Get-Configuration\Get-Configuration.psm1 -force
#Remove-Item env:PSGetConfiguration

#Set-SqlConfigurationSource -SqlServerInstance ".\sql2017" -SqlServerDatabase "xxx" -SqlServerTable "Configuration"
Set-XmlConfigurationSource "d:\trash\config.xml"

Get-Configuration "Example" -Verbose
Set-Configuration -Key "Examddple2" -Value "Marcin"
