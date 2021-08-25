# Microsoft Defender Antivirus - Outdated Signture updates

Use the below queries to identify devices that have outdated Defender signature updates. 

---

## Query

```Kusto
// Microsoft Defender for Windows - outdated signature updates 
// The following query identifies devices with outdated Defender signature updates
let signatureage = 10d;
DeviceTvmSecureConfigurationAssessment 
| extend DataCollectionDate = Timestamp
| where ConfigurationId == "scid-2011" // Update Microsoft Defender for Windows Antivirus definitions
| where IsCompliant == 0
| where IsApplicable == 1
| join kind=leftouter DeviceTvmSecureConfigurationAssessmentKB on ConfigurationId 
| mv-expand  e = parse_json(Context)
| project Timestamp, DeviceName,DeviceId, OSPlatform, SignatureVersion=tostring(e[0]), SignatureDate=todatetime(e[2]), EngineVersion=e[1], ProductVersion=e[3], DataCollectionDate
 | where SignatureDate < ago(signatureage)
 | join kind=inner    (DeviceInfo
| where Timestamp > ago(30d)
| summarize arg_max(Timestamp,*) by DeviceName
| extend LastSeen = Timestamp
)
on $left.DeviceId ==  $right.DeviceId
| project Timestamp, DeviceName, DeviceId, OSPlatform, SignatureVersion, SignatureDate, EngineVersion, ProductVersion, LastSeen, DataCollectionDate
| sort by SignatureDate asc 
```

```Kusto
// Microsoft Defender for Windows - outdated signature updates 
// The following query identifies devices with outdated Defender signature updates that have their latest signature update date between the defined timeframe
// adjust the below variables as needed
let signatureagemin = now(-10d);
let signatureagemax = now(-11d);
DeviceTvmSecureConfigurationAssessment 
| extend DataCollectionDate = Timestamp
| where ConfigurationId == "scid-2011" // Update Microsoft Defender for Windows Antivirus definitions
| where IsCompliant == 0
| where IsApplicable == 1
| join kind=leftouter DeviceTvmSecureConfigurationAssessmentKB on ConfigurationId 
| mv-expand  e = parse_json(Context)
| project Timestamp, DeviceName,DeviceId, OSPlatform, SignatureVersion=tostring(e[0]), SignatureDate=todatetime(e[2]), EngineVersion=e[1], ProductVersion=e[3], DataCollectionDate
| where SignatureDate  between ((signatureagemax) .. (signatureagemin))
 | join kind=inner    (DeviceInfo
| where Timestamp > ago(30d)
| summarize arg_max(Timestamp,*) by DeviceName
| extend LastSeen = Timestamp
)
on $left.DeviceId ==  $right.DeviceId
| project Timestamp, DeviceName, DeviceId, OSPlatform, SignatureVersion, SignatureDate, EngineVersion, ProductVersion, LastSeen, DataCollectionDate
| sort by SignatureDate asc 
```

```Kusto
// Microsoft Defender for Linux - outdated signature updates 
// The following query identifies devices with outdated Defender signature updates
let signatureage = 10d;
DeviceTvmSecureConfigurationAssessment 
| extend DataCollectionDate = Timestamp
| where ConfigurationId == "scid-6095" // Microsoft defender for Linux outdated antivirus signatures
| where IsCompliant == 0
| where IsApplicable == 1
| join kind=leftouter DeviceTvmSecureConfigurationAssessmentKB on ConfigurationId 
| mv-expand  e = parse_json(Context)
| project Timestamp, DeviceName,DeviceId, OSPlatform, SignatureVersion=tostring(e[0]), SignatureDate=todatetime(e[2]), EngineVersion=e[1], ProductVersion=e[3], DataCollectionDate
 | where SignatureDate < ago(signatureage)
 | join kind=inner    (DeviceInfo
| where Timestamp > ago(30d)
| summarize arg_max(Timestamp,*) by DeviceName
| extend LastSeen = Timestamp
)
on $left.DeviceId ==  $right.DeviceId
| project Timestamp, DeviceName, DeviceId, OSPlatform, SignatureVersion, SignatureDate, EngineVersion, ProductVersion, LastSeen, DataCollectionDate
| sort by SignatureDate asc 
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
The initial query to identify devices with outdated definition updates was developed by Jan Geisbauer
https://github.com/jangeisbauer/AdvancedHunting/blob/master/AntiVirusReporting

## Contributor info

**Contributor:** Alex Verboon, Jan Geisbauer


