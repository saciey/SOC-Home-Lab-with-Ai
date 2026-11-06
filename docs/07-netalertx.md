<!-- Adapted from SOC Home Lab technical report, 6 November 2026. Historic observations are not current verification. -->

# 7. NetAlertX Network Asset Discovery
## 7.1 Purpose and scope
NetAlertX runs as a Docker-based network-visibility service. In this lab it was used to identify devices on the VMware
NAT subnet, including a Kali host in an earlier observation. MAC-address and IP changes were useful for
understanding why DHCP changes can make an endpoint appear differently over time. The most commonly recorded
web UI port was 20211; other ports appearing in earlier notes are not assumed to be an API endpoint without container
inspection.

## 7.2 List all containers and mappings
   sudo docker ps -a
**Why we use it:** Shows both running and stopped containers, mapped ports, statuses and container names. `-a` is
important when a dashboard is missing because a failed/stopped container would otherwise be hidden.
**Expected evidence:** Find the NetAlertX container and check its published host port.

## 7.3 Read container logs (replace name as needed)
   sudo docker logs --tail 80 netalertx
**Why we use it:** Reads the latest application logs, helping identify missing database paths, permissions, startup
failures or plugin errors. `--tail` keeps the output manageable.
**Expected evidence:** Recent NetAlertX startup/scanning logs are available.
**Important:** The container might have a different name: find it first using `docker ps -a`.

## 7.4 Inspect the container’s effective mapping
   sudo docker port netalertx
   sudo docker inspect netalertx --format "{{json .NetworkSettings.Ports}}"
**Why we use it:** Shows Docker’s actual port mappings instead of assuming a URL from an old guide. The first
command is human-readable; the second provides structured networking details.
**Expected evidence:** An expected host mapping, typically for the NetAlertX web UI at 20211.

## 7.5 Check Docker network status and persistent data
   sudo docker network ls
   sudo docker volume ls
**Why we use it:** Lists network and volume objects. This matters when planning to transfer NetAlertX to another Ubuntu
VM without losing its stored device inventory.
**Expected evidence:** Named Docker networks and volumes can be identified for documentation or backup.

## 7.6 Open the historical NetAlertX web interface
   http://192.168.39.10:20211
**Why we use it:** Browser URL (not a shell command): the documented host address and port used to access the
network asset inventory.
**Expected evidence:** The login/asset-discovery page loads if the container and mapping are healthy.
**Important:** Use the actual mapped port from `docker ps` if it differs.

## 7.7 Why this tool complements rather than replaces Wazuh
Wazuh emphasizes events and detections from enrolled hosts. NetAlertX emphasizes network presence and device
inventory. Combining both can improve analyst context, but the source records do not prove a single unified
Wazuh/NetAlertX correlation rule or a fully merged Grafana panel for all device data.
