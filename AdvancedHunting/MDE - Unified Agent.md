# MDE Unified Agent Deployment Status

Use the below queries to find information about the Microsoft Defender for Endpoint - Unified Agent for downlevel servers Agent deployment

---

## Query

```Kusto
// MMA - Unified Agent status by Agent
DeviceInfo
| where OnboardingStatus == "Onboarded"
| where isnotempty(OSPlatform) and isnotempty(DeviceName)
| where OSPlatform contains "WindowsServer2012R2" or OSPlatform contains "WindowsServer2016" 
| extend Agent = case(ClientVersion startswith "10.3720", "MMA", ClientVersion startswith "10.8", "UnifiedClient","Other")
| summarize by DeviceName, OSPlatform, OnboardingStatus, Agent, ClientVersion
| sort by ClientVersion asc
| summarize TotalServers = count(), MMA = make_set_if(DeviceName, Agent == "MMA"), 
    Unified = make_set_if(DeviceName, Agent == "UnifiedClient"),
    Other = make_set_if(DeviceName, Agent == "Other")
    by OSPlatform
| extend TotalMMA = array_length(MMA)
| extend TotalUnified = array_length(Unified) 
| extend TotalOther = array_length(Other)
| project OSPlatform, TotalServers, TotalMMA, TotalUnified, TotalOther
```


```Kusto
// MMA - Unified Agent status per Server
DeviceInfo
| where OnboardingStatus == "Onboarded"
| where isnotempty(OSPlatform) and isnotempty(DeviceName)
| where OSPlatform contains "WindowsServer2012R2" or OSPlatform contains "WindowsServer2016"
| extend Agent = case(ClientVersion startswith "10.3720", "MMA", ClientVersion startswith "10.8", "UnifiedClient","Other")
//| extend Agent = case(ClientVersion startswith "10.3720", "MMA", ClientVersion startswith "10.8045" or ClientVersion startswith "10.8046" or ClientVersion startswith "10.8047" or ClientVersion startswith "10.8048", "UnifiedClient","Other")
| summarize by DeviceName, OSPlatform, OnboardingStatus,Agent, ClientVersion
| sort by ClientVersion asc
```

```Kusto
// Server OS version overview
DeviceInfo
| where OnboardingStatus == "Onboarded"
| where isnotempty(OSPlatform) and isnotempty(DeviceName)
| summarize arg_max(Timestamp,*) by DeviceId
| project Timestamp, DeviceName, ClientVersion, OSPlatform
| where OSPlatform contains "WindowsServer2012R2" or OSPlatform contains "WindowsServer2016"
| summarize count() by ClientVersion,OSPlatform
```


```Kusto
// Shows servers and their patch status, servers that still have the MMA agent installed and a high number of missing patches
// will first need to be patched before installing the unified agent . 
let missingkb = 
// Details missing KBs Windows Server
DeviceTvmSoftwareVulnerabilities
| where SoftwareVendor == 'microsoft'
| where SoftwareName startswith 'windows_server'
| where isnotempty(RecommendedSecurityUpdate)
| distinct DeviceId, RecommendedSecurityUpdate, RecommendedSecurityUpdateId, SoftwareName
| join kind=leftouter (
    DeviceInfo
    | where isnotempty(OSPlatform)
    | where OnboardingStatus == 'Onboarded'
    | where isnotempty(OSVersionInfo)
    | summarize arg_max(Timestamp, *) by DeviceId)
    on $left.DeviceId == $right.DeviceId
| summarize MissingKBs = make_set(RecommendedSecurityUpdate) by DeviceName
| extend TotalMissingKB = array_length(MissingKBs);
DeviceInfo
| where OnboardingStatus == "Onboarded"
| where isnotempty(OSPlatform) and isnotempty(DeviceName)
| where OSPlatform contains "WindowsServer2012R2" or OSPlatform contains "WindowsServer2016"
| extend Agent = case(ClientVersion startswith "10.3720", "MMA", ClientVersion startswith "10.8", "UnifiedClient","Other")
| summarize by DeviceName, OSPlatform, OnboardingStatus,Agent, ClientVersion
| sort by ClientVersion asc
| join kind=leftouter  (missingkb)
on $left. DeviceName ==  $right.DeviceName
```




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


## See also

## Contributor info

**Contributor:** Alex Verboon