# Defender for Identity

Retrieve Devices with NPCAP, WinPcap drivers

---

## Query

```Kusto
// Winpcap - npcap
DeviceTvmSoftwareInventory
| where SoftwareName contains "pcap"
| join ( DeviceTvmSoftwareEvidenceBeta
| where SoftwareName contains "pcap")
on $left.SoftwareName ==  $right.SoftwareName
```

```Kusto
DeviceNetworkEvents
| where LocalPort == "88"
| distinct DeviceId
| join kind=inner (
    DeviceInfo
    | where OSPlatform hasprefix "windowsserver"
    | summarize  arg_max(Timestamp,*) by DeviceId
) on DeviceId
| project Timestamp, DeviceId, OSPlatform, OSVersionInfo
| join kind=leftouter (
    DeviceProcessEvents
    | where FileName =~ "Microsoft.Tri.Sensor.exe"
    | summarize arg_max(Timestamp,*) by DeviceId
    | distinct DeviceId, ProcessVersionInfoProductName, ProcessVersionInfoProductVersion
) on DeviceId
| project-away DeviceId1
| join kind=inner (
    DeviceTvmSoftwareInventory
    | where SoftwareName contains "pcap"
    | distinct DeviceId, SoftwareVendor, SoftwareName, SoftwareVersion
) on DeviceId
| project-away DeviceId1
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
https://docs.microsoft.com/en-us/defender-for-identity/technical-faq#winpcap-and-npcap-drivers
https://dirteam.com/sander/2021/08/06/whats-new-in-microsoft-defender-for-identity-in-july-2021/


## Contributor info

**Contributor:** Alex Verboon, Gianni Castaldi