<!-- Based on 6 November 2026 report. Historic observations are not current verification. -->

# 11. Security Limitations and Operational Controls
## 11.1 Capacity and architecture constraints
The host computer was described as having 16 GB of RAM. Running Ubuntu Wazuh components, Grafana, NetAlertX,
Windows 11 and Kali simultaneously may produce memory pressure, slow startups or disk I/O contention. However,
resource pressure was not definitively established as the cause of the October manager failure. Hardware values
varied across VM revisions; record the current RAM, vCPU and disk before calling any earlier allocation the final
hardware specification.

## 11.2 Recommended baseline controls
- Keep the lab inside the intended isolated/private VMware network; verify exposure before forwarding ports.
- Use unique service credentials, store secrets outside screenshots and use least-privilege read-only Grafana
   credentials.
- Enable TLS validation where possible; do not normalize `curl -k` or disabled certificate validation as a final
   configuration.
- Back up Wazuh configuration, Indexer snapshots, Docker volumes and VM state separately; a package inventory
   is not a restorable backup.
- Reserve or assign stable IP addresses for SOC01 and monitored endpoints to prevent configuration drift.
- Record time synchronization and timezone so cross-host event correlation is reliable.
- Limit data retention based on available disk and test service restarts before an assessed demonstration.

## 11.3 Exporting or combining lab servers
A later discussion explored merging a teammate’s server build with SOC01 so the project would use fewer VMs. This
was a planning discussion, not a completed migration. Exporting `dpkg-query`, Docker images or config listings is
useful for inventory but does not automatically migrate state, databases, Indexer shards, container volumes, secrets or
service certificates. Any consolidation requires compatibility assessment, a tested backup/restore plan, port conflict
review and post-migration event validation.

## 11.4 Capture a package inventory (not a full backup)
    dpkg-query -W > installed-packages.txt
    sudo docker ps -a > docker-containers.txt
    sudo docker volume ls > docker-volumes.txt
**Why we use it:** Creates text lists of Debian packages and Docker resources so the built environment can be
reconstructed and conflicts identified. Redirection writes output to files on the current machine.
**Expected evidence:** Inventory files exist and can be reviewed alongside a backup plan.
**Important:** These text outputs cannot restore Wazuh databases, certificates, agent keys or NetAlertX state.
