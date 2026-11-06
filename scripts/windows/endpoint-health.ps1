# Read-only educational diagnostics. Historical IP may change.
param([string]$ManagerIP = "192.168.39.10")
Write-Host "Endpoint snapshot: $(Get-Date -Format o)"
Write-Host "Hostname: $env:COMPUTERNAME"
Get-Service WazuhSvc -ErrorAction SilentlyContinue | Format-Table Name, Status
Test-NetConnection -ComputerName $ManagerIP -Port 1514 -InformationLevel Detailed
Get-WinEvent -FilterHashtable @{
    LogName = "Microsoft-Windows-Sysmon/Operational"; Id = 1, 3
} -MaxEvents 10 -ErrorAction SilentlyContinue |
    Select-Object TimeCreated, Id, ProviderName | Format-Table -AutoSize
Write-Host "Compare source events with the Wazuh server to validate ingestion."
