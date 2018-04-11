clear
Write-Host "pawel"
Import-Module D:\GitHub\PSGet-Configuration\Get-Configuration\Get-Configuration.psm1 -Force
#Set-ConfigurationSqlSource -SqlServerInstance ".\sql2017" -SqlServerDatabase "testdb" -SqlServerSchema "adm" -SqlServerTable "config" -Verbose
Set-Configuration -Key "ke" -Value v -Verbose
Set-Configuration -key "pawel0" -value "pawel0" -Category "c1"
Set-Configuration -key "pawel1" -value "pawel1" -Category "c1"
Set-Configuration -key "pawel2" -value "pawel2" -Category "c1"
Get-Configuration 
Clear-Configuration -Key pawel0

#cd $PSScriptRoot
Import-Module D:\GitHub\PSSQLCommands\PSSQLCommands\SQLCommands.psm1 -Force
Import-Module D:\GitHub\PSGet-Configuration\Get-Configuration\Get-Configuration.psm1 -force
#Remove-Item env:PSGetConfiguration

#Set-ConfigurationSqlSource -SqlServerInstance ".\sql2017" -SqlServerDatabase "xxx" -SqlServerTable "Configuration"
Set-ConfigurationXmlSource "d:\trash\config.xml"

Get-Configuration "Example" -Verbose
Set-Configuration -Key "Examddple2" -Value "Marcin"
