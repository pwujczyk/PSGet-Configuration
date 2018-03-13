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
		
		$r=GetSQLValue -SqlInstance $SqlServerInstance -DatabaseName $SqlServerDatabase -TableName $SqlServerTable -Key $Key
        return $r
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
		
		SetSQLValue -SqlInstance $SqlServerInstance -DatabaseName $SqlServerDatabase -TableName $SqlServerTable -Key $Key -Value $Value
	}
}



Export-ModuleMember Get-Configuration
Export-ModuleMember Set-Configuration
Export-ModuleMember Set-SqlConfigurationSource
Export-ModuleMember Set-XmlConfigurationSource