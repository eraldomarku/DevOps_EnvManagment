# First argument is the bacpacs path
# Second argument is name of the db file
# Third argument is the url of the blob to store the db
$db_path=$args[0] 
$db_name=$args[1]
$blob_url=$args[2]

# If the file exists it will be replaced
#Write-Output $blob_url
#Invoke-D365AzCopyTransfer -SourceUri "${db_path}${db_name}" -DestinationUri "'$blob_url'" -ShowOriginalProgress -Force
