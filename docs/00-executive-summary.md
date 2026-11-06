<!-- Adapted from SOC Home Lab technical report, 6 November 2026. Historic observations are not current verification. -->

# Executive Summary

This report reconstructs the development of a small-scale Security Operations Center (SOC) home lab from
documented conversations, commands, screenshots and observed outputs between August and early November 2026.
The lab was designed to centralize Windows telemetry, evaluate alerts, identify devices on a private network, and
visualize security data. Its primary implementation is based on Ubuntu Server 24.04 LTS, Wazuh 4.14.7, the Windows
Wazuh Agent, Sysmon v15.21, Grafana, and NetAlertX in Docker. Kali Linux was included for controlled simulations.
Historical demonstrations support a functioning data path from Windows Sysmon and the Wazuh Agent into Wazuh,
including recorded events and alerts. Grafana successfully queried Wazuh alert indices in an earlier session, and
NetAlertX detected hosts within the laboratory subnet. These statements describe previously observed operation, not a
live health certification as of this report date.
The most important unresolved incident was observed on 24 October 2026: wazuh-manager repeatedly failed to start.
The logs show both systemd startup timeouts and a later Wazuh start-script lock conflict. A five-minute
TimeoutStartSec adjustment was applied and confirmed, but a subsequent start attempt still failed. No final verified
recovery output was retained in the material reviewed. The report therefore documents observations, probable
implications, safe diagnostic checks, and acceptance criteria instead of inventing a fix.
The project title includes AI as an intended second phase. Airia or another large-language-model-based assistant could
eventually help summarize Wazuh incidents, prioritize investigations and explain next steps. However, no Airia API,
helper service, automated analysis pipeline or autonomous response is represented as implemented.
 Evidence classification   Meaning in this document
   A prior screenshot, command response or technical discussion indicated the feature
 Historically verified
   worked at that time.
   The service or component was previously configured, but has not been revalidated
 Installed / current status unknown
   after later problems.
 Procedure or expected result only   The instruction/test case was designed, but its actual outcome is not established.
 Future enhancement   A proposed capability without an implementation demonstration.

 INTERPRETATION RULE A service that worked in August can still be broken in November. Claims of live availability
 require fresh terminal output, timestamps and screenshot evidence.
