param([string]$resourceGroupName, [string]$vmName)

#SET WinRM configuration for 
$comands = '
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12;
$url = "https://raw.githubusercontent.com/ansible/ansible/devel/examples/scripts/ConfigureRemotingForAnsible.ps1";
$file = "$env:temp\ConfigureRemotingForAnsible.ps1";
(New-Object -TypeName System.Net.WebClient).DownloadFile($url, $file);
powershell.exe -ExecutionPolicy ByPass -File $file;
'

Invoke-AzVMRunCommand -ResourceGroupName $resourceGroupName -VMName $vmName -CommandId RunPowerShellScript -ScriptString $comands

apsiaem01
deve4f2cbff76-1