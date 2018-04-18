function SetConfiguration([string]$configuration)
{    
    $env:PSGetConfiguration=$configuration
}

function GetEnvConfiguration()
{
	return $env:PSGetConfiguration
}