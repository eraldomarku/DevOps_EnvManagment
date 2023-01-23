param([string]$resourceGroupName,[string]$networkSecurityGroupName,[string]$ruleName,[string]$destinationPort)
Write-Host "Passo 1"
$nsg_obj = Get-AzNetworkSecurityGroup -Name $networkSecurityGroupName -ResourceGroupName $resourceGroupName
Write-Host "Passo 2"
try{
    #Throws error if that rule does not exist
    $nsg_rule_obj = Get-AzNetworkSecurityRuleConfig -Name $ruleName -NetworkSecurityGroup $nsg_obj    
    Write-Host "Rule "$ruleName" already exists"
}
catch{
    #If error means that rule does not exist so we create it
    Add-AzNetworkSecurityRuleConfig -Name $ruleName -NetworkSecurityGroup $nsg_obj -Protocol "Tcp" -SourcePortRange "*" -DestinationPortRange $destinationPort -SourceAddressPrefix "*" -DestinationAddressPrefix "*" -Direction "Inbound" -Access "Allow" -Priority 100
    Set-AzNetworkSecurityGroup -NetworkSecurityGroup $nsg_obj    
}