if (Get-Module -ListAvailable -Name d365fo.tools) {
    Set-ExecutionPolicy Unrestricted
} 
else {
    Import-Module -Name PowerShellGet -Force
    Import-Module -Name PackageManagement -Force
    Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.208 -Force
    Install-Module -Name d365fo.tools
    Invoke-D365InstallSqlPackage
    Set-ExecutionPolicy Unrestricted
    Invoke-D365InstallAzCopy
}
