<!-- Adapted from SOC Home Lab technical report, 6 November 2026. Historic observations are not current verification. -->

# 1. Introduction and Objectives
## 1.1 Background and problem statement
A SOC needs consistent visibility into endpoint behaviour, user authentication, process execution and network assets.
Raw events scattered across individual operating systems are difficult to correlate and investigate. This lab reproduces
a simplified SOC workflow in which security events are generated on a Windows endpoint, forwarded to a central
manager, indexed for searching, then examined using dashboards. Network-discovery data adds context about which
devices exist on the private subnet.

## 1.2 Project objectives
- Build a private virtual environment with a centralized SOC server, monitored Windows endpoint and controlled
   testing VM.
- Deploy Wazuh for agent communication, event analysis, alert generation, indexing and a web dashboard.
- Use Sysmon to observe detailed Windows process and network-connection events and route them into Wazuh.
- Introduce NetAlertX for device and network-inventory visibility, and Grafana for SIEM-oriented visualizations.
- Create repeatable validation procedures that show source events, collection, alerting and investigative context.
- Capture real failures and explain how to troubleshoot them, without falsely claiming successful resolution.
- Design a safe read-only AI assistant for a later implementation phase.

## 1.3 Scope boundary
The implemented scope is limited to an educational VMware NAT environment. It is not a commercial 24/7 SOC, does
not claim production-grade redundancy, and does not include a deployed AI analyst. A proposed Linux web-server
extension and consolidation with a teammate’s server remain separate design discussions, rather than proven
completed integrations.
