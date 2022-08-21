# Microsoft Defender for Endpoint - TVM - Browser Extensions

Use the below queries to gather Browser Extension information from Microsoft Defender Threat and Vulnerability Management

---

## Query

```Kusto
// All Browser Extension Data
DeviceTvmBrowserExtensions 
| join DeviceTvmBrowserExtensionsKB 
on $left. ExtensionId == $right.ExtensionId
```

```Kusto
// Browser Extension data with ExtensionID and Risk as input for blocking/allowing extensions (GPO/Intune)
DeviceTvmBrowserExtensions
| project ExtensionName, ExtensionDescription, ExtensionId, ExtensionRisk
```

```Kusto
// Total by Browser / Extension Risk
DeviceTvmBrowserExtensions 
| distinct BrowserName, ExtensionName, ExtensionRisk
| summarize count() by BrowserName, ExtensionRisk
```

```Kusto
// Browser Extension by Browser, Extention, Installed vs Activated
DeviceTvmBrowserExtensions 
| summarize TotalDevices=dcount(DeviceId), ExtensionOn = dcountif(DeviceId,IsActivated=="true")  by BrowserName, ExtensionName, ExtensionRisk, ExtensionId
| sort by ExtensionName asc  
// | where ExtensionName contains "Cisco Webex Extension"
```

```Kusto

// All Browser Extension Permissions
DeviceTvmBrowserExtensions 
| join DeviceTvmBrowserExtensionsKB 
on $left. ExtensionId == $right.ExtensionId
| summarize count() by PermissionName, PermissionDescription, PermissionRisk
| sort by PermissionRisk, count_
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