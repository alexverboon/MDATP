# MDE Unified Agent Deployment Status

Use the below queries to find information about the Microsoft Defender for Endpoint - Unified Agent for downlevel servers Agent deployment

---

## Query

```Kusto
// MMA - Unified Agent status
DeviceInfo
| where OnboardingStatus == "Onboarded"
| where isnotempty(OSPlatform) and isnotempty(DeviceName)
| where OSPlatform contains "WindowsServer2012R2" or OSPlatform contains "WindowsServer2016"
| extend Agent = case(ClientVersion startswith "10.3720", "MMA", ClientVersion startswith "10.8045" or ClientVersion startswith "10.8046" or ClientVersion startswith "10.8047" or ClientVersion startswith "10.8048", "UnifiedClient","Other")
| summarize by DeviceName, OSPlatform, OnboardingStatus,Agent, ClientVersion
| sort by ClientVersion asc
// | summarize count() by Agent
```

```Kusto
// upgrade overview per OS
DeviceInfo
| where OnboardingStatus == "Onboarded"
| where isnotempty(OSPlatform) and isnotempty(DeviceName)
| where OSPlatform contains "WindowsServer2012R2" or OSPlatform contains "WindowsServer2016" 
| extend Agent = case(ClientVersion startswith "10.3720", "MMA", ClientVersion startswith "10.8045" or ClientVersion startswith "10.8046" or ClientVersion startswith "10.8047" or ClientVersion startswith "10.8048", "UnifiedClient","Other")
| summarize by DeviceName, OSPlatform, OnboardingStatus,Agent, ClientVersion
| sort by ClientVersion asc
| summarize TotalServers = count(),  MMA = make_set_if(DeviceName,Agent == "MMA"), 
Unified = make_set_if(DeviceName, Agent == "UnifiedClient"),
Other = make_set_if(DeviceName, Agent == "Other") by OSPlatform
| extend TotalMMA = array_length(MMA)
| extend TotalUnified = array_length(Unified) 
| extend TotalOther = array_length(Other)
| project OSPlatform, TotalServers, TotalMMA, TotalUnified, TotalOther
```Kusto


```Kusto
//  Security Controls - Update EDR sensor for down-level Windows Server - Compliance Summary 
DeviceTvmSecureConfigurationAssessment
| where isnotempty(OSPlatform) and isnotempty(DeviceName)
| where OSPlatform contains "WindowsServer2012R2" or OSPlatform contains "WindowsServer2016" 
| where ConfigurationId in ("scid-2030")
| summarize arg_max(Timestamp, IsCompliant, IsApplicable) by DeviceId, ConfigurationId, DeviceName, OSPlatform
| extend Configuration = case(
    ConfigurationId == "scid-2030", "Update EDR sensor for down-level Windows Server",
    "N/A"),
    Result = case(IsApplicable == 0, "N/A", IsCompliant == 1, "GOOD", "BAD")
| summarize toint(Compliant = dcountif(DeviceId ,Result=="GOOD")) ,toint(NonCompliant = dcountif(DeviceId,Result=="BAD")), toint(NotApplicable = dcountif(DeviceId, Result =="N/A")) by OSPlatform, Configuration, ConfigurationId 
| extend TotalDevices = toint((Compliant + NonCompliant + NotApplicable))
| extend PctCompliant = toint((Compliant*100) / TotalDevices)
| project OSPlatform, Configuration, Compliant, NonCompliant, TotalDevices, PctCompliant
```

```Kusto
// Total server OS inventory
DeviceInfo
| where OnboardingStatus == "Onboarded"
| where isnotempty(OSPlatform)
| summarize arg_max(Timestamp,30d) by DeviceName, OSPlatform, OnboardingStatus
| where OSPlatform startswith "WindowsServer"
| summarize count() by OSPlatform
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