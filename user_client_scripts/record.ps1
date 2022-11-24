$url = $args[0]
$ticked_id = $args[1]
$video_or_screenshot = $args[2]
$blob_url = $args[3]

$zip_name = "${ticked_id}.zip"

if("Video" -eq $video_or_screenshot){

    $video_input = $ticked_id
    $output_type = ".avi"
    $ffmpeg_output = "${video_input}${output_type}"
    $command = "npx playwright codegen " + $url + ' --lang="en-EN"' + " --output reprosteps.test.js"

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

    Wait-Job "play"
    Stop-Job "video"

    

    $compress = @{
        Path = $ffmpeg_output
        CompressionLevel = "Fastest"
        DestinationPath = $zip_name
      }
    
    $compressed_data = Compress-Archive @compress

    #Invoke-D365AzCopyTransfer -SourceUri "$compressed_data" -DestinationUri "$blob_url" -ShowOriginalProgress -Force

}

if ("Video" -eq $video_or_screenshot) {
    do{ Write-Output "When your page is ready, press F2 to take a screenshot.";
    $x = [System.Console]::ReadKey() 
    } while( $x.Key -ne "f2" )

    $screenshot_input = $ticked_id
    $output_type = ".jpeg"
    $screenshot_ffmpeg_output = "${screenshot_input}${output_type}"

    ffmpeg -f gdigrab -framerate 1 -i desktop -vframes 1 $screenshot_ffmpeg_output

    $compress = @{
        Path = $ffmpeg_output
        CompressionLevel = "Fastest"
        DestinationPath = $zip_name
      }
    
    $compressed_data = Compress-Archive @compress

    #Invoke-D365AzCopyTransfer -SourceUri "$compressed_data" -DestinationUri "$blob_url" -ShowOriginalProgress -Force

}