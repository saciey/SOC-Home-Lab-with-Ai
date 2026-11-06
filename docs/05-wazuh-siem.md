<!-- Adapted from SOC Home Lab technical report, 6 November 2026. Historic observations are not current verification. -->

# 5. Wazuh SIEM Installation and Service Verification
## 5.1 All-in-one design choice
Wazuh central components were installed on a single Ubuntu VM to fit a home-lab architecture. This reduces VM count
and makes the endpoint-to-manager path easier to demonstrate. It also concentrates CPU, RAM, disk I/O and restart
dependencies on one system, so resource planning is important.

## 5.2 Obtain the Wazuh installation assistant
   curl -sO https://packages.wazuh.com/4.14/wazuh-install.sh
**Why we use it:** `curl` fetches the vendor script; `-O` saves it with its server-provided filename, while `-s` suppresses
progress output. This was the historical installation method for Wazuh 4.14.x.
**Expected evidence:** The script file `wazuh-install.sh` is present on disk.
**Important:** Inspect scripts and use the correct official release before executing software as root.

## 5.3 Install central components (historical initial deployment)
   sudo bash ./wazuh-install.sh -a
**Why we use it:** `sudo` provides required privileges, `bash` runs the installer, and `-a` requests all-in-one installation of
Wazuh server, Indexer and Dashboard. This produces the core SIEM on SOC01.
**Expected evidence:** Installer finishes successfully and prints a dashboard URL and credentials; follow with service
checks.
**Important:** Do NOT rerun the all-in-one install on the existing deployment as a routine fix. It can overwrite certificates or configuration.

## 5.4 Inspect central services
   sudo systemctl status wazuh-manager --no-pager
   sudo systemctl status wazuh-indexer --no-pager
   sudo systemctl status wazuh-dashboard --no-pager
   sudo systemctl status filebeat --no-pager
**Why we use it:** `systemctl status` reports active/failed state and recent log lines; `--no-pager` prints directly to the
terminal or report transcript. Checking each component separately isolates the failed layer.
**Expected evidence:** Each expected component reports `active (running)` in a healthy configuration.
**Important:** `active (running)` for one component does not guarantee the entire ingestion pipeline works.

## 5.5 Confirm Wazuh version and local log
   sudo grep -m 1 -E "Starting Wazuh v|Wazuh v" /var/ossec/logs/ossec.log
   sudo tail -n 80 /var/ossec/logs/ossec.log
**Why we use it:** Checks the manager’s own event log for startup details and subsystem errors. The Oct 24 log
identified Wazuh v4.14.7.
**Expected evidence:** Relevant start/error lines appear; the exact current version must be read from live logs.

## 5.6 Inspect service-specific startup logs
   sudo journalctl -u wazuh-manager -n 100 --no-pager -l
**Why we use it:** Reads the 100 most recent journal records for the manager. `-u` targets the unit, `-n` limits output, `--
no-pager` avoids interactive scrolling, and `-l` prevents truncation of long lines.
**Expected evidence:** Explains why systemd marked a startup attempt failed (timeout, exit code or lock conflict).

## 5.7 Verify the target listening ports
   sudo ss -ltnp | grep -E ":(1514|1515|443|9200|55000)\b"
**Why we use it:** Filters the listener list to Wazuh ports. This distinguishes service availability from browser errors or
misconfigured routing.
**Expected evidence:** Only ports intended to be exposed or bound locally appear.
**Important:** The pipe into grep is a filter; no match may simply mean a listener is absent or the regex is not supported as expected.


## 5.8 Why the Indexer and Filebeat matter
A generated manager alert is not automatically searchable in Grafana: it must reach the storage backend. Filebeat
normally ships Wazuh alert documents to the Indexer, and the Indexer exposes OpenSearch-compatible search APIs.
Therefore, troubleshooting should check manager, Filebeat, Indexer and dashboard separately instead of treating
“Wazuh” as one indivisible service.
