# MDE - Software Inventory - EOS Windows Versions

Use the below query to retrieve an overview of EOS Windows OS versions 

---

## Query

```Kusto
// EOS Windows Versions
DeviceInfo
| where isnotempty(OSPlatform)
| summarize arg_max(Timestamp, *) by DeviceName
| project DeviceId, DeviceName, OSPlatform, OSBuild, OSVersionInfo
| join kind= leftouter (
    DeviceTvmSoftwareInventory
    | where SoftwareName startswith "Windows"
    | where isnotempty(EndOfSupportStatus))
    on $left.DeviceId == $right.DeviceId
| summarize ['Installed on'] = count() by OSPlatform, OSVersion, OSVersionInfo, EndOfSupportStatus, EndOfSupportDate
| sort by EndOfSupportDate, OSPlatform, ['Installed on']
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