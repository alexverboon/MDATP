# Defender - Detection - Removal and Quarantine actions

Use the below queries to find Windows Defender file removal and quarantine actions
---

## Query

## Malicious file detected and removed during file download scan

```Kusto
DeviceEvents
| where ActionType == @"OtherAlertRelatedActivity"
| project Timestamp, DeviceName, AdditionalFields, FileName, FolderPath, SHA1
| extend event = parse_json(AdditionalFields).Description
| where event contains "removed" and event contains "download scan"
| extend Threat = split(split(event,"removed")[1]," ")[1]
| extend URL = split(event,"from")[1]
| invoke FileProfile(SHA1) 
| project Timestamp, DeviceName, Threat, URL,GlobalPrevalence, FileName, FolderPath, SHA1, event
```

## Malicious file detected and quarantined

```
DeviceEvents
| where ActionType == @"OtherAlertRelatedActivity"
| project Timestamp, DeviceName, AdditionalFields, FileName, FolderPath, SHA1
| extend event = parse_json(AdditionalFields).Description
| where event contains "detected" and event contains "quarantined"
| extend Threat = split(split(event,"quarantined")[1]," ")[1]
/// | extend URL = split(event,"from")[1]
| invoke FileProfile(SHA1) 
| project Timestamp, DeviceName, Threat, GlobalPrevalence, FileName, FolderPath, SHA1, event
```

## Defender detections
```
DeviceEvents
| where ActionType == "AntivirusDetection"
| extend event = parse_json(AdditionalFields)
| extend Threat = event.ThreatName
| extend WasRemediated = event.WasRemediated
| extend Action = event.Action
| extend ReportSource = event.ReportSource
| project Timestamp, DeviceName, event, Threat, WasRemediated, Action, ReportSource, FileName
```



## Category

This query can be used to detect the following attack techniques and tactics ([see MITRE ATT&CK framework](https://attack.mitre.org/)) or security configuration states.

| Technique, tactic, or state | Covered? (v=yes) | Notes |
|-|-|-|
| Initial access |  |  |
| Execution |  |  |
| Persistence |  |  |
| Privilege escalation | |  |
| Defense evasion |  |  |
| Credential Access |  |  |
| Discovery |  |  |
| Lateral movement |  |  |
| Collection |  |  |
| Command and control |  |  |
| Exfiltration |  |  |
| Impact |  |  |
| Vulnerability |  |  |
| Misconfiguration |  |  |
| Malware, component |  |  |

## See also

## Contributor info

**Contributor:** Alex Verboon