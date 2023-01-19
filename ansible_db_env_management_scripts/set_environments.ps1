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