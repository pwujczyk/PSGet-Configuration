. ($PSScriptRoot + "\XmlManager.ps1").


function GetScriptPath()
{
	$path=$PSScriptRoot
	return $path
}

#function BaseConfiguration()
#{
#	$Object = New-Object PSObject                                       
#    $Object | add-member Noteproperty Mode       "Xml"                 
#    $Object | add-member Noteproperty XmlPath   "$(GetFullDefaultconfiguration)"
##	$conf=ConvertTo-Json -InputObject $Object
#	return $conf
#}



function GetFullDefaultconfiguration()
{
	$dir =Join-Path $(GetScriptPath) $(GetFileName)
	return $dir
}

function SetConfiguration([string]$configuration)
{    
    $env:PSGetConfiguration=$configuration
}

function GetConfiguration()
{
	if ($(Test-Path env:PSGetConfiguration) -eq $false)
	{
        Set-FileConfigurationSource $(GetFullDefaultconfiguration)
		#$baseConfiguration=BaseConfiguration
        #SetConfiguration $baseConfiguration
		
	}
	
	$configurationString=Get-ChildItem env:PSGetConfiguration
	$configuration=ConvertFrom-Json $configurationString.Value
	return $configuration
}

function Get-ConfigValue()
{
	[cmdletbinding()]
	param ([string]$Key)
		
	$configuration=GetConfiguration
	if ($configuration.Mode -eq 'Xml')
	{
		Write-Host "FileConfiguraton"
		$path=$configuration.XmlPath 
		$r=GetXMLValue $path $Key
        return $r
	}

    if ($configuration.Mode -eq 'SQL')
	{
		Write-Verbose "SQL Configuration"
        $SqlServerInstance=$configuration.SqlServerInstance
        $SqlServerDatabase=$configuration.SqlServerDatabase
        $SqlServerTable=$configuration.SqlServerTable
		
		$r=GetSQLValue -SqlInstance $SqlServerInstance -DatabaseName $SqlServerDatabase -TableName $SqlServerTable
        return $r
	}
}

function Set-SqlConfigurationSource()
{
    [cmdletbinding()]
	param ([string]$SqlServerInstance,[string]$SqlServerDatabase,[string]$SqlServerTable)


	$Object = New-Object PSObject                                       
    $Object | add-member Noteproperty Mode       "SQL"                 
    $Object | add-member Noteproperty SqlServerInstance   "$SqlServerInstance"
    $Object | add-member Noteproperty SqlServerDatabase   "$SqlServerDatabase"
    $Object | add-member Noteproperty SqlServerTable      "$SqlServerTable"
	$conf=ConvertTo-Json -InputObject $Object
	
    SetConfiguration $conf
    
}

function Set-FileConfigurationSource()
{
    [cmdletbinding()]
	param ([string]$ConfigurationPath,[string]$SqlServerDatabase)

	$Object = New-Object PSObject                                       
    $Object | add-member Noteproperty Mode       "Xml"                 
    $Object | add-member Noteproperty XmlPath   "$ConfigurationPath"
	$conf=ConvertTo-Json -InputObject $Object
	SetConfiguration $conf
}

function Get-XmlValue()
{
	[cmdletbinding()]
	param ([string]$Key,[string]$Path)
	
	GetXmlValue $Key $Path
	
}

function GetSQLValue()
{
    [cmdletbinding()]
	param ([string]$SqlInstance,[string]$DatabaseName,[string]$TableName)

    $query="SELECT [Value] FROM $TableName WHERE [Key]='$key'"
   	$result=Invoke-SQLQuery -SqlInstance $SqlInstance -DatabaseName $DatabaseName -Query $query	-Verbose:$VerbosePreference
}

Export-ModuleMember Get-ConfigValue
Export-ModuleMember Set-SqlConfigurationSource
Export-ModuleMember Set-FileConfigurationSource