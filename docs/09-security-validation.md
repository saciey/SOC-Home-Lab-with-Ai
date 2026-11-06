<!-- Based on 6 November 2026 report. Historic observations are not current verification. -->

# 9. Security Validation and Test Results
## 9.1 Evidence-driven testing method
A credible SIEM test should show the same event moving across stages: (1) generated on the monitored host, (2)
visible in the source event log, (3) received by an agent/collector, (4) indexed or matched by Wazuh, and (5) retrievable
through the dashboard. A rule firing is an alert, not automatic proof that an attacker succeeded.
 Scenario   Historical outcome   Status
 Windows Sysmon process/network   Process and network event examples were seen; Wazuh
   Historically verified.
 visibility   received endpoint activity.
   Wazuh alerts including IDs 92057 and 92213 were discussed
 Suspicious Windows activity   Historically verified.
   with matching endpoint events.
   Wazuh indices and a valid time field were available in a
 Grafana OpenSearch read   Historically verified.
   successful historic datasource test.
 NetAlertX asset scan   Hosts including Kali were seen within the private network.   Historically verified.
   Procedure prepared;
   Test plan specified Security event 4625 and candidate Wazuh
 Repeated failed Windows logons   latest result not
   rule 60122.
   verified.
   Procedure prepared;
   Rules 5760, 5763 and 40112 were listed as candidate   actual matching
 SSH login failures / brute force
   investigation filters.   depends on
   agent/rules.
   Extension pending
 HTTP 404 / suspicious URL requests   Planned for a Linux web-server or additional web target.
   evidence.
   Not shown operating
 FIM events and AI incident summary   Designed as future acceptance tests before the AI phase.
   end-to-end.


## 9.2 Failed Windows login test: validation procedure
## 9.3 Inspect logon auditing
  auditpol /get /subcategory:"Logon"
**Why we use it:** Checks whether Windows records successful and failed logon activity. Without audit policy, a
deliberately failed login may not create the expected evidence.
**Expected evidence:** The audit setting displays whether Failure events are enabled.

## 9.4 Retrieve Windows security failures
  Get-WinEvent -FilterHashtable @{
    LogName="Security"; Id=4625
  } -MaxEvents 5 | Format-List TimeCreated,Id,Message
**Why we use it:** Requests recent Windows Security Event ID 4625 records, usually representing failed logon attempts.
`Format-List` preserves useful multiline details for reporting.
**Expected evidence:** Timestamped records for the deliberately failed test logons, if auditing and the scenario are
correct.
Then compare the same time period in Wazuh Threat Hunting. Search for the Windows event ID `4625`; if the ruleset
emits rule 60122, document that rule from actual output. Do not assert a fixed Wazuh rule ID without comparing to your
installed rules and event fields.

## 9.5 Linux SSH / web test: requirements and caution
A Linux SSH or HTTP detection exercise needs a monitored Linux/web target and log collection for the relevant
service. The earlier idea of adding WEB01 or combining a teammate’s Linux server is not the same as demonstrating
that the Linux agent and its SSH/Apache logs were integrated. The correct report entry for these cases is “planned until
demonstrated”.

## 9.6 Inspect a Linux SSH log when a Linux target exists
  sudo journalctl -u ssh -n 80 --no-pager
**Why we use it:** Reads SSH daemon activity on a target that actually runs the service. We begin at the source log to
establish whether failed authentication was recorded before looking in Wazuh.
**Expected evidence:** Corresponding authentication log lines for the controlled scenario.


**Important:** On some distributions the unit is `sshd`, or authentication events live in `/var/log/auth.log`.


## 9.7 Test recording template
 Evidence element   Recommended entry
 Test ID / title   Example: T-LOGIN-01 / Windows failed logon
 Time and timezone   Exact local date/time including MYT (+08:00)
 Scope   Source host, destination host, VM network and user authorization
 Command / action   Exact terminal command or GUI action taken
 Expected result   Event ID, Wazuh source field, rule or dashboard query
 Actual result   Literal output/screenshot observed; mark pass or fail
 Analysis   Why the event did/did not appear; relevance to a SOC analyst
 Evidence identifier   EV-xx with file and screenshot name
