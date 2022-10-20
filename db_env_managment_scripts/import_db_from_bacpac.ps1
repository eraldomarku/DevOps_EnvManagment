Import-D365Bacpac -ImportModeTier1 -BacpacFile "C:\downloadedBacpacs\db_dev_1.bacpac" -NewDatabaseName AxDB_updated
Stop-D365Environment -All
Switch-D365ActiveDatabase -SourceDatabaseName AxDB_updated
Invoke-D365DBSync -ShowOriginalProgress
Start-D365Environment -All
