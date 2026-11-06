<!-- Adapted from SOC Home Lab technical report, 6 November 2026. Historic observations are not current verification. -->

# 6. Windows Wazuh Agent and Sysmon Telemetry
## 6.1 Agent registration and health
The Windows VM used the Wazuh Agent to forward Windows events to SOC01. Existing project records show that
alert data from the endpoint reached Wazuh during earlier tests. WIN01 was a project label; one historical dashboard
used an alternate endpoint label. Confirm the actual enrolled agent ID and hostname before final screenshots.

## 6.2 Check Windows agent service
   Get-Service -Name WazuhSvc
**Why we use it:** PowerShell displays the service state without opening Services.msc. This helps distinguish an offline
agent from a network or server problem.
**Expected evidence:** `Running` is expected when the agent is operational.

## 6.3 Check manager connection and enrollment ports
   Test-NetConnection 192.168.39.10 -Port 1514
   Test-NetConnection 192.168.39.10 -Port 1515
**Why we use it:** Checks whether WIN01 can establish a TCP connection to the manager and registration listeners. We
use two tests because a device might reach the manager but fail at enrollment.
**Expected evidence:** `TcpTestSucceeded : True` when the corresponding listener is running and allowed.
**Important:** Enrollment on 1515 may not need to remain open for an already enrolled agent.

## 6.4 Confirm the active Wazuh transport
   Get-NetTCPConnection -RemotePort 1514 -ErrorAction SilentlyContinue
**Why we use it:** Displays established or attempted TCP sessions, helping confirm that the agent is actually connected,
rather than merely seeing a reachable port.
**Expected evidence:** An `Established` entry to SOC01 when the agent is connected.

## 6.5 Review the Windows agent log
   Get-Content "C:\Program Files (x86)\ossec-agent\ossec.log" -Tail 80
**Why we use it:** Reads the newest agent diagnostics for registration, connection, parsing or restart errors. `-Tail`
focuses on recent lines to avoid an oversized transcript.
**Expected evidence:** Agent log lines identify the manager address and connectivity state.
**Important:** If the agent was installed in a custom directory, adjust the path accordingly.

## 6.6 Sysmon deployment and event collection
Sysmon v15.21 was used to enrich native Windows logs with detailed process metadata. Its exact configuration XML
from the historic endpoint is not available in the reviewed evidence, so the example below illustrates the installation
syntax and must not be mistaken for a saved configuration.

## 6.7 Install Sysmon using the corrected policy filename
   .\Sysmon64.exe -accepteula -i .\sysmonconfig-export.xml
**Why we use it:** The recorded Windows PowerShell equivalent was `.\Sysmon64.exe -accepteula -i .\sysmonconfig-
export.xml`. `-i` installs Sysmon using an existing XML policy; `-accepteula` accepts Sysinternals terms. The filename
matters because an earlier attempt referred to the wrong XML file.
**Expected evidence:** The corrected historical command succeeded and later Event IDs 1 and 3 appeared.
**Important:** Run in PowerShell from the directory containing both files, and verify policy content before applying it.

## 6.8 Query Sysmon process and network events
   Get-WinEvent -FilterHashtable @{
   LogName="Microsoft-Windows-Sysmon/Operational"; Id=1,3
   } -MaxEvents 15 | Select-Object TimeCreated,Id,Message
**Why we use it:** `Get-WinEvent` retrieves structured Windows event records. Event ID 1 covers process creation, and
ID 3 covers network connections where enabled; the pipeline selects evidence useful for alert validation.
**Expected evidence:** Recent events show timestamps, process details and/or connection metadata.
**Important:** Absence of ID 3 does not necessarily mean no network traffic occurred: filtering rules or event enablement matter.


## 6.9 Verify the Wazuh Windows Event Channel configuration (example)
   <localfile>
   <location>Microsoft-Windows-Sysmon/Operational</location>
   <log_format>eventchannel</log_format>
   </localfile>
**Why we use it:** This XML block belongs in the Wazuh Agent configuration and tells the agent which Windows Event
Channel to read. `eventchannel` preserves event fields for downstream Wazuh rules.
**Expected evidence:** The agent is restarted after config changes and relevant events arrive in Wazuh.
**Important:** Example only: preserve the existing ossec.conf and validate XML before restarting.

## 6.10 Restart the Windows agent after a valid edit
   Restart-Service -Name WazuhSvc
**Why we use it:** Reloads agent configuration so changes to log collection take effect. It does not fix errors in invalid
XML or an unavailable manager.
**Expected evidence:** The service returns to Running and recent events reach SOC01.
**Important:** Do this after backing up and validating the agent configuration.

## 6.11 What was historically detected
 Telemetry or rule   Interpretation   Evidence confidence
   Process-creation event, including executable/command-
 Sysmon Event ID 1   Historically observed.
   line context when available.
   Connection metadata from Windows processes when
 Sysmon Event ID 3   Historically observed.
   enabled.
   A suspicious PowerShell-related alert observed in a prior   Historically observed; do not
 Wazuh rule 92057
   lab demonstration.   equate with compromise.
   A high-level alert associated with suspicious executable   Historically observed; verify exact
 Wazuh rule 92213
   creation in a previous session.   description from current ruleset.
