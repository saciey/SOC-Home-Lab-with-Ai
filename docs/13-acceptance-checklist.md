<!-- Based on 6 November 2026 report. Historic observations are not current verification. -->

# 13. Completion Roadmap and Acceptance Criteria
    Priority   Action   Definition of done
   Resolve and document wazuh-manager startup   Fresh `active` status, clean journal and a new endpoint alert
    P0
   failure.   visible in Wazuh.
   Re-check core lab: network, Windows agent,
    P1   Every stage passes with timestamped screenshots.
   Sysmon, Filebeat, Indexer, Dashboard.
   Capture Grafana datasource and NetAlertX
    P1   Current index query and live device inventory captured.
   evidence.
   Execute Windows logon, SSH/web (if targets exist),   Each scenario has expected + actual results, with no
    P2
   FIM and network test matrix.   guessed rule IDs.
   Harden secrets, TLS, snapshots, backups and
    P2   Restore drill documented; credentials not exposed.
   stable addressing.
   Plan any teammate server integration or Linux target
    P3   Architecture and interoperability tests pass before migration.
   expansion.
   Implement AI read-only triage pilot only after core    Human-reviewed accuracy metrics and prompt-injection
    P4
   SOC is stable.   tests documented.


## 13.1 Demo readiness checklist
- Confirm live VM names and IPs from terminal output; update the architecture figure if changed.
- Start Wazuh components and check each unit status before opening the dashboard.
- Generate a known Windows event and capture the same timestamp through Sysmon, Wazuh and Grafana.
- Show NetAlertX detecting at least one current lab asset and verify container mapping.
- Include a screenshot of the October failure, recovery logs if fixed, and a clear lesson learned.
- Explicitly label the AI slide and AI report section as Future Work.
