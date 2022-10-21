# First argument is the bacpacs path
# Second argument is name of the db file
$db_path=$args[0] 
$db_name=$args[1]

if (Test-Path $db_path) {
    if (Test-Path "${db_path}${db_name}") {
        Write-Host "Removing file that also exist"
        Remove-Item "${db_path}${db_name}" -Force
    }
}
else
{
    New-Item $db_path -itemType Directory
}
Stop-D365Environment -All
New-D365Bacpac -ExportModeTier1 -ShowOriginalProgress -BacpacFile "${db_path}${db_name}"
Start-D365Environment -All
