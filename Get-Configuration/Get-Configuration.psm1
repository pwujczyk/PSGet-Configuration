. ($PSScriptRoot + "\Managers\Core.ps1")
. ($PSScriptRoot + "\Managers\XmlManager.ps1")
. ($PSScriptRoot + "\Managers\SqlManager.ps1")



function GetConfiguration()
{
	if ($(Test-Path env:PSGetConfiguration) -eq $false)
	{
		SetDefaultXmlConfiguration
	}
	
	$configurationString=Get-ChildItem env:PSGetConfiguration
	$configuration=ConvertFrom-Json $configurationString.Value
	return $configuration
}

function Get-Configuration()
{
	[cmdletbinding()]
	param ([string]$Key)
		
	$configuration=GetConfiguration
	Write-Verbose $configuration
	if ($configuration.Mode -eq 'Xml')
	{
		$path=$configuration.XmlPath 
		$r=GetXmlValue $path $Key
        return $r
	}

    if ($configuration.Mode -eq 'SQL')
	{
        	$SqlServerInstance=$configuration.SqlServerInstance
        	$SqlServerDatabase=$configuration.SqlServerDatabase
        	$SqlServerTable=$configuration.SqlServerTable
		$SqlServerSchema=$configuration.SqlServerSchema
		
		$r=GetSQLValue -SqlInstance $SqlServerInstance -DatabaseName $SqlServerDatabase  $SqlServerSchema -TableName $SqlServerTable -Key $Key
		$value=$r.Value
        	return $value
	}
}

function Set-Configuration()
{
	[cmdletbinding()]
	param ([string]$Key,[string]$Value)
		
	$configuration=GetConfiguration
	Write-Verbose $configuration
	if ($configuration.Mode -eq 'Xml')
	{
		$path=$configuration.XmlPath 
		$r=SetXmlValue $path $Key $Value
	}

    if ($configuration.Mode -eq 'SQL')
	{
        	$SqlServerInstance=$configuration.SqlServerInstance
        	$SqlServerDatabase=$configuration.SqlServerDatabase
        	$SqlServerTable=$configuration.SqlServerTable
		$SqlServerSchema=$configuration.SqlServerSchema
		
		SetSQLValue -SqlInstance $SqlServerInstance -DatabaseName $SqlServerDatabase -SchemaName $SqlServerSchema -TableName $SqlServerTable -Key $Key -Value $Value
	}
}

function Get-ConfigurationSource()
{
	$config=GetConfiguration
	return $config
}

Export-ModuleMember Get-Configuration
Export-ModuleMember Set-Configuration
Export-ModuleMember Set-SqlConfigurationSource
Export-ModuleMember Set-XmlConfigurationSource
Export-ModuleMember Get-ConfigurationSource