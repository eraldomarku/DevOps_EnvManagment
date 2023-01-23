param([string]$resourceGroupName,[string]$networkSecurityGroupName,[string]$ruleName,[string]$destinationPort)
Write-Host "Passo 1"
$nsg_obj = Get-AzNetworkSecurityGroup -Name $networkSecurityGroupName -ResourceGroupName $resourceGroupName
Write-Host "Passo 2"
try{
    Write-Host "Passo 3"
    $nsg_rule_obj = Get-AzNetworkSecurityRuleConfig -Name $ruleName -NetworkSecurityGroup $nsg_obj    
    Add-AzNetworkSecurityRuleConfig -Name $ruleName -NetworkSecurityGroup $nsg_obj -Protocol $protocol -SourcePortRange "*" -DestinationPortRange $destinationPort -SourceAddressPrefix "*" -DestinationAddressPrefix "*" -Direction "Inbound" -Access "Allow" -Priority 100
    Set-AzNetworkSecurityGroup -NetworkSecurityGroup $nsg_obj
    Write-Host "Passo 4"
}
catch{
    Write-Host "Rule "$ruleName" already exists"
    Write-Host "Passo 5"
}