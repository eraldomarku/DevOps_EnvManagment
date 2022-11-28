$ticked_id = $args[0]
$blob_url = $args[1]

$current_path= Get-Location
azcopy copy "${current_path}\${ticked_id}.zip" "$blob_url" --recursive=true

#Invoke-D365AzCopyTransfer -SourceUri "${current_path}/${ticked_id}.zip" -DestinationUri "$blob_url" -ShowOriginalProgress -Force