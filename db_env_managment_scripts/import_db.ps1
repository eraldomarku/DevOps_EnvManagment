$db_path=$args[0] 
$db_name=$args[1]
$sql_db_name=$args[2]

#Import db bacpac into new database and then synchronize the imported db
Import-D365Bacpac -ImportModeTier1 -BacpacFile "${db_path}${db_name}" -NewDatabaseName $sql_db_name
Stop-D365Environment -All
Switch-D365ActiveDatabase -SourceDatabaseName $sql_db_name
Invoke-D365DBSync -ShowOriginalProgress
Start-D365Environment -All
