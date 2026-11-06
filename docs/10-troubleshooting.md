<!-- Based on 6 November 2026 report. Historic observations are not current verification. -->

# 10. Troubleshooting and Historical Failures
## 10.1 Major incident: Wazuh Manager startup failure on 24 October 2026
This is the best-documented problem in the project. Repeated attempts to start `wazuh-manager.service` failed. The
retrieved journal includes startup operation timeouts, lingering child-process messages, and a later explicit lock conflict.
The manager’s own logs also show partial initialization of components before the service returned an error. A warning
about Starlette/connexion appeared, but the available evidence does not prove it caused the failure.
 Observed message   Technical interpretation   Confirmed vs possible
   systemd did not observe a successful
 “start operation timed out. Terminating.”   Confirmed from Oct 24 journal.
   service start within the configured timeout.
 “Unit process ... remains running after unit   The failed start may leave processes behind    Confirmed in journal; exact state
 stopped”   and complicate later attempts.   must be checked live.
 “ERROR: Another instance is locking this   A start script detected its lock; another
   Confirmed in late Oct 24 logs.
 process.”   running or stale instance must be ruled out.
   Confirmed log path; removing it
   Path identified by Wazuh as the startup lock
 “... /var/ossec/var/start-script-lock”   without process checks is
   file.
   unsafe.
   Observed warning; not proven
 “StarletteDeprecationWarning”   A Python dependency API is deprecated.
   root cause.


## 10.2 What we actually tried
## 10.3 Reload systemd configuration
   sudo systemctl daemon-reload
**Why we use it:** Re-reads systemd unit files and override drop-ins after an edit. This is required when the startup
timeout is changed outside `systemctl edit`.
**Expected evidence:** New unit values become visible through `systemctl show`.

## 10.4 Verify the timeout change
   systemctl show wazuh-manager -p TimeoutStartUSec
**Why we use it:** Shows the effective startup timeout calculated by systemd rather than what someone thinks they
edited. The historical output was `TimeoutStartUSec=5min`.
**Expected evidence:** A five-minute timeout was confirmed in the captured session.

## 10.5 Clear unit failed state and retry (historical attempt)
   sudo systemctl reset-failed wazuh-manager
   sudo systemctl start wazuh-manager
**Why we use it:** `reset-failed` clears systemd’s failure counters/state, while `start` attempts to launch the manager
again. This was tried after increasing the timeout.
**Expected evidence:** The historical retry did not succeed; it returned an error stating the control process exited.
**Important:** This is not evidence that extending the timeout fixed the underlying issue.


## 10.6 Safe diagnostic workflow (recommended; not claimed executed)
## 10.7 Freeze evidence before making changes
   sudo systemctl status wazuh-manager --no-pager -l
   sudo journalctl -u wazuh-manager -n 160 --no-pager -l
   sudo tail -n 120 /var/ossec/logs/ossec.log
**Why we use it:** Captures systemd state and both system and application log layers before another retry overwrites the
most useful context. Start with observation rather than deletion.
**Expected evidence:** A time-ordered picture of the failure reason, including timeout and lock messages.

## 10.8 Check whether Wazuh processes remain alive
   ps -ef | grep -E "[w]azuh|[o]ssec"
   sudo systemctl show wazuh-manager -p MainPID -p ActiveState -p SubState


**Why we use it:** Determines whether there is a real instance still running. It is unsafe to remove a startup lock while
another manager process remains active.
**Expected evidence:** A coherent set of PID/service observations explaining whether the lock may be legitimate.

## 10.9 Inspect the lock without changing it
   sudo ls -l /var/ossec/var/start-script-lock
   sudo fuser -v /var/ossec/var/start-script-lock
**Why we use it:** Checks whether the lock exists and whether any process holds it. This step separates a stale artifact
from an in-use synchronization mechanism.
**Expected evidence:** Information for a cautious decision; lack of `fuser` output alone is not sufficient proof that all
Wazuh processes stopped.
**Important:** Install or locate `fuser` only if available; do not alter package state during emergency triage unless needed.

## 10.10 Safely stop the manager before a recovery decision
   sudo systemctl stop wazuh-manager
   sudo systemctl status wazuh-manager --no-pager -l
**Why we use it:** Requests an orderly service stop and checks its outcome. A controlled stop is preferable to
immediately killing processes or deleting lock files.
**Expected evidence:** Service should no longer be active and no relevant Wazuh processes should remain; verify with
the process checks above.

## 10.11 Quarantine a proven stale lock (CONDITIONAL, NOT historical)
   sudo mv /var/ossec/var/start-script-lock /var/ossec/var/start-script-lock.stale-$(date +%Y%m%d-%H%M%S)
**Why we use it:** Renames the lock rather than deleting it so the artifact can be investigated or restored. This action is
appropriate ONLY after confirming no manager/startup process is using it and after taking a backup/snapshot.
**Expected evidence:** If the lock was stale, a later clean start might proceed beyond that specific conflict.
**Important:** Do NOT run when the manager is active or process checks are inconclusive; this is an escalation step, not a generic fix.

## 10.12 Retry and verify full pipeline (CONDITIONAL)
   sudo systemctl reset-failed wazuh-manager
   sudo systemctl start wazuh-manager
   sudo systemctl is-active wazuh-manager
   sudo journalctl -u wazuh-manager -n 50 --no-pager
**Why we use it:** After the cause has been addressed, restarts the service and checks both its immediate state and
actual logs. A successful `start` exit is still not enough to prove full functionality.
**Expected evidence:** `active` state plus no new critical manager errors, followed by a newly generated test event
reaching Wazuh.

