$bacpacs_path = "C:\Bacpacs"
$bacpac_file_path = "C:\Bacpacs\db_dev_1.bacpac"

if (Test-Path $bacpacs_path) {
    if (Test-Path $bacpac_file_path) {
        Write-Host "Removing File That Also Exists"
        Remove-Item $bacpac_file_path -Force
    }
}
else
{
    New-Item $bacpacs_path -itemType Directory
}
Stop-D365Environment -All
New-D365Bacpac -ExportModeTier1 -ShowOriginalProgress -BacpacFile $bacpac_file_path
Start-D365Environment -All
