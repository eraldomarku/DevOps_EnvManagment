$db_path=$args[0] 
$db_name=$args[1]
$sql_db_name=$args[2]
$MSSQL_DATA_path=$args[3]

# Check if sql db name also exists and removes it if is verificated
if(Get-D365Database $sql_db_name){
    Remove-D365Database -DatabaseName $sql_db_name    
}
# The switch command will copy the original AxDB as AxDB_original and if it exist we will have an error so we should remove it
if(Get-D365Database AxDB_original){
    Remove-D365Database -DatabaseName AxDB_original
}
# When creating the new sql db where we will import new db the (sql_db_name)_Primary.mdf should not exist so we check and eventually remove it
if(Test-Path "${MSSQL_DATA_path}${sql_db_name}_Primary.mdf"){
    Remove-Item "${MSSQL_DATA_path}${sql_db_name}_Primary.mdf" -Force
}
# Import db bacpac into "sql_db_name" database created
Import-D365Bacpac -ImportModeTier1 -BacpacFile "${db_path}${db_name}" -NewDatabaseName "${sql_db_name}"
# We need to stop all D365FO related services, to ensure that our D365FO database isn't being lock when we are going to update it.
Stop-D365Environment -All
# With the newly created "sql_db_name" database, we will be switching it in as the D365FO database
Switch-D365ActiveDatabase -SourceDatabaseName "$sql_db_name"
# We need to ensure that the codebase and the database is synchronized correctly and fully working
Invoke-D365DBSync -ShowOriginalProgress
# With the synchronization of the database completed, we need to start all D365FO related services again, to make the D365FO environment available again
Start-D365Environment -All
