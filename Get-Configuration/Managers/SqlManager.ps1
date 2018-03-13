. ($PSScriptRoot + "\Core.ps1")

function CheckAndCreateTable([string]$SqlServerInstance,[string]$SqlServerDatabase,[string]$SqlSchema,[string]$SqlServerTable)
{
    $databaseExists=$(Test-SqlDatabase -SqlInstance $SqlServerInstance -DatabaseName $SqlServerDatabase)
    if($databaseExists -eq $false)
    {
        Write-Host "Database $SqlServerDatabase on the instance $SqlServerInstance doesn't exist please create it"
    }

    $tableExists=Test-SQLTable -SqlInstance $SqlServerInstance -DatabaseName $SqlServerDatabase -SchemaName $SqlSchema -TableName $SqlServerTable
    if ($tableExists -eq $false)
    {
        Write-Verbose "Table doesn't exist creating"
        New-SQLTable -SqlInstance $SqlServerInstance -DatabaseName $SqlServerDatabase -SchemaName $SqlSchema -TableName $SqlServerTable
        New-SqlColumn -SqlInstance $SqlServerInstance -DatabaseName $SqlServerDatabase -SchemaName $SqlSchema -TableName $SqlServerTable -ColumnName "Key" -Type "VARCHAR(100)"
        New-SqlColumn -SqlInstance $SqlServerInstance -DatabaseName $SqlServerDatabase -SchemaName $SqlSchema -TableName $SqlServerTable -ColumnName "Value" -Type "VARCHAR(1000)"
    }
}

function Set-SqlConfigurationSource()
{
    [cmdletbinding()]
	param ([string]$SqlServerInstance,[string]$SqlServerDatabase,[string]$SqlSchema="dbo",[string]$SqlServerTable)


	$Object = New-Object PSObject                                       
    $Object | add-member Noteproperty Mode       "SQL"                 
    $Object | add-member Noteproperty SqlServerInstance   "$SqlServerInstance"
    $Object | add-member Noteproperty SqlServerDatabase   "$SqlServerDatabase"
    $Object | add-member Noteproperty SqlSchema           "$SqlSchema"
    $Object | add-member Noteproperty SqlServerTable      "$SqlServerTable"

	$conf=ConvertTo-Json -InputObject $Object
	
    SetConfiguration $conf
    CheckAndCreateTable -SqlServerInstance $SqlServerInstance -SqlServerDatabase $SqlServerDatabase -SqlSchema $SqlSchema -SqlServerTable $SqlServerTable
}

function GetSQLValue()
{
    [cmdletbinding()]
	param ([string]$SqlInstance,[string]$DatabaseName,[string]$TableName,[string]$Key)

    $query="SELECT [Value] FROM $TableName WHERE [Key]='$Key'"
    $result=Invoke-SQLQuery -SqlInstance $SqlInstance -DatabaseName $DatabaseName -Query $query	-Verbose:$VerbosePreference
    return $result;
}

function SetSQLValue()
{
    [cmdletbinding()]
    param ([string]$SqlInstance,[string]$DatabaseName,[string]$TableName,[string]$Key,[string]$Value)
    
    $currentValue=GetSQLValue -SqlInstance $SqlInstance -DatabaseName $DatabaseName -TableName $TableName -Key $Key
    if ($currentValue -eq $null) {
        $query="INSERT INTO $TableName([Key],[Value]) VALUES('$Key','$Value')"
        $result=Invoke-SQLQuery -SqlInstance $SqlInstance -DatabaseName $DatabaseName -Query $query	-Verbose:$VerbosePreference
    }
    else {
        $query="UPDATE $TableName SET [Value] ='$Value' WHERE [Key]='$Key'"     
        $result=Invoke-SQLQuery -SqlInstance $SqlInstance -DatabaseName $DatabaseName -Query $query	-Verbose:$VerbosePreference
    }
}
