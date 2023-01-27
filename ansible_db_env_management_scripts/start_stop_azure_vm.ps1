param([string]$command, [string]$resourceGroupName, [string]$vmName)

if($command -eq "stop"){
    # To stop the vm
    Stop-AzVM -ResourceGroupName $resourceGroupName -Name $vmName
}
if($command -eq "start"){
    # To start vm
    Start-AzVM -ResourceGroupName $resourceGroupName -Name $vmName
}