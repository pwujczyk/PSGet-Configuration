function SetConfiguration([string]$configuration)
{    
    $env:PSGetConfiguration=$configuration
}

function GetConfiguration()
{
	return $env:PSGetConfiguration
}