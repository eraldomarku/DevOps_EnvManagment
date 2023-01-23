param([string]$resourceGroupName,[string]$networkSecurityGroupName,[string]$ruleName,[string]$destinationPort)
Write-Host "PASSO 1"
$nsg_obj = Get-AzNetworkSecurityGroup -Name $networkSecurityGroupName -ResourceGroupName $resourceGroupName
Write-Host "PASSO 2"
$nsg_rule_obj = Get-AzNetworkSecurityRuleConfig -Name $ruleName -NetworkSecurityGroup $nsg_obj
Write-Host "PASSO 3"
if($nsg_rule_obj){
    Write-Host "Rule "$ruleName" already exists" 
}
else{
    Add-AzNetworkSecurityRuleConfig -Name $ruleName -NetworkSecurityGroup $nsg_obj -Protocol $protocol -SourcePortRange "*" -DestinationPortRange $destinationPort -SourceAddressPrefix "*" -DestinationAddressPrefix "*" -Direction "Inbound" -Access "Allow" -Priority 100
    Set-AzNetworkSecurityGroup -NetworkSecurityGroup $nsg_obj
}