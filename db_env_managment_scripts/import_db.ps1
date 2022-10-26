$db_path=$args[0] 
$db_name=$args[1]
$sql_db_name=$args[2]
#$MSSQL_DATA_path=$args[3]


# We need to stop all D365FO related services, to ensure that our D365FO database isn't being lock when we are going to update it.
Stop-D365Environment -All

# Remove actual AxDB database
#if(Get-D365Database AxDB){
#    Remove-D365Database -DatabaseName AxDB_updated    
#}

# Remove if there is a copy of db made by switch command
#if(Get-D365Database AxDB_original){
#    Remove-D365Database -DatabaseName AxDB_original    
#}

# Import bacpac db to new db
Import-D365Bacpac -ImportModeTier1 -BacpacFile "${db_path}${db_name}" -NewDatabaseName $sql_db_name

# With the newly created "AxDB" database, we will be switching it in as the D365FO database
#Switch-D365ActiveDatabase -SourceDatabaseName "$sql_db_name"

# We need to ensure that the codebase and the database is synchronized correctly and fully working
#Invoke-D365DBSync -ShowOriginalProgress

# With the synchronization of the database completed, we need to start all D365FO related services again, to make the D365FO environment available again
#Start-D365Environment -All
