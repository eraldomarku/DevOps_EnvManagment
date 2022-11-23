$url = $args[0]
$ticked_id = $args[1]
$video_or_screenshot = $args[2]
$blob_url = $args[3]






$video_input = $ticked_id
$output_type = ".avi"

$ffmpeg_output = "${video_input}.${output_type}"

$command = "npx playwright codegen " + $url + ' --lang="en-EN"' + " --output reprosteps.test.js"

# Start PlayWright Job

$playwright_job = Start-ThreadJob -Name "play" -ScriptBlock { param (
        [parameter(Mandatory=$true)][string]$ScriptBlock
        ) 
        & ([scriptblock]::Create($ScriptBlock))} -ArgumentList $command

$not_started = $true

while($not_started) {
        $processes = (Get-Process -Name chrome).Count
        Start-Sleep -seconds 1
        $actives = (Get-Process -Name chrome).Count

        if($processes -eq $actives){
                Write-Host("Not Started")
                $not_started = $true
        }

        else {
                Write-Host("Started")
                $not_started = $false
        }
}

if(!$not_started){
        Start-Sleep -seconds 10
        $wshell = New-Object -ComObject Wscript.Shell 
        $Output = $wshell.Popup("You can start reproducing your issue")
        $ffmpeg_command = "ffmpeg -f gdigrab -y -framerate 60 -i desktop ${ffmpeg_output}"

        $ffmpeg_job = Start-ThreadJob -Name "video" -ScriptBlock { param (
                [parameter(Mandatory=$true)][string]$ScriptBlock
                ) 
                & ([scriptblock]::Create($ScriptBlock))} -ArgumentList $ffmpeg_command
}

# Waits for the playwright job to stop and then stops the video recording.

Wait-Job -Name "play"
Stop-Job -Name "video"

## Waits for the playwright job to stop and then stops the video recording.
#
#
$compressed_video = $video_input + "_c" + $output_type
#
#ffmpeg -ss 20 -fflags +discardcorrupt -i $ffmpeg_output -vcodec libx264 $compressed_video
#

$video_recording_path = $compressed_video

#$reprosteps_path = "reprosteps.test.js"

# Move files in other directories if needed.

#$blob_url = "https://apsialn010318c6c1d521243.blob.core.windows.net/source?sp=rw&st=2022-11-17T09:52:17Z&se=2022-11-17T17:52:17Z&spr=https&sv=2021-06-08&sr=c&sig=qlg6WXKXfkHvs4sl3FU3P%2FDkghju2GXYTVAyO6Dqp04%3D"
#Invoke-D365AzCopyTransfer -SourceUri "$reprosteps_path" -DestinationUri "$blob_url" -ShowOriginalProgress -Force
$current_path= [System.Environment]::CurrentDirectory
Invoke-D365AzCopyTransfer -SourceUri "${current_path}/${ffmpeg_output}" -DestinationUri "$blob_url" -ShowOriginalProgress -Force