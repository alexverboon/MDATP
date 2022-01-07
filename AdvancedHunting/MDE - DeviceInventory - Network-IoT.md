# Microsoft Defender - Device Inventory - Network and IoT

Use the below queires to retrieve device inventory information of discovered Network and IoT devices

---

## Query

## IoT Device Inventory

```Kusto
// IoT Device Inventory
DeviceInfo
| where DeviceCategory == @"IoT"
| summarize arg_max(Timestamp, *) by DeviceId
| join (
    DeviceNetworkInfo
    | mv-expand todynamic(IPAddresses)
    | extend IPAddress = tostring(parse_json(IPAddresses).IPAddress)
    | summarize arg_max(Timestamp, *) by DeviceId
    )
    on $left.DeviceId == $right.DeviceId
| project Timestamp, DeviceId, DeviceName, DeviceType, DeviceSubtype, IPAddress, MacAddress, Model, Vendor, OSPlatform, OSVersion, OSDistribution
```

## Network Device Inventory

```
// Network Device Inventory
DeviceInfo
| where DeviceCategory == @"NetworkDevice"
| summarize arg_max(Timestamp, *) by DeviceId
| join (
    DeviceNetworkInfo
    | mv-expand todynamic(IPAddresses)
    | extend IPAddress = tostring(parse_json(IPAddresses).IPAddress)
    | summarize arg_max(Timestamp, *) by DeviceId
    )
    on $left.DeviceId == $right.DeviceId
| project Timestamp, DeviceId, DeviceName, DeviceType, DeviceSubtype, IPAddress, MacAddress, Model, Vendor, OSPlatform, OSVersion, OSDistribution
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