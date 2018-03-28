. ($PSScriptRoot + "\Core.ps1")


function GetFileName()
{
	return "PSGetConfiguration.xml"
}

function GetScriptPath()
{
	$path=$PSScriptRoot
	return $path
}

function GetDefaultConfigurationPath()
{
	$dir =Join-Path $(GetScriptPath) $(GetFileName)
	return $dir
}

function Set-XmlConfigurationSource()
{
    [cmdletbinding()]
	param ([string]$ConfigurationPath)

	if ( (Get-Item $ConfigurationPath) -is [System.IO.DirectoryInfo])
	{
		$ConfigurationPath=$ConfigurationPath+ $(GetFileName)
	}

	$Object = New-Object PSObject                                       
    $Object | add-member Noteproperty Mode       "Xml"                 
    $Object | add-member Noteproperty XmlPath   "$ConfigurationPath"
	$conf=ConvertTo-Json -InputObject $Object
	SetConfiguration $conf

	if ( $(Test-Path $ConfigurationPath) -eq $false)
	{
		CreateFile $ConfigurationPath
	}
}

function SetDefaultXmlConfiguration()
{
	 Set-XmlConfigurationSource $(GetDefaultConfigurationPath)	
}

function GetXMLValue([string]$configPath, [string]$key)
{
	$result=Get-XmlConfiguration $configPath $key
    return $result
}
function Get-XmlConfiguration([string] $configPath, [string] $key)
{
	if ($configPath -ne "")
	{
		Write-Verbose $configPath
		[xml]$file =Get-Content -Path $configPath
		#Write-host $userfile
		$x=$file.SelectSingleNode("/Configuration/conf[@key='$key']")
		if ($x -ne $null)
		{
			return $x.value
		}
	}
}

function SetXmlValue([string] $configPath, [string] $key, [string]$value, [string]$category)
{
	if ($configPath -ne "")
	{
		Write-Verbose $configPath
		[xml]$file = Get-Content -Path $configPath
		$x=$file.SelectSingleNode("/Configuration/conf[@key='$key']")
		if ($x -ne $null)
		{
			$x.value=$value
			$x.Category=$category
			$file.Save($configPath)
		}
		else {
			$x=$file.SelectSingleNode("/Configuration")
			$child = $file.CreateElement("conf")
			$child.SetAttribute("key","$key")
			$child.SetAttribute("value","$value")
			$child.SetAttribute("category","$category")
			$file.configuration.AppendChild($child)
			$file.Save($configPath)
		}
	}
}


function CreateFile([string]$configPath)
{
	$configFile='
<Configuration>
	<conf key="ExampleKey" value="ExampleValue" category="ExampleCategory" />
</Configuration>'
	$configFile |Out-File $configPath
}