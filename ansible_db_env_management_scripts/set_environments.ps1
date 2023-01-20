param([string]$resourceGroupName, [string]$vmName)


$comands_winRM_setup = '
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12;
$url = "https://raw.githubusercontent.com/ansible/ansible/devel/examples/scripts/ConfigureRemotingForAnsible.ps1";
$file = "$env:temp\ConfigureRemotingForAnsible.ps1";
(New-Object -TypeName System.Net.WebClient).DownloadFile($url, $file);
powershell.exe -ExecutionPolicy ByPass -File $file;
'
$comands_d365fotools_setup = '
# Check if d365fo.tools is installed to eventually delete it and do a fresh install with the packages
if (Get-Module -ListAvailable -Name d365fo.tools) {
    Uninstall-Module -Name d365fo.tools -AllVersions -Force -Verbose
};

Import-Module -Name PowerShellGet -Force;
Set-ExecutionPolicy Unrestricted;
Import-Module -Name PackageManagement -Force;
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.208 -Force;
Install-Module -Name d365fo.tools -Force;
# For antivirus bug of detecting d365 as virus, to import the module we will use this workaround
Set-MpPreference -DisableRealtimeMonitoring $true;
Import-Module d365fo.tools -Force;
Set-MpPreference -DisableRealtimeMonitoring $false;
#------------------------------------------------------------------------------------------
Invoke-D365InstallSqlPackage; 
Invoke-D365InstallAzCopy;
'

Invoke-AzVMRunCommand -ResourceGroupName $resourceGroupName -VMName $vmName -CommandId RunPowerShellScript -ScriptString $comands_winRM_setup
Invoke-AzVMRunCommand -ResourceGroupName $resourceGroupName -VMName $vmName -CommandId RunPowerShellScript -ScriptString $comands_d365fotools_setup
