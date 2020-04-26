# Initial Access

## USB

## Attachments

## Links

## Accounts


# Execution

## CMSTP.exe.

## commandline suspicious activities

## compiled html, chm

## control panel files

## PowerShell
https://attack.mitre.org/techniques/T1086/


## scheduled task

Hunt for schedule task creation:
DeviceProcessEvents
| where FileName == "schtasks.exe"
| where ActionType == "ProcessCreated"
| where ProcessCommandLine contains "create"
| project DeviceName,AccountName, InitiatingProcessParentFileName , InitiatingProcessFileName , InitiatingProcessCommandLine , FileName , ProcessCommandLine


# Persistence

## Create account

## hidden files and directory

## new service

# Priv Escalation

## process injecctsions

# Defense evasion

## disabling security tools

## file deletion

## Registry auditing

# Credential access

## account manipulation

## brute force

## input capture

# Discovery

## enumerate files and directory

## enumerate other systems


# lateral movement
## pass the hash

## rdp

# collection

## screen capture

# exfiltration

## compress data

## encrypt data

# command and control


# lolbas detections







# WMI Persistence

https://attack.mitre.org/techniques/T1084/

Alert: A WMI event filter was bound to a suspicious event consumer

Alert Description:

An event consumer represents the action to take upon the firing of an event. Attackers can use the ActiveScriptEventConsumer and CommandLineEventConsumer classes when responding to their events. Both event consumers offer a tremendous amount of flexibility for an attacker to execute any payload they want all without needing to drop a single malicious executable to disk.
Recommended actions:

Find the propagation entry point - check which users were logged on to this machine and which other machines they were observed on to find additional compromised machines.
Gather information - analyze the executed process and if possible block it from running on any machines in the organization.
Analyze logs - analyze all logs from this machine to fully understand what commands were executed, their purpose and impact.

Hunting Query

// List relevant events 30 minutes before and after selected Alert event
let selectedEventTimestamp = datetime(2020-04-26T10:00:59.2099405Z);
search in (DeviceFileEvents, DeviceProcessEvents, DeviceEvents, DeviceRegistryEvents, DeviceNetworkEvents, DeviceImageLoadEvents, DeviceLogonEvents)
    Timestamp between ((selectedEventTimestamp - 30m) .. (selectedEventTimestamp + 30m))
    and DeviceId == "e5c30d8c0607564282e7714750925a7811540fab"
| sort by Timestamp desc
| extend Relevance = iff(Timestamp == selectedEventTimestamp, "Selected event", iff(Timestamp < selectedEventTimestamp, "Earlier event", "Later event"))
| project-reorder Relevance

## living of the land

Alert: Use of living-off-the-land binary to run malicious code

Alert Description:
Attackers attempt to run malicious code undetected by loading the code in the context of common executables. Security researchers refer to this approach and a few other evasive techniques as “living off the land” (LOL) and the common executables as LOL binaries or “LOLBins”.
This alert indicates an anomalous attempt by a parent process to run one of these common executables using suspicious command-line parameters.
Recommended actions:
A. Validate the alert.

Inspect the process as well as the parent process.
Check for other suspicious activities in the machine timeline.
Locate unfamiliar processes in the process tree. Check files for prevalence, their locations, and digital signatures.
Submit relevant files for deep analysis and review file behaviors.
Identify unusual system activity with system owners.
B. Scope the incident. Find related machines, network addresses, and files in the incident graph.

C. Contain and mitigate the breach. Stop suspicious processes, isolate affected machines, decommission compromised accounts or reset passwords, block IP addresses and URLs, and install security updates.

D. Contact your incident response team, or contact Microsoft support for investigation and remediation services.

// List relevant events 30 minutes before and after selected Alert event
let selectedEventTimestamp = datetime(2020-04-26T10:03:24.1831902Z);
search in (DeviceFileEvents, DeviceProcessEvents, DeviceEvents, DeviceRegistryEvents, DeviceNetworkEvents, DeviceImageLoadEvents, DeviceLogonEvents)
    Timestamp between ((selectedEventTimestamp - 30m) .. (selectedEventTimestamp + 30m))
    and DeviceId == "e5c30d8c0607564282e7714750925a7811540fab"
| sort by Timestamp desc
| extend Relevance = iff(Timestamp == selectedEventTimestamp, "Selected event", iff(Timestamp < selectedEventTimestamp, "Earlier event", "Later event"))
| project-reorder Relevance


