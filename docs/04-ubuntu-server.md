<!-- Adapted from SOC Home Lab technical report, 6 November 2026. Historic observations are not current verification. -->

# 4. Ubuntu Server Preparation and Network Verification
These are the repeatable commands used or recommended when preparing SOC01. They help confirm the server
identity, address, routing, resources and listening ports before any troubleshooting starts. Run Ubuntu commands in a
Bash shell on SOC01.

## 4.1 Identify the Ubuntu machine
   hostnamectl
**Why we use it:** Shows the OS, hostname and kernel. We use it to avoid applying changes to the wrong VM when
multiple server snapshots exist.
**Expected evidence:** Hostname should identify SOC01 and the operating system should match the intended server.

## 4.2 Show interface IP addresses
   ip -br address
**Why we use it:** Displays interfaces in a compact format, making it easier to confirm VMware NAT assignments without
reading a long `ip a` output.
**Expected evidence:** The expected SOC01 private address was 192.168.39.10, but live output is authoritative.

## 4.3 Check network routes
   ip route
**Why we use it:** Reveals the default gateway and on-link route for 192.168.39.0/24. A correct local IP with an incorrect
route can still prevent agent connections or software updates.
**Expected evidence:** A valid on-link route for the lab subnet and, when required, a default route.

## 4.4 Test local reachability
   ping -c 4 192.168.39.138
**Why we use it:** Checks basic ICMP connectivity from SOC01 to the previously observed WIN01 address. It is a first-
layer diagnostic, not a test of Wazuh itself.
**Expected evidence:** Replies if the endpoint is powered on and its firewall permits ICMP. No reply alone does not
establish that Wazuh is broken.
**Important:** WIN01 might currently have a different DHCP address, such as .130.

## 4.5 Check memory capacity
   free -h
**Why we use it:** Reports free, used, buffered and swap memory. Wazuh Indexer can be memory-intensive on a host
that has only 16 GB for all VMs.
**Expected evidence:** Enough available memory to run the current services without sustained exhaustion.

## 4.6 Check storage and partitions
   df -h
   lsblk
**Why we use it:** `df -h` shows filesystem usage and free space; `lsblk` shows block devices, partitions and LVM
relationships. This prevents confusing available VM disk capacity with space actually mounted at `/`.
**Expected evidence:** Mounted root filesystem has adequate free storage and expected LVM layout.

## 4.7 Check listeners and process owners
   sudo ss -tulnp
**Why we use it:** Shows TCP/UDP listening sockets and owning processes. We use it to determine whether dashboard,
enrollment, Indexer or Docker services actually bind to the expected ports.
**Expected evidence:** Listening ports such as 443, 1514, 1515, 9200, 3000 and 20211 only when their services are
running.

## 4.8 Check failed units
   systemctl --failed
**Why we use it:** Lists failed systemd services and provides a quick health snapshot before investigation.
**Expected evidence:** No critical Wazuh units in a failed state. Historical Oct 24 results were not healthy.
