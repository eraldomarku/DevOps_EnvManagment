# First argument is the bacpacs path
# Second argument is name of the db file
$db_path=$args[0] 
$db_name=$args[1]
$blob_url=$args[2]

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
# With replace we have added the filename in the path to download it
Invoke-D365AzCopyTransfer -SourceUri $blob_url.replace("?","/${db_name}?") -DestinationUri "${db_path}${db_name}" -ShowOriginalProgress