## 10.13 Correct method for editing the startup timeout
## 10.14 Use systemctl to create an override (recommended)
   sudo systemctl edit wazuh-manager
**Why we use it:** Opens a drop-in override in the correct systemd unit directory and reduces the risk of creating a typo
in the unit path. Add the stanza shown below only when timeout adjustment is justified.
**Expected evidence:** The override is saved and recognized after a daemon reload.

## 10.15 Example override contents
   [Service]
   TimeoutStartSec=300
**Why we use it:** Extends the startup grace period to 300 seconds so a slow but healthy manager has enough time to
initialize. This was the intent of the historical attempt.
**Expected evidence:** `systemctl show wazuh-manager -p TimeoutStartUSec` displays five minutes.
**Important:** A longer timeout does not cure stale locks, invalid configuration, disk failure or a crashed process.
 INCIDENT CONCLUSION The evidence supports a STARTUP FAILURE with at least two observed failure signatures:
 timeout and lock conflict. It does not support a claim of permanent repair. Final closure needs a new `active` status and an
 end-to-end alert produced after the recovery.


## 10.16 Additional historical mistakes and what they taught us
Besides the 24 October manager incident, several earlier configuration or interpretation problems were documented in
August 2026. These examples are included because they show practical SOC engineering skills: distinguishing path
errors, terminal syntax, UI state and actual service health.
 Date / incident   Observed issue   What was learned
   Verify file existence and actual name before
 19 Aug — Sysmon XML   `Failed to open xml configuration: .
   installation; the corrected `sysmonconfig-
 file not found   \sysmonconfig.xml` after a filename mismatch.
   export.xml` path worked.
   A connectivity command was entered in Windows
   Use PowerShell for PowerShell cmdlets and
 19 Aug — Wrong shell /   CMD using `Test-NetConnection` and the literal
   replace angle-bracket placeholders with a real
 placeholder syntax   placeholder `<IP-SOC01>`; an error said the
   IP.
   file/path could not be found.
   A discovery database can retain last-seen/new
 22 Aug — Device still   NetAlertX continued to show Kali in the “New”
   classifications; it is not proof the host is online at
 green “New”   state after that VM was shut down.
   that moment.
   `ss -lntp | grep ":3000"` returned no listener before
 22 Aug — Port 3000   An empty listener check can be a successful
   Grafana deployment; NetAlertX container was
 preflight   free-port verification, not necessarily an error.
   healthy.


## 10.17 Confirm the XML filename before Sysmon installation
   Get-ChildItem .\sysmonconfig*.xml
**Why we use it:** Lists matching XML configuration files in the current PowerShell directory. This prevents passing a
filename that does not exist to Sysmon.
**Expected evidence:** The real XML filename is visible; the successful historical file was `sysmonconfig-export.xml`.

## 10.18 Use the correct Sysmon command (historically successful)
   .\Sysmon64.exe -accepteula -i .\sysmonconfig-export.xml
**Why we use it:** The `.\` prefix tells PowerShell to execute a file from the current directory. The `-i` argument points to
the actual XML configuration instead of the nonexistent `sysmonconfig.xml`.
**Expected evidence:** Installation succeeded and Sysmon Event IDs 1 and 3 were later observed.
**Important:** Do not use this reinstall command routinely when Sysmon is already running; inspect the existing configuration first.

## 10.19 Run connection tests in PowerShell, without placeholders
   Test-NetConnection 192.168.39.10 -Port 1514
**Why we use it:** `Test-NetConnection` is a PowerShell cmdlet, not an ordinary CMD executable. Replacing `<IP-
SOC01>` with 192.168.39.10 avoids Windows interpreting angle brackets as shell redirection syntax.
**Expected evidence:** The cmdlet reports TCP reachability or a meaningful network failure.
**Important:** The historical CMD error was a command-entry error; a successful TCP test result was not captured for that exact
attempt.
For NetAlertX, compare the asset’s last-seen timestamp with a fresh scan and a direct connectivity check. A green
“New” badge is a classification in the application, not a real-time guarantee of power state. The Grafana port-3000
check was intentionally run before deployment: no listener meant the port was available at that moment.

## 10.20 Other investigation playbooks: symptoms, not historically confirmed incidents
 Symptom   Check first   Why
   `systemctl status wazuh-dashboard`; `ss -ltnp |   Differentiate stopped web UI from failed
 Wazuh dashboard fails to open
   grep :443`   agent/manager.
   `Get-Service WazuhSvc`; `Test-NetConnection ...   Separate Windows service failure from
 Agent looks inactive
   -Port 1514`   TCP reachability.
   `Get-WinEvent` from Sysmon channel; inspect   Establish whether source telemetry
 No new Windows Sysmon events
   actual XML policy   exists before blaming Wazuh.
   Indexer service, datasource URL, TLS, index   Dashboards depend on storage and the
 Grafana returns no data
   pattern and time range   correct time field.
   Container may be stopped or published
 Docker web UI unavailable   `docker ps -a`, `docker logs`, `docker port`
   at a different port.
 Device IP changes between   `ipconfig /all`, DHCP lease and NetAlertX MAC   DHCP can reassign `.130`/`.138` while
 sessions   inventory   the same device remains enrolled.


## 10.21 Troubleshooting discipline
Recommended sequence: observe and timestamp → identify failing layer → verify from source to destination → make
one minimal reversible change → rerun the same test → record before/after results. Avoid simultaneous changes to
the Wazuh Manager, Docker networking and Windows Agent because that removes the ability to identify the real
cause.
