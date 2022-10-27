# First argument is the bacpacs path
# Second argument is name of the db file
$db_path=$args[0] 
$db_name=$args[1]

#Chekck if path directory exists and if so check if file exist and if so delete it
if (Test-Path $db_path) {
    if (Test-Path "${db_path}${db_name}") {
        Write-Host "Removing file that also exists"
        Remove-Item "${db_path}${db_name}" -Force
    }
}
#If path directory doesen't exist create it
else
{
    New-Item $db_path -itemType Directory
}
#We need to stop all D365FO related services, to ensure that our database isn't being updated while we are exporting it. Type the following command:
Stop-D365Environment -All
#Export AxDB from sql to bacpac in path directory
New-D365Bacpac -ExportModeTier1 -ShowOriginalProgress -BacpacFile "${db_path}${db_name}"
Start-D365Environment -All
