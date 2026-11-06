<!-- Based on 6 November 2026 report. Historic observations are not current verification. -->

# Appendix B. Evidence Register and Test Template

ID   Screenshot or output to collect   Required explanation
 EV-01   VMware NAT settings and running VMs   Show network boundary and lab scope.
 EV-02   SOC01 IP, memory and disk check   Timestamped environment baseline.
 EV-03   Wazuh central service status   Show Manager, Indexer, Filebeat and Dashboard.
 EV-04   Windows agent state / Wazuh agent list   Identity, active status and server association.
 EV-05   Sysmon EID 1 and EID 3   Original source event for a known test.
 EV-06   Wazuh alert rule 92057 / 92213   Actual rule, level, agent, time and event context.
 EV-07   Grafana query/data-source panel   Proof of fresh data visible through Indexer.
 EV-08   NetAlertX container and device inventory   Container mapping, discovered IP/MAC.
 EV-09   24 Oct journal error and lock message   Historical troubleshooting transcript.
 EV-10   Successful recovery outputs (if achieved)   New unit status and fresh test alert.
 EV-11   Windows 4625 or future Linux/web scenario   Actual result and comparison with expected outcome.
 EV-12   Future AI evaluation outputs   Do not populate until AI is implemented.


Evidence discipline: use actual VM screenshots, redact credentials, and document date, timezone, host,
command/action, expected result, observed result, technical analysis and final test status. No synthetic screenshots
are included in this report.
