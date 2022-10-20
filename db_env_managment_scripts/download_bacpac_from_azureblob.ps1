$bacpacs_downloaded_path = "C:\downloadedBacpacs"
$bacpac_file_path = "C:\downloadedBacpacs\db_dev_1.bacpac"

if (Test-Path $bacpacs_downloaded_path) {
  if(Test-Path $bacpac_file_path){
     Write-Host "Removing File That Also Exists"
     Remove-Item $bacpac_file_path -Force
  }
}
else{
  New-Item $bacpacs_downloaded_path -itemType Directory
}
Invoke-D365AzCopyTransfer -SourceUri "https://apsiaem01ada09a20ec1a713.blob.core.windows.net/retail-cdx-down-68719476736/db_dev_1.bacpac?sp=racwdli&st=2022-10-19T10:51:08Z&se=2023-02-02T19:51:08Z&spr=https&sv=2021-06-08&sr=c&sig=kiGgyozma%2FZWom%2BtWz%2F7ynf8rEoXCn3XP5DjigiS65Q%3D" -DestinationUri $bacpac_file_path -ShowOriginalProgress
