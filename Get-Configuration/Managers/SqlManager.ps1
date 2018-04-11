. ($PSScriptRoot + "\Core.ps1")

function CheckAndCreateTable([string]$SqlServerInstance,[string]$SqlServerDatabase,[string]$SqlServerSchema,[string]$SqlServerTable)
{
    $databaseExists=$(Test-SqlDatabase -SqlInstance $SqlServerInstance -DatabaseName $SqlServerDatabase)
    if($databaseExists -eq $false)
    {
        Write-Host "Database $SqlServerDatabase on the instance $SqlServerInstance doesn't exist please create it"
    }
	else
	{
		$tableExists=Test-SQLTable -SqlInstance $SqlServerInstance -DatabaseName $SqlServerDatabase -SchemaName $SqlServerSchema -TableName $SqlServerTable
		if ($tableExists -eq $false)
		{
			Write-Verbose "Table doesn't exist creating"
			New-SQLTable -SqlInstance $SqlServerInstance -DatabaseName $SqlServerDatabase -SchemaName $SqlServerSchema -TableName $SqlServerTable
			New-SqlColumn -SqlInstance $SqlServerInstance -DatabaseName $SqlServerDatabase -SchemaName $SqlServerSchema -TableName $SqlServerTable -ColumnName "Key" -Type "VARCHAR(100)"
			New-SqlColumn -SqlInstance $SqlServerInstance -DatabaseName $SqlServerDatabase -SchemaName $SqlServerSchema -TableName $SqlServerTable -ColumnName "Value" -Type "VARCHAR(1000)"
			New-SqlColumn -SqlInstance $SqlServerInstance -DatabaseName $SqlServerDatabase -SchemaName $SqlServerSchema -TableName $SqlServerTable -ColumnName "Category" -Type "VARCHAR(1000)"
		}
	}
}

function Set-ConfigurationSqlSource()
{
    [cmdletbinding()]
	param ([string]$SqlServerInstance,[string]$SqlServerDatabase,[string]$SqlServerSchema="dbo",[string]$SqlServerTable)

	CheckAndCreateTable -SqlServerInstance $SqlServerInstance -SqlServerDatabase $SqlServerDatabase -SqlServerSchema $SqlServerSchema -SqlServerTable $SqlServerTable

	$Object = New-Object PSObject                                       
    $Object | add-member Noteproperty Mode       "SQL"                 
    $Object | add-member Noteproperty SqlServerInstance   "$SqlServerInstance"
    $Object | add-member Noteproperty SqlServerDatabase   "$SqlServerDatabase"
    $Object | add-member Noteproperty SqlServerSchema     "$SqlServerSchema"
    $Object | add-member Noteproperty SqlServerTable      "$SqlServerTable"

	$conf=ConvertTo-Json -InputObject $Object
	
    SetConfiguration $conf
    CheckAndCreateTable -SqlServerInstance $SqlServerInstance -SqlServerDatabase $SqlServerDatabase -SqlServerSchema $SqlServerSchema -SqlServerTable $SqlServerTable
}

function GetSQLConfigurationAll()
{
	[cmdletbinding()]
	param ([string]$SqlInstance,[string]$DatabaseName,[string]$SchemaName,[string]$TableName)

	$query="SELECT [Key], [Value], [Category] FROM [$SchemaName].[$TableName]"
	$result=Invoke-SQLQuery -SqlInstance $SqlInstance -DatabaseName $DatabaseName -Query $query	-Verbose:$VerbosePreference
	$objectList=@()
	foreach($item in $result)
	{
		$object = New-Object –TypeName PSObject
		$object | Add-Member –MemberType NoteProperty –Name Key –Value $item.Key
		$object | Add-Member –MemberType NoteProperty –Name Value –Value $item.Value
		$object | Add-Member –MemberType NoteProperty –Name Category –Value $item.Category
		$objectList+=$object
	}
	return $objectList
}

function GetSQLValue()
{
    [cmdletbinding()]
	param ([string]$SqlInstance,[string]$DatabaseName,[string]$SchemaName,[string]$TableName,[string]$Key)

	if ($key -eq "")
	{
		$result=GetSQLConfigurationAll -SqlInstance $SqlInstance -DatabaseName $DatabaseName -SchemaName $SchemaName -TableName $TableName -Verbose:$VerbosePreference
	}
	else
	{
	    $query="SELECT [Value] FROM [$SchemaName].[$TableName] WHERE [Key]='$Key'"
		$queryresult=Invoke-SQLQuery -SqlInstance $SqlInstance -DatabaseName $DatabaseName -Query $query	-Verbose:$VerbosePreference
		$result=$queryresult.value

	}
	return $result
}

function SetSQLValue()
{
    [cmdletbinding()]
    param ([string]$SqlInstance,[string]$DatabaseName,[string]$SchemaName, [string]$TableName,[string]$Key,[string]$Value,[string]$category)
    
    $currentValue=GetSQLValue -SqlInstance $SqlInstance -DatabaseName $DatabaseName -SchemaName $SchemaName -TableName $TableName -Key $Key
    if ($currentValue -eq $null) {
        $query="INSERT INTO [$SchemaName].[$TableName]([Key],[Value],[Category]) VALUES('$Key','$Value','$category')"
        $result=Invoke-SQLQuery -SqlInstance $SqlInstance -DatabaseName $DatabaseName -Query $query	-Verbose:$VerbosePreference
    }
    else {
        $query="UPDATE [$SchemaName].[$TableName] SET [Value] ='$Value',[Category]='$category' WHERE [Key]='$Key'"     
        $result=Invoke-SQLQuery -SqlInstance $SqlInstance -DatabaseName $DatabaseName -Query $query	-Verbose:$VerbosePreference
    }
}


function ClearConfigurationByKeySQL()
{
	[cmdletbinding()]
    param ([string]$SqlInstance,[string]$DatabaseName,[string]$SchemaName, [string]$TableName,[string]$Key)

	  $query="DELETE [$SchemaName].[$TableName] WHERE [Key]='$Key'"
      $result=Invoke-SQLQuery -SqlInstance $SqlInstance -DatabaseName $DatabaseName -Query $query -Verbose:$VerbosePreference

}

function ClearConfigurationByCategorySQL()
{
	[cmdletbinding()]
    param ([string]$SqlInstance,[string]$DatabaseName,[string]$SchemaName, [string]$TableName,[string]$Category)

	  $query="DELETE [$SchemaName].[$TableName] WHERE [Category]='$Category'"
      $result=Invoke-SQLQuery -SqlInstance $SqlInstance -DatabaseName $DatabaseName -Query $query	-Verbose:$VerbosePreference
}