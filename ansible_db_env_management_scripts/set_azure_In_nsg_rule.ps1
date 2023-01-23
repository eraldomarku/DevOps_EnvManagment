param([string]$resourceGroupName,[string]$networkSecurityGroupName,[string]$ruleName,[string]$destinationPort)

$nsg_obj = Get-AzNetworkSecurityGroup -Name $networkSecurityGroupName -ResourceGroupName $resourceGroupName

try{
    $nsg_rule_obj = Get-AzNetworkSecurityRuleConfig -Name $ruleName -NetworkSecurityGroup $nsg_obj    
    Add-AzNetworkSecurityRuleConfig -Name $ruleName -NetworkSecurityGroup $nsg_obj -Protocol $protocol -SourcePortRange "*" -DestinationPortRange $destinationPort -SourceAddressPrefix "*" -DestinationAddressPrefix "*" -Direction "Inbound" -Access "Allow" -Priority 100
    Set-AzNetworkSecurityGroup -NetworkSecurityGroup $nsg_obj
}
catch{
    Write-Host "Rule "$ruleName" already exists"
}