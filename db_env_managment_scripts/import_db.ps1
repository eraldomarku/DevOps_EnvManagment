$db_path=$args[0] 
$db_name=$args[1]
$sql_db_name=$args[2]

# We need to stop all D365FO related services, to ensure that our D365FO database isn't being lock when we are going to update it.
Stop-D365Environment -All
# We will check if old db exist we will remove it
##if(Get-D365Database AxDB_original){
##    Remove-D365Database -DatabaseName AxDB_original    
##}
# Import bacpac db to new db
##Import-D365Bacpac -ImportModeTier1 -BacpacFile "${db_path}${db_name}" -NewDatabaseName $sql_db_name
# With the newly created "AxDB" database, we will be switching it in as the D365FO database and this command will create AxDB_original with link to the old AxDB.mdf ldf files
##Switch-D365ActiveDatabase -SourceDatabaseName "$sql_db_name"

#-------------------------------------------------------------------------------------------
# CHANGE AxDB physical filenames

#name      physical_name
#----      -------------
#Prova     G:\MSSQL_DATA\Prova444.mdf
#Prova_log H:\MSSQL_LOGS\Prova_log.ldf
$logical_to_physical_names=Invoke-SqlCmd -Query "SELECT name, physical_name FROM AxDB_original.sys.database_files"
$logical_mdf_name=$logical_to_physical_names[0][0]
$logical_ldf_name=$logical_to_physical_names[1][0]
# Now we save the paths of mdf and ldf files without file.extension ex."G:\MSSQL_DATA\Prova444.mdf" -> "G:\MSSQL_DATA"
$physical_mdf_path=$logical_to_physical_names[0][1]
$physical_ldf_path=$logical_to_physical_names[1][1]

# SET AxDB offilne
Invoke-SqlCmd -Query "ALTER DATABASE AxDB_original SET OFFLINE"
Invoke-SqlCmd -Query "GO"

# RENAME PHYSICAL FILES
Rename-Item -Path "$physical_mdf_path" -NewName "AxDB_original.mdf"
Rename-Item -Path "$physical_ldf_path" -NewName "AxDB_original.ldf"

# removing from the path the "\file.extension" -> "G:\MSSQL_DATA\Prova444.mdf" -> "G:\MSSQL_DATA"
$physical_mdf_path=$physical_mdf_path.Substring(0, $physical_mdf_path.lastIndexOf('\'))
$physical_ldf_path=$physical_ldf_path.Substring(0, $physical_ldf_path.lastIndexOf('\'))

# Change path of the logical names
Invoke-SqlCmd -Query "alter database AxDB_original modify file (name = ${logical_mdf_name}, filename = '${$physical_mdf_path}\AxDB_original.mdf')" -Verbose
Invoke-SqlCmd -Query "alter database AxDB_original modify file (name = ${logical_ldf_name}, filename = '${$physical_ldf_path}\AxDB_original_log.ldf')" -Verbose
Invoke-SqlCmd -Query "GO"

# SET DB ONLINE
Invoke-SqlCmd -Query "alter database AxDB_original set online" -Verbose


#-------------------------------------------------------------------------------------------
# CHANGE AxDB physical filenames

#name      physical_name
#----      -------------
#Prova     G:\MSSQL_DATA\Prova444.mdf
#Prova_log H:\MSSQL_LOGS\Prova_log.ldf
$logical_to_physical_names=Invoke-SqlCmd -Query "SELECT name, physical_name FROM AxDB.sys.database_files"
$logical_mdf_name=$logical_to_physical_names[0][0]
$logical_ldf_name=$logical_to_physical_names[1][0]
# Now we save the paths of mdf and ldf files without file.extension ex."G:\MSSQL_DATA\Prova444.mdf" -> "G:\MSSQL_DATA"
$physical_mdf_path=$logical_to_physical_names[0][1]
$physical_ldf_path=$logical_to_physical_names[1][1]

# SET AxDB offilne
Invoke-SqlCmd -Query "ALTER DATABASE AxDB SET OFFLINE"
Invoke-SqlCmd -Query "GO"

# RENAME PHYSICAL FILES
Rename-Item -Path "$physical_mdf_path" -NewName "AxDB.mdf"
Rename-Item -Path "$physical_ldf_path" -NewName "AxDB.ldf"

# removing from the path the "\file.extension" -> "G:\MSSQL_DATA\Prova444.mdf" -> "G:\MSSQL_DATA"
$physical_mdf_path=$physical_mdf_path.Substring(0, $physical_mdf_path.lastIndexOf('\'))
$physical_ldf_path=$physical_ldf_path.Substring(0, $physical_ldf_path.lastIndexOf('\'))

# Change path of the logical names
Invoke-SqlCmd -Query "alter database AxDB modify file (name = ${logical_mdf_name}, filename = '${$physical_mdf_path}\AxDB.mdf')" -Verbose
Invoke-SqlCmd -Query "alter database AxDB modify file (name = ${logical_ldf_name}, filename = '${$physical_ldf_path}\AxDB_log.ldf')" -Verbose
Invoke-SqlCmd -Query "GO"

# SET DB ONLINE
Invoke-SqlCmd -Query "alter database AxDB set online" -Verbose

#-------------------------------------------------------------------------------------------

# We need to ensure that the codebase and the database is synchronized correctly and fully working
Invoke-D365DBSync -ShowOriginalProgress

# With the synchronization of the database completed, we need to start all D365FO related services again, to make the D365FO environment available again
Start-D365Environment -All
