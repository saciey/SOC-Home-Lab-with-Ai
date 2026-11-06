<!-- Adapted from SOC Home Lab technical report, 6 November 2026. Historic observations are not current verification. -->

# 8. Grafana and OpenSearch Visualization
## 8.1 Implemented concept
Grafana was deployed on the SOC server using Docker and accessed on TCP 3000. An OpenSearch-compatible
datasource was connected to Wazuh alert indices. Historical verification included successful index/time-field checks
and actual alert records from the Windows endpoint. The record does not establish that every planned dashboard
panel was completed.

## 8.2 Confirm Grafana is running
   sudo docker ps -a | grep -i grafana
**Why we use it:** Finds the Grafana container, its status and port mapping. This is the fastest distinction between a
stopped container and a web-browser network issue.
**Expected evidence:** A Grafana container status such as `Up` and a `3000` port publication.

## 8.3 View Grafana logs
   sudo docker logs --tail 100 grafana
**Why we use it:** Checks initialization, datasource plugin errors and permission problems. We use container logs rather
than guessing from a white or unreachable web page.
**Expected evidence:** No fatal startup errors; Grafana reports its HTTP listener.

## 8.4 Verify the web listener
   sudo ss -ltnp | grep ":3000"
**Why we use it:** Confirms whether something on SOC01 owns or publishes TCP 3000. Helpful after Docker restarts or
conflicts.
**Expected evidence:** A host listener or Docker proxy on port 3000.

## 8.5 Check the indexer locally (authenticated method to be configured)
   sudo systemctl status wazuh-indexer --no-pager
   sudo ss -ltnp | grep ":9200"
**Why we use it:** Identifies whether the backend serving Grafana queries is healthy before changing Grafana settings.
A dead Indexer cannot be fixed by refreshing a dashboard panel.
**Expected evidence:** Indexer active and listening on its configured interface.
Typical datasource parameters included an index pattern such as `wazuh-alerts-4.x-*` and a time field `timestamp`.
Use the exact index name and field returned by the current Indexer rather than assuming an old pattern remains valid.
Access requires properly configured TLS and a read-only account.
   DOCKER NETWORKING PITFALL For Grafana inside a Docker bridge network, `https://localhost:9200` points to the
   Grafana container itself, not necessarily the Ubuntu Wazuh Indexer. Use a deliberately configured reachable
   address/network route or host networking where justified, then apply TLS verification and firewall restrictions.

## 8.6 Suggested dashboard panels (not all proven completed)
- Number of security alerts over time, separated by severity and endpoint.
- Top Wazuh rules and detection categories for WIN01.
- Windows authentication failures, process execution and selected Sysmon categories.
- Asset inventory or device-presence trend from NetAlertX if a supported API/data pipeline is deliberately built.
- Investigation drill-down showing timestamp, rule ID, agent, source event and analyst notes.
