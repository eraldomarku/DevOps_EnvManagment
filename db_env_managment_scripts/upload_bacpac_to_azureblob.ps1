$bacpac_file_path = "C:\Bacpacs\db_dev_1.bacpac"
Invoke-D365AzCopyTransfer -SourceUri $bacpac_file_path -DestinationUri "https://apsiaem01ada09a20ec1a713.blob.core.windows.net/retail-cdx-down-68719476736?sp=racwdli&st=2022-10-19T10:51:08Z&se=2023-02-02T19:51:08Z&spr=https&sv=2021-06-08&sr=c&sig=kiGgyozma%2FZWom%2BtWz%2F7ynf8rEoXCn3XP5DjigiS65Q%3D" -ShowOriginalProgress -Force
