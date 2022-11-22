# Replace & with %26

#$url = "https://devtestgiliebe02a3ff67b3b5edevaos.axcloud.dynamics.com/?cmp=ITCO&mi=DefaultDashboard"
$url = "https:www.google.com"
$url = $url.replace("&","%26")

$token_set = @{
     L = [Char[]]'abcdefghijklmnopqrstuvwxyz'
     N = [Char[]]'0123456789'
}

$Lower = Get-Random -Count 10 -InputObject $token_set.L
$Number = Get-Random -Count 10 -InputObject $token_set.N

$StringSet = $Lower + $Number 

$video_input = (Get-Random -Count 20 -InputObject $StringSet) -join ''
$output_type = ".avi"

$ffmpeg_output = $video_input + $output_type

$command = "npx playwright codegen " + $url + " --output reprosteps.test.js"

$playwright_job = Start-ThreadJob -Name "play" -ScriptBlock { param (
        [parameter(Mandatory=$true)][string]$ScriptBlock
        ) 
        & ([scriptblock]::Create($ScriptBlock))} -ArgumentList $command

$ffmpeg_command = "ffmpeg -f gdigrab -framerate 60 -i desktop output.avi"

$ffmpeg_job = Start-ThreadJob -Name "video" -ScriptBlock { param (
        [parameter(Mandatory=$true)][string]$ScriptBlock
        ) 
        & ([scriptblock]::Create($ScriptBlock))} -ArgumentList $ffmpeg_command

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
#Invoke-D365AzCopyTransfer -SourceUri "$video_recording_path" -DestinationUri "$blob_url" -ShowOriginalProgress -Force
