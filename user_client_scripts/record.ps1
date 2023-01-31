$url = $args[0]
$ticket_id = $args[1]
$video_or_screenshot = $args[2]
$blob_url = $args[3]

$zipped_name = "${ticket_id}" 

function Set-WindowState {
    <#
    .LINK
    https://gist.github.com/Nora-Ballard/11240204
    #>

    [CmdletBinding(DefaultParameterSetName = 'InputObject')]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true)]
        [Object[]] $InputObject,

        [Parameter(Position = 1)]
        [ValidateSet('FORCEMINIMIZE', 'HIDE', 'MAXIMIZE', 'MINIMIZE', 'RESTORE',
                     'SHOW', 'SHOWDEFAULT', 'SHOWMAXIMIZED', 'SHOWMINIMIZED',
                     'SHOWMINNOACTIVE', 'SHOWNA', 'SHOWNOACTIVATE', 'SHOWNORMAL')]
        [string] $State = 'SHOW',
        [switch] $SuppressErrors = $false,
        [switch] $SetForegroundWindow = $false
    )

    Begin {
        $WindowStates = @{
        'FORCEMINIMIZE'         = 11
            'HIDE'              = 0
            'MAXIMIZE'          = 3
            'MINIMIZE'          = 6
            'RESTORE'           = 9
            'SHOW'              = 5
            'SHOWDEFAULT'       = 10
            'SHOWMAXIMIZED'     = 3
            'SHOWMINIMIZED'     = 2
            'SHOWMINNOACTIVE'   = 7
            'SHOWNA'            = 8
            'SHOWNOACTIVATE'    = 4
            'SHOWNORMAL'        = 1
        }

        $Win32ShowWindowAsync = Add-Type -MemberDefinition @'
[DllImport("user32.dll")]
public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);
[DllImport("user32.dll", SetLastError = true)]
public static extern bool SetForegroundWindow(IntPtr hWnd);
'@ -Name "Win32ShowWindowAsync" -Namespace Win32Functions -PassThru

        if (!$global:MainWindowHandles) {
            $global:MainWindowHandles = @{ }
        }
    }

    Process {
        foreach ($process in $InputObject) {
            $handle = $process.MainWindowHandle

            if ($handle -eq 0 -and $global:MainWindowHandles.ContainsKey($process.Id)) {
                $handle = $global:MainWindowHandles[$process.Id]
            }

            if ($handle -eq 0) {
                if (-not $SuppressErrors) {
                    Write-Error "Main Window handle is '0'"
                }
                continue
            }

            $global:MainWindowHandles[$process.Id] = $handle

            $Win32ShowWindowAsync::ShowWindowAsync($handle, $WindowStates[$State]) | Out-Null
            if ($SetForegroundWindow) {
                $Win32ShowWindowAsync::SetForegroundWindow($handle) | Out-Null
            }

            Write-Verbose ("Set Window State '{1} on '{0}'" -f $MainWindowHandle, $State)
        }
    }
}

if("Video" -eq $video_or_screenshot){

    $video_input = $ticket_id
    $output_type = ".avi"
    $ffmpeg_output = "${video_input}${output_type}"
    $command = "npx playwright codegen " + $url + " --output reprosteps.test.js"

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

    $playwright_not_visible = $true
    $window = "PlayWright Inspector"
    while($playwright_not_visible) {
        Start-Sleep -seconds 1
        if((Get-Process | Where-Object {$_.mainWindowTitle -eq $window}).MainWindowHandle) {
            Get-Process | Where-Object {$_.mainWindowTitle -eq $window} | Set-WindowState -State HIDE
            $playwright_not_visible = $false
        }
    }


    if(!$not_started){
        #$wshell = New-Object -ComObject Wscript.Shell 
        #$Output = $wshell.Popup("You can start reproducing your issue")
        $ffmpeg_command = "ffmpeg -f gdigrab -y -framerate 60 -i desktop ${ffmpeg_output}"

        $ffmpeg_job = Start-ThreadJob -Name "video" -ScriptBlock { param (
                [parameter(Mandatory=$true)][string]$ScriptBlock
                ) 
                & ([scriptblock]::Create($ScriptBlock))} -ArgumentList $ffmpeg_command

        $current_path= Get-Location
        $listener_command = "& '${current_path}\user_client_scripts\reprostep_file_listener.ps1' -reprostep_file_js ${current_path}\reprosteps.test.js"
        $time_listener_reprostep = Start-ThreadJob -Name "time_listener_reprostep" -ScriptBlock { param (
                [parameter(Mandatory=$true)][string]$ScriptBlock
                ) 
                & ([scriptblock]::Create($ScriptBlock))} -ArgumentList $listener_command
    }

    Wait-Job "play"
    Stop-Job "time_listener_reprostep"
    Stop-Job "video"
    & "${current_path}\user_client_scripts\reprostep_json_create.ps1" -reprostep_file_js "${current_path}\reprosteps.test.js" -ticket_id "$ticket_id"
    

    node user_client_scripts/reprostep_processing.js

    

    $compress = @{
        Path = $ffmpeg_output
        CompressionLevel = "Fastest"
        DestinationPath = "${ticket_id}.zip"
      }
    
    $compressed_data = Compress-Archive @compress

    Remove-Item $ffmpeg_output

    #Invoke-D365AzCopyTransfer -SourceUri "$compressed_data" -DestinationUri "$blob_url" -ShowOriginalProgress -Force

}

if ("Screenshot" -eq $video_or_screenshot) {

    $screenshot_input = $ticket_id
    $output_type = ".jpeg"
    $screenshot_ffmpeg_output = "${screenshot_input}${output_type}"

    ffmpeg -f gdigrab -framerate 1 -i desktop -vframes 1 $screenshot_ffmpeg_output

    $compress = @{
        Path = $screenshot_ffmpeg_output
        CompressionLevel = "Fastest"
        DestinationPath = "${ticket_id}.zip"
      }
    
    $compressed_data = Compress-Archive @compress
    Remove-Item $screenshot_ffmpeg_output
    #Invoke-D365AzCopyTransfer -SourceUri "$compressed_data" -DestinationUri "$blob_url" -ShowOriginalProgress -Force

}