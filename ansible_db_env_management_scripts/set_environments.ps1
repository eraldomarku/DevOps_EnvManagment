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
$comands="dir", "Get-Process"
#$logical_to_physical_names=Invoke-SqlCmd -Query "SELECT name, physical_name FROM $sql_db_name.sys.database_files"
$logical_to_physical_names=Invoke-AzVMRunCommand -ResourceGroupName apsiaem01 -VMName deve4f2cbff76-1 -CommandId RunPowerShellScript -ScriptString 'Get-WSManInstance -ResourceURI winrm/config/service/auth'

Write-Output $logical_to_physical_names