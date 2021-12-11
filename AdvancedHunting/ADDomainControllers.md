# Active Directory - Domain Controllers

Use below queries to identify Active Directory domain controllers

---

## Query

```Kusto
// Domain controllers
DeviceNetworkEvents
| where LocalPort == "88"
| distinct DeviceId
| extend Type = "DomainController"
| join (DeviceInfo
| where isnotempty( OSBuild) 
| summarize  arg_max(Timestamp,*) by DeviceId, OSBuild)
on $left.DeviceId == $right.DeviceId
| project DeviceName, Type, OSBuild, OSPlatform, OSVersion, OSArchitecture, PublicIP
```

```Kusto
// Domain controllers inbound traffic
let escludeprocesses = dynamic(['lsass.exe','svchost.exe','System','dns.exe','dfsrs.exe']);
let lookback = 4h;
let DomainControllerComputers = DeviceNetworkEvents
| where LocalPort == "88"
| distinct DeviceId
| extend Type = "DomainController"
| join (DeviceInfo
| where isnotempty( OSBuild) 
| summarize  arg_max(Timestamp,*) by DeviceId, OSBuild)
on $left.DeviceId == $right.DeviceId
| project DeviceId, DeviceName, Type, OSBuild, OSPlatform, OSVersion, OSArchitecture, PublicIP;
DeviceNetworkEvents
| where Timestamp > ago (lookback)
| where DeviceId in (DomainControllerComputers)
| where ActionType == "InboundConnectionAccepted"
| summarize count() by RemotePort, ActionType, InitiatingProcessFileName 
| where InitiatingProcessFileName !in (escludeprocesses)
```



## Category

This query can be used to detect the following attack techniques and tactics ([see MITRE ATT&CK framework](https://attack.mitre.org/)) or security configuration states.

| Technique, tactic, or state | Covered? (v=yes) | Notes |
|-|-|-|
| Initial access |  |  |
| Execution |  |  |
| Persistence |  |  |
| Privilege escalation | |  |
| Defense evasion |  | |
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