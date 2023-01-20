#Questo attiverà il servizio WinRM e imposterà alcune configurazioni di base.
#winrm quickconfig
#per abilitare l'autenticazione di base
#winrm set winrm/config/service/auth @{Basic="true"}
#per consentire la trasmissione di dati non crittografati.
#winrm set winrm/config/service @{AllowUnencrypted="true"}
#per impostare la quantità massima di memoria per shell.
#winrm set winrm/config/winrs @{MaxMemoryPerShellMB="512"}

#Stop-Computer -s -f

Write-Output "PROVAAAAAA"
#Install-Module -Name Az -AllowClobber -Scope CurrentUser
#Get-Module -ListAvailable
#Import-Module Az
#$comands="dir", "Get-Process"
#$logical_to_physical_names=Invoke-SqlCmd -Query "SELECT name, physical_name FROM $sql_db_name.sys.database_files"
#$logical_to_physical_names=Invoke-AzVMRunCommand -ResourceGroupName apsiaem01 -VMName deve4f2cbff76-1 -CommandId RunPowerShellScript -ScriptString 'winrm enumerate winrm/config/Listener'

#Write-Output $logical_to_physical_names

#Connect-AzAccount
$vm = Get-AzVM -Name 'deve4f2cbff76-1' -ResourceGroupName "apsiaem01"
$username = $vm.OsProfile.AdminUsername
Write-Output $username

Set-AzVMAccessExtension -ResourceGroupName "apsiaem01" -VMName "deve4f2cbff76-1" -Name "Microsoft.Compute" -TypeHandlerVersion "1.*"

$password = (Get-AzVMAccessExtension -ResourceGroupName "apsiaem01" -Name 'Microsoft.Compute' -VMName 'deve4f2cbff76-1').PublicSettings.EncryptedPassword | ConvertFrom-Json
Write-Output $password