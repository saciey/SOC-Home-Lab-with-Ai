<!-- Adapted from SOC Home Lab technical report, 6 November 2026. Historic observations are not current verification. -->

# 3. Lab Inventory and Network Architecture
## 3.1 Environment and system roles
 System   OS / tools   Historical address   Primary function
   Windows; VMware; 16 GB RAM; initially ~346   Host adapter /
 Host laptop   Runs the isolated training VMs.
   GB free storage   VMnet8
   Ubuntu Server 24.04 LTS; Wazuh 4.14.7,
   Central security monitoring and
 SOC01   Filebeat, Indexer, Dashboard, Grafana,   192.168.39.10
   visualization.
   NetAlertX
   Windows 11; Wazuh Agent and Sysmon   192.168.39.130, later
 WIN01   Generates endpoint telemetry.
   v15.21   .138
   192.168.39.128 on a   Controlled traffic and investigation
 KALI01   Kali Linux
   recorded date   exercises.

A few early sessions involved another server subnet and address. IPs in this report refer to the later 192.168.39.x build,
but DHCP assignments may change unless reservations/static addressing are configured. Do not conclude that `.130`
and `.138` are simultaneously active WIN01 interfaces.

## 3.2 Logical architecture
*Figure: Historic topology and event pipeline; the planned AI integration is intentionally outside the implemented core.*


## 3.3 Data flow and component boundaries
- Sysmon records selected Windows process, network, file or registry events based on its active configuration.
- The Windows Wazuh Agent reads configured Windows Event Channels and forwards records to SOC01 on its
   manager communication channel.
- Wazuh Manager decodes events and evaluates rules; Filebeat forwards alert records into the Wazuh Indexer.
- Wazuh Dashboard exposes searching and investigation. Grafana can query an OpenSearch-compatible index with
   suitable read permissions.
- NetAlertX tracks local network assets and may detect a newly visible device, but it is not a packet-capture engine
   or an endpoint EDR replacement.
- Kali Linux produces controlled activity within the authorized home lab; its presence does not demonstrate all
   requested attack detections automatically.

## 3.4 Service and port map
   Protocol / endpoint   Purpose   What success means
   TCP 1514 to SOC01   Wazuh agent events   Agent can establish communication with manager.
   TCP 1515 to SOC01   Wazuh agent enrollment   Enrollment listener is available when needed.
   TCP 443 to SOC01   Wazuh Dashboard   HTTPS web interface loads.
   TCP 9200 (usually restricted)   Indexer API   Indexer answers authenticated HTTPS requests.
   TCP 55000 (usually restricted)   Wazuh REST API   API available to approved internal services.
   TCP 3000 to SOC01   Grafana UI   Grafana container/service responds.
   The mapped web port responds in the current container
   TCP 20211 to SOC01   NetAlertX web UI (historical)
   setup.

   NETWORK SECURITY Do not expose Wazuh Indexer or administrative API ports to the public Internet. A Docker
   container also does not automatically share the Ubuntu host’s localhost network namespace.
