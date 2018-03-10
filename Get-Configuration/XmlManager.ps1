function GetFileName()
{
	return "PSGetConfiguration.xml"
}

function GetXMLValue([string]$configPath, [string]$key)
{
	if ( $(Test-Path $configPath) -eq $false)
	{
		CreateFile $configPath
	}
	
	$result=Get-FileConfiguration $configPath $key
    return $result
	
}

function Get-FileConfiguration([string] $configPath, [string] $key)
{
	if ($configPath -ne "")
	{
		Write-Host $configPath
		[xml]$file =Get-Content -Path $configPath
		#Write-host $userfile
		$x=$file.SelectSingleNode("/Configuration/conf[@key='$key']")
		if ($x -ne $null)
		{
			return $x.value
		}
	}
}

function CreateFile([string]$configPath)
{
	$configFile='
<Configuration>
	<conf key="Example" value="Example" />
</Configuration>'
	$configFile |Out-File $configPath
}