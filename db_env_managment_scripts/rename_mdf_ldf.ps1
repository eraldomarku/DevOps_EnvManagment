$sql_db_name=$args[0]

# Rename mdf and ldf files of a db with the same name 

#name      physical_name
#----      -------------
#Prova     G:\MSSQL_DATA\Prova444.mdf
#Prova_log H:\MSSQL_LOGS\Prova_log.ldf
$logical_to_physical_names=Invoke-SqlCmd -Query "SELECT name, physical_name FROM $sql_db_name.sys.database_files"
$logical_mdf_name=$logical_to_physical_names[0][0]
$logical_ldf_name=$logical_to_physical_names[1][0]
# Now we save the paths of mdf and ldf files without file.extension ex."G:\MSSQL_DATA\Prova444.mdf" -> "G:\MSSQL_DATA"
$physical_mdf_path=$logical_to_physical_names[0][1]
$physical_ldf_path=$logical_to_physical_names[1][1]

# SET AxDB offilne
Invoke-SqlCmd -Query "ALTER DATABASE $sql_db_name SET OFFLINE"
Invoke-SqlCmd -Query "GO"

# RENAME PHYSICAL FILES
Rename-Item -Path $physical_mdf_path -NewName "$sql_db_name.mdf"
Rename-Item -Path $physical_ldf_path -NewName "$sql_db_name.ldf"

# removing from the path the "\file.extension" -> "G:\MSSQL_DATA\Prova444.mdf" -> "G:\MSSQL_DATA"
$physical_mdf_path=$physical_mdf_path.Substring(0, $physical_mdf_path.lastIndexOf('\'))
$physical_ldf_path=$physical_ldf_path.Substring(0, $physical_ldf_path.lastIndexOf('\'))

# Change path of the logical names
Invoke-SqlCmd -Query "alter database $sql_db_name modify file (name = $logical_mdf_name, filename = '$physical_mdf_path\$sql_db_name.mdf')" -Verbose
Invoke-SqlCmd -Query "alter database $sql_db_name modify file (name = $logical_ldf_name, filename = '$physical_ldf_path\$sql_db_name.ldf')" -Verbose
Invoke-SqlCmd -Query "GO"

# SET DB ONLINE
Invoke-SqlCmd -Query "alter database $sql_db_name set online" -Verbose
