. ($PSScriptRoot + "\Managers\Core.ps1")
. ($PSScriptRoot + "\Managers\XmlManager.ps1")
. ($PSScriptRoot + "\Managers\SqlManager.ps1")



function GetModuleConfigurationJson()
{
	if ($(Test-Path env:PSGetConfiguration) -eq $false)
	{
		SetDefaultXmlConfiguration
	}
	
	$configurationString=GetEnvConfiguration
	return $configurationString
}

function GetModuleConfigurationObject()
{
	$configurationJson=GetModuleConfigurationJson
	$configuration=ConvertFrom-Json $configurationJson
	return $configuration
}

function Get-Configuration()
{
	[cmdletbinding()]
	param ([string]$Key, [switch]$All)
		
	$configuration=GetModuleConfigurationObject
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
		
       	return $r
	}
}

function Set-Configuration()
{
	[cmdletbinding()]
	param ([string]$Key,[string]$Value,[string]$category)
		
	$configuration=GetModuleConfigurationObject
	Write-Verbose $configuration
	if ($configuration.Mode -eq 'Xml')
	{
		$path=$configuration.XmlPath 
		$r=SetXmlValue $path $Key $Value $category
	}

    if ($configuration.Mode -eq 'SQL')
	{
       	$SqlServerInstance=$configuration.SqlServerInstance
       	$SqlServerDatabase=$configuration.SqlServerDatabase
        $SqlServerTable=$configuration.SqlServerTable
		$SqlServerSchema=$configuration.SqlServerSchema
		
		SetSQLValue -SqlInstance $SqlServerInstance -DatabaseName $SqlServerDatabase -SchemaName $SqlServerSchema -TableName $SqlServerTable -Key $Key -Value $Value -Category $category
	}
}

function Get-ConfigurationSource()
{
	$config=GetConfiguration
	return $config
}

function ClearConfigurationByKey()
{
	[cmdletbinding()]
	param ([string]$Key)
	
	$configuration=GetModuleConfigurationObject
	Write-Verbose $configuration
	if ($configuration.Mode -eq 'Xml')
	{
		$path=$configuration.XmlPath 
		ClearConfigurationByKeyXml $path $Key
	}

    if ($configuration.Mode -eq 'SQL')
	{
		$SqlServerInstance=$configuration.SqlServerInstance
       	$SqlServerDatabase=$configuration.SqlServerDatabase
        $SqlServerTable=$configuration.SqlServerTable
		$SqlServerSchema=$configuration.SqlServerSchema
		ClearConfigurationByKeySQL -SqlInstance $SqlServerInstance -DatabaseName $SqlServerDatabase -SchemaName $SqlServerSchema -TableName $SqlServerTable -Key $Key
	}
}

function ClearConfigurationByCategory()
{
	[cmdletbinding()]
	param ([string]$Category)
	
	$configuration=GetModuleConfigurationObject
	Write-Verbose $configuration
	if ($configuration.Mode -eq 'Xml')
	{
		$path=$configuration.XmlPath 
		ClearConfigurationByCategoryXml $path $Category
	}

    if ($configuration.Mode -eq 'SQL')
	{
		$SqlServerInstance=$configuration.SqlServerInstance
       	$SqlServerDatabase=$configuration.SqlServerDatabase
        $SqlServerTable=$configuration.SqlServerTable
		$SqlServerSchema=$configuration.SqlServerSchema

		ClearConfigurationByCategorySQL -SqlInstance $SqlServerInstance -DatabaseName $SqlServerDatabase -SchemaName $SqlServerSchema -TableName $SqlServerTable -Category $category
	}
}

function Clear-Configuration()
{
	[cmdletbinding()]
	param ([string]$Key,[string]$Category)
	
	if($Key -ne $null -and $Key -ne "")
	{
		ClearConfigurationByKey $Key
	}
	
	if ($Category -ne $null -and $Category -ne "")
	{
		ClearConfigurationByCategory $Category
	}
}

function Get-ConfigurationSource()
{
	$json=GetModuleConfigurationObject
	return $json
}

function Get-ConfigurationSourceJson()
{
	$json=GetModuleConfigurationJson
	return $json
}

Export-ModuleMember Get-Configuration
Export-ModuleMember Set-Configuration
Export-ModuleMember Set-ConfigurationSqlSource
Export-ModuleMember Set-ConfigurationXmlSource
Export-ModuleMember Get-ConfigurationSource
Export-ModuleMember Get-ConfigurationSourceJson
Export-ModuleMember Clear-Configuration
