param([string]$file, [string]$ticket_id)

$contents = Get-Content -Path "$file"

### CREATES JSON FROM RECRODED STEPS IN TXT FILE WITH ASSOCIATED TIME
$json = @()
foreach ($line in $contents) {
   if ($line -match '\d\d:\d\d:\d\d') {
     $time = [string]$line
   } else {
     $json += @{ time = $time; content = [string]$line }
   }
 }

### ADD END VIDEO TIME
$current_time = Get-Date -Format "HH:mm:ss"
$new_element = @{
    "time" = "$current_time";
    "content" = "video_end_time"
}
$json += $new_element
$resultJson = $json | ConvertTo-Json

### save json to file 
if (Test-Path "$ticket_id.json") {
    Remove-Item "$ticket_id.json"
}

$json | ConvertTo-Json | Set-Content "$ticket_id.json"