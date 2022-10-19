powershell -Command "Start-Process powershell -ArgumentList 'C:\windows\system32\cmd.exe /D /S /C start C:\agent\run.cmd --startuptype autostartup' -Verb RunAs"
Stop-D365Environment -All
New-D365Bacpac -ExportModeTier1 -ShowOriginalProgress -BacpacFile C:\Bacpacs\db_dev_1.bacpac
