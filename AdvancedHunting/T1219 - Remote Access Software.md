# T1219 - Remote Access Software

Use the below queries to identify successfull and failed connection attempts from TeamViewer

---

## Query

```Kusto
// Summarize TeamViewer connections attempts from public IP addresses
DeviceNetworkEvents
| where InitiatingProcessFileName == "TeamViewer_Service.exe"
| where RemoteIPType == "Public"
// | where RemotePort == 80
| summarize Failed = countif(ActionType == 'ConnectionFailed'),Success =  countif(ActionType == 'ConnectionSuccess'), totalip = dcount(RemoteIP ) by DeviceName, RemoteIP
| sort by Failed desc  
```

```Kusto
// Find TeamViewer connections attempts from public IP addresses for specified computer
DeviceNetworkEvents
| where InitiatingProcessFileName == "TeamViewer_Service.exe"
| where RemoteIPType == "Public"
// | where DeviceName == "computer1"
| where RemotePort == 80
| where ActionType == "ConnectionSuccess"
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
| Command and control | v | https://attack.mitre.org/techniques/T1436/ |
| Exfiltration |  |  |
| Impact |  |  |
| Vulnerability |  |  |
| Misconfiguration |  |  |
| Malware, component |  |  |

## See also

## Contributor info

**Contributor:** Alex Verboon
