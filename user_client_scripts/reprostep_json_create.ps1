param([string]$file, [string]$ticket_id)

#### SAVE CONTENT AND TIME IN TWO ARRAYS###
$line = (Get-Content -Path "$file" | Select-Object -Last 1)
$plusArray = $line.Split("+++") | Select-Object -Skip 1
[array]::Reverse($plusArray)
$minusArray = $line.Split("---") | Select-Object -Skip 1
$minusArray[0] = ""


### REMOVE EMPTY ELEMENTS #####
$plusArray = $plusArray | Where-Object { $_ }
$minusArray = $minusArray | Where-Object { $_ }

### CREATES JSON CONTENT TIME
$resultArray = @()
for ($i=0; $i -lt $plusArray.Length; $i++) {
    $resultArray += @{
        content = $plusArray[$i]
        time = $minusArray[$i]
    }
}

$resultJson = $resultArray | ConvertTo-Json

###  REMOVES ELEMENTS THAT DOESN'T CONTAIN name: from array
$resultArray = $resultArray | Where-Object { $_.content -match "name:" }
$resultJson = $resultArray | ConvertTo-Json

### FILTER for name:
foreach ($item in $resultArray) {
    $item.content = ($item.content -split "name:")[1]
}

$resultJson = $resultArray | ConvertTo-Json

## FILTER for \u0027
foreach ($item in $resultArray) {
    $item.content = ($item.content -split "\u0027")[1]
}

$resultJson = $resultArray | ConvertTo-Json

### REMOVE [ ] FROM TIME
$resultArray |ForEach-Object {
     $_.time = $_.time.Trim('[] ');
}
$resultJson = $resultArray | ConvertTo-Json

### ADD END VIDEO TIME
$current_time = Get-Date -Format "HH:mm:ss"
$new_element = @{
    "time" = "$current_time";
    "content" = "video_end_time"
}

$resultArray += $new_element
$resultJson = $resultArray | ConvertTo-Json

### save json to file 
if (Test-Path "$ticket_id.json") {
    Remove-Item "$ticket_id.json"
}

$resultArray | ConvertTo-Json | Set-Content "$ticket_id.json"