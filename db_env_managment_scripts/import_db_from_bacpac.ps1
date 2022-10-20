$bacpac_file_path = "C:\downloadedBacpacs\db_dev_1.bacpac"

Import-D365Bacpac -ImportModeTier1 -BacpacFile $bacpac_file_path -NewDatabaseName AxDB_updated
Stop-D365Environment -All
Switch-D365ActiveDatabase -SourceDatabaseName AxDB_updated
Invoke-D365DBSync -ShowOriginalProgress
Start-D365Environment -All
