#"C:\agent_path"
$agent_path=$args[0] 
# "C:\startup_agent
$startup_scripts_path=$args[1]
# path of group policy scripts.ini
# "C:\Windows\System32\GroupPolicy\Machine\Scripts\scripts.ini"
$policy_script_path=$args[2]
# powershell path "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"
$powershell_path=$args[3]

##########################################################################################################
# DF365.TOOLS FRESH INSTALL

# Check if d365fo.tools is installed to eventually delete it and do a fresh install with the packages
if (Get-Module -ListAvailable -Name d365fo.tools) {
    Uninstall-Module d365fo.tools -Force -Verbose
} 
Import-Module -Name PowerShellGet -Force
Import-Module -Name PackageManagement -Force
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.208 -Force
Install-Module -Name d365fo.tools -Force
Invoke-D365InstallSqlPackage 
Set-ExecutionPolicy Unrestricted
Invoke-D365InstallAzCopy

##########################################################################################################
# CREATE THE SCRIPT THAT RUNS THE ANGENT IN ADMIN PRIBVILEGIES

#Delete directory and start_agent.ps1 if it exist else create the directory
if(Test-Path $startup_scripts_path){
    Remove-Item $startup_scripts_path
    if(Test-Path "${startup_scripts_path}\start_agent.ps1"){
        Remove-Item "${startup_scripts_path}\start_agent.ps1"
    }
}
else{
    New-Item "$startup_scripts_path" -itemType Directory
}

# Create start_agent.ps1
New-Item "$startup_scripts_path\start_agent.ps1"
# Write comand on start_agent to open it in administrator privileges
Set-Content "$startup_scripts_path\start_agent.ps1" "powershell -Command `"Start-Process powershell -ArgumentList 'C:\windows\system32\cmd.exe /D /S /C start ${agent_path}\run.cmd --startuptype autostartup' -Verb RunAs`""

##########################################################################################################
# SET THE PS1 THAT RUN THE AGENT IN PRIVILEGIES MODE TO RUN AD SYSTEM STARTUP

# Set start_agent.ps1 to autorun on vm startup modifying group policies
Set-Content $policy_script_path " "
Add-Content $policy_script_path " "
Add-Content $policy_script_path "[Startup]"
Add-Content $policy_script_path "0CmdLine=$powershell_path"
Add-Content $policy_script_path "0Parameters=-file ${startup_scripts_path}\start_agent.ps1"
