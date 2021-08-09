# T1046 Network Service Scanning

Adversaries may attempt to get a listing of services running on remote hosts, including those that may be vulnerable to remote software exploitation. Methods to acquire this information include port scans and vulnerability scans using tools that are brought onto a system.

Within cloud environments, adversaries may attempt to discover services running on other cloud hosts. Additionally, if the cloud environment is connected to a on-premises environment, adversaries may be able to identify services running on non-cloud systems as well.

---

## Query


```Kusto
// Find high count of outgoing connection requests on different ports (like when using nmap)
// sudo nmap -F <target server> -v -Pn
let timeinterval = 1s;
DeviceNetworkEvents
| where ActionType == "ConnectionRequest"
| summarize Totalports = dcount(RemotePort), PortDetails = make_set(RemotePort) by DeviceName,RemoteIP ,bin(Timestamp,timeinterval)
| where Totalports > 10
```


```Kusto
// port scanning Alerts
DeviceAlertEvents 
| where Title == "Horizontal port scan initiated" or Title == "Vertical port scanning activity initiated by device"
```

```Kusto
// port scanning Alerts
DeviceAlertEvents 
| where AttackTechniques == @"[""Network Service Scanning (T1046)""]"
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
| Discovery | v | https://attack.mitre.org/techniques/T1046/ |
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