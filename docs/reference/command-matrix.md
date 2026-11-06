<!-- Based on 6 November 2026 report. Historic observations are not current verification. -->

# Appendix A. Command Reference Matrix

The following quick reference complements the detailed explanations in Chapters 4–11. It is intended for repeatable
verification, not for indiscriminate execution of every command on every VM.
 Command   Purpose / reason   Platform
 hostnamectl / ip -br address   Confirm identity and assigned VMware subnet.   SOC01 Ubuntu
 ip route / ping -c 4 HOST   Test routing and basic reachability.   SOC01 Ubuntu
 free -h / df -h / lsblk   Rule out memory and filesystem constraints.   SOC01 Ubuntu
 systemctl --failed   Find failed services quickly.   SOC01 Ubuntu
 systemctl status SERVICE   Check current systemd unit and latest messages.   SOC01 Ubuntu
 journalctl -u wazuh-manager   Diagnose startup/service errors by timestamp.   SOC01 Ubuntu
   Find manager component messages beyond
 tail /var/ossec/logs/ossec.log   SOC01 Ubuntu
   systemd.
 ss -tulnp   Check which ports are genuinely listening.   SOC01 Ubuntu
 docker ps -a / docker logs   Check Docker lifecycle and errors.   SOC01 Ubuntu
 docker port / docker inspect   Verify mapped ports instead of assuming URLs.   SOC01 Ubuntu
 Get-Service WazuhSvc   Verify the Windows agent is running.   WIN01 PowerShell
 Test-NetConnection HOST -Port 1514   Validate manager TCP reachability.   WIN01 PowerShell
 Get-WinEvent Sysmon Operational   Confirm native process and connection telemetry.   WIN01 PowerShell
   Confirm audit policy before testing Windows logon
 auditpol /get /subcategory:"Logon"   WIN01 PowerShell
   failures.
 Get-WinEvent Security ID 4625   Retrieve source evidence for failed logon attempts.   WIN01 PowerShell
   Inventory packages; does not preserve runtime
 dpkg-query -W   SOC01 Ubuntu
   state.
