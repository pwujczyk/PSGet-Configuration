clear
Write-Host "pawel"

#cd $PSScriptRoot
Import-Module D:\GitHub\PSSQLCommands\PSSQLCommands\SQLCommands.psm1 -Force
Import-Module D:\GitHub\PSGet-Configuration\Get-Configuration\Get-Configuration.psm1 -force
#Remove-Item env:PSGetConfiguration

#Set-SqlConfigurationSource -SqlServerInstance ".\sql2017" -SqlServerDatabase "xxx" -SqlServerTable "Configuration"
Set-XmlConfigurationSource "d:\trash\config.xml"

Get-Configuration "Example" -Verbose
Set-Configuration -Key "Examddple2" -Value "Marcin"
