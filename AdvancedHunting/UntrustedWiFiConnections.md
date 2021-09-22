# Network - Untrusted Wifi Connections

Use the below query to identify untrusted Wi-Fi connections

---

## Query

```Kusto
// 'UntrustedWifiConnection'
DeviceEvents
| where ActionType == 'UntrustedWifiConnection'
| extend data = parse_json(AdditionalFields)
| extend AuthenticationMethod = tostring(data.AuthenticationMethod)
| extend WifiConnectionMode = tostring(data.WifiConnectionMode)
| extend IsVulnerableToSpoofing = tostring(data.IsVulnerableToSpoofing)
| extend WifiNetworkName = tostring(data.WifiNetworkName)
| project Timestamp, DeviceName, WifiNetworkName, AuthenticationMethod,WifiConnectionMode,IsVulnerableToSpoofing
| distinct WifiNetworkName, AuthenticationMethod,WifiConnectionMode,IsVulnerableToSpoofing
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

**Contributor:** Alex Verboo