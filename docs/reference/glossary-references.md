<!-- Based on 6 November 2026 report. Historic observations are not current verification. -->

# Appendix C. Glossary and References

## C.1 Essential terminology
    Term   Definition
   Security Operations Center; the function of monitoring, investigating and responding to security
    SOC
   signals.
    SIEM   Security Information and Event Management: collecting, correlating, searching and alerting on logs.
    Sysmon   Microsoft Sysinternals telemetry service for detailed Windows system events.
    Wazuh Manager   Central rule-analysis and agent-management component.
    Wazuh Indexer   Search and data storage layer for Wazuh alerts.
    Filebeat   Service transporting Wazuh alert records into the Indexer.
    NetAlertX   Network asset-discovery and device-visibility software.
    FIM   File Integrity Monitoring, reporting selected filesystem changes.
    NAT   Network Address Translation; used for the private VMware laboratory network.
    Triage   Initial assessment of an alert’s relevance, severity and required investigation.
    AI enrichment   Future assistance that interprets evidence but does not replace raw logs or analyst judgment.


## C.2 Project history and implementation guide
- User SOC Home Lab discussions and historical terminal evidence, August–November 2026. Primary
   implementation and incident-history source.
- End-to-End Security Monitoring and AI Analysis: Wazuh, NetAlertX, Grafana, and Airia on an IP-based Lab
   Network (reference design, 6 August 2026). Its 192.168.0.x addresses and Airia procedure are not proof of actual
   implementation.
- Project 1 / centralized SIEM academic requirements, referenced in earlier project discussions; Linux web-server
   work is not claimed as completed.

## C.3 Official technical documentation (accessed for this edition)
- Wazuh Quickstart: https://documentation.wazuh.com/current/quickstart.html
- Wazuh Architecture and Ports: https://documentation.wazuh.com/current/getting-started/architecture.html
- Wazuh Agent Connection: https://documentation.wazuh.com/current/user-manual/agent/agent-management/
   agent-connection.html
- Wazuh Agent Enrollment Requirements: https://documentation.wazuh.com/current/user-manual/agent/agent-
   enrollment/requirements.html
- Wazuh Dashboard Troubleshooting: https://documentation.wazuh.com/current/user-manual/wazuh-dashboard/
   troubleshooting.html
- Microsoft Sysinternals Sysmon: https://learn.microsoft.com/en-us/sysinternals/downloads/sysmon
- Grafana OpenSearch Plugin: https://grafana.com/docs/plugins/grafana-opensearch-datasource/latest/
- NetAlertX Documentation: https://docs.netalertx.com/
