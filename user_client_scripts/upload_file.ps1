$ticked_id = $args[0]
$blob_url = $args[1]

$current_path= [System.Environment]::CurrentDirectory
Invoke-D365AzCopyTransfer -SourceUri "${current_path}/${ticked_id}.zip" -DestinationUri "$blob_url" -ShowOriginalProgress -Force