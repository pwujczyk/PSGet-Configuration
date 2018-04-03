. ($PSScriptRoot + "\Managers\Core.ps1")
. ($PSScriptRoot + "\Managers\XmlManager.ps1")
. ($PSScriptRoot + "\Managers\SqlManager.ps1")



function GetModuleConfigurationJson()
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
		
	$configuration=GetModuleConfigurationJson
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
	param ([string]$Key,[string]$Value,[string]$category)
		
	$configuration=GetModuleConfigurationJson
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
	
	$configuration=GetModuleConfigurationJson
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
	
	$configuration=GetModuleConfigurationJson
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

Export-ModuleMember Get-Configuration
Export-ModuleMember Set-Configuration
Export-ModuleMember Set-SqlConfigurationSource
Export-ModuleMember Set-XmlConfigurationSource
Export-ModuleMember Get-ConfigurationSource
Export-ModuleMember Clear-Configuration