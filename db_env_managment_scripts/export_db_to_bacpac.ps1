Stop-D365Environment -All
New-D365Bacpac -ExportModeTier1 -ShowOriginalProgress -BacpacFile C:\Bacpacs\db_dev_1.bacpac
Start-D365Environment -All
