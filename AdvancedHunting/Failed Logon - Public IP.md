# Failed logon attempts originating from public IP addresses

Use the below queries to identify failed logon attemps that originate from a public IP.

---

## Query

```Kusto
// check for logons from Public IP
DeviceLogonEvents
| where ActionType == "LogonFailed"
| where RemoteIPType == "Public"
| project Timestamp, DeviceName, ActionType, LogonType,AccountName, FailureReason, Protocol,RemoteIP
```

```Kusto
// check for network events originating from these IPs
let publicips = 
DeviceLogonEvents
| where ActionType == "LogonFailed"
| where RemoteIPType == "Public"
| project Timestamp, DeviceName, ActionType, LogonType, FailureReason, Protocol,RemoteIP
| distinct RemoteIP;
DeviceNetworkEvents
| where LocalPort == 3389
| where RemoteIPType == "Public"
| where RemoteIP  in (publicips)
```


## Category

This query can be used to detect the following attack techniques and tactics ([see MITRE ATT&CK framework](https://attack.mitre.org/)) or security configuration states.

| Technique, tactic, or state | Covered? (v=yes) | Notes |
|-|-|-|
| Initial access | v |  |
| Execution |  |  |
| Persistence |  |  |
| Privilege escalation | |  |
| Defense evasion |  |  |
| Credential Access | v |  |
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