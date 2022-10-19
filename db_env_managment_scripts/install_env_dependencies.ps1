if (Get-Module -ListAvailable -Name d365fo.tools) {
    Set-ExecutionPolicy Unrestricted
} 
else {
    Install-Module -Name d365fo.tools
    Invoke-D365InstallSqlPackage
    Set-ExecutionPolicy Unrestricted
    Invoke-D365InstallAzCopy
}
