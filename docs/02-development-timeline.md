<!-- Adapted from SOC Home Lab technical report, 6 November 2026. Historic observations are not current verification. -->

# 2. Evidence Basis and Development Timeline
## 2.1 Documentation approach
The report distinguishes direct execution history (terminal commands and reported outputs), historical screenshots and
discussions, and future procedures written for testing. Private IP addresses, hostnames and version numbers are
included as technical identifiers only. Any output labelled “expected” is not a claim that a test passed.
 Period   Milestone   Evidence / qualification
   Ubuntu and Wazuh all-in-one preparation; original
   Initial server work, architecture planning, resource
 12–18 Aug 2026   network at an earlier stage; revised three-VM
   constraints.
   topology was selected.
   Windows agent and Sysmon event pipeline;
   Historically observed endpoint events, alerts, device
 19–22 Aug 2026   NetAlertX discovery; Grafana Docker deployment
   discovery and data-source access.
   and Wazuh query integration.
   SOC analyst workflow, detection analysis and   Supporting skills and documentation work; not all
 Sep 2026
   academic demonstration plans.   scenario results verified.
   Manager startup failures, inspection of Ubuntu
   Service timeout and lock evidence. VM merging was
 24 Oct 2026   services/Docker, options for exporting and
   considered, not executed.
   combining labs.
   Structured incident-simulation instructions,   Several later scenarios remain expected-outcome
 1–6 Nov 2026
   academic report and detailed English edition.   procedures pending new screenshots.

## 2.2 Key distinction between an implementation guide and the actual deployment
An earlier “End-to-End Wazuh, NetAlertX, Grafana, Airia Guide” used example addresses 192.168.0.40 and
192.168.0.50 and described an Airia integration design. The actual VMware lab later used 192.168.39.0/24, with
SOC01 normally at 192.168.39.10. The guide supplies ideas, but its topology and cloud-integration steps should not be
represented as already executed on SOC01.
