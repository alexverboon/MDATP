
# Defender for Endpoint - Devices with Signatures that affect the ASR Rule  Block Win32 API calls from Office macro

Run the below queries to identify devices that have signatures installed that affect the FB for Block Win32 API calls from Office macro, deleting shortcuts. 

For more details see [ASR rule “Block Win32 API calls from Office macro” - FP issue Frequently Asked Questions (FAQ)](https://github.com/microsoft/MDE-PowerBI-Templates/blob/master/ASR_scripts/ASR_rule_Block_Win32_API_calls_from_Office_Macro_issue_Q%26A.md)

All the queries return the same information, just demonstrating different options or enriching the data with additional data

---

```Kusto
// Identify devices that have the signatureversion that affects the ASR Block Rule Block Win32 API calls from Office macro
let badsignatures = dynamic(['1.381.2134.0','1.381.2140.0','1.381.2152.0','1.381.2163.0']);
DeviceTvmInfoGathering 
| evaluate bag_unpack(AdditionalFields)
| where isnotempty( AvSignatureVersion )
| summarize arg_max(Timestamp,*) by DeviceId
| project Timestamp, DeviceName, AvSignatureVersion, AvPlatformVersion, AvEngineVersion
| where AvSignatureVersion in (badsignatures)
```

```Kusto
// Identify devices that have the signatureversion that affects the ASR Block Rule Block Win32 API calls from Office macro
let badsignatures = dynamic(['1.381.2134.0','1.381.2140.0','1.381.2152.0','1.381.2163.0']);
DeviceTvmInfoGathering
| extend AdditionalFields = parse_json(AdditionalFields)
| extend AvEngineVersion = tostring(AdditionalFields.["AvEngineVersion"])
| extend AvPlatformVersion = tostring(AdditionalFields.["AvPlatformVersion"])
| extend AvSignatureVersion = tostring(AdditionalFields.["AvSignatureVersion"])
| where isnotempty( AvSignatureVersion )
| summarize arg_max(Timestamp,*) by DeviceId
| project Timestamp, DeviceName, AvSignatureVersion, AvPlatformVersion, AvEngineVersion, AdditionalFields
| where AvSignatureVersion in (badsignatures)
```

```Kusto
// Identify devices that have the signatureversion that affects the ASR Block Rule Block Win32 API calls from Office macro
// joining the data with the DeviceInfo table to get additional OS version information. 
let badsignatures = dynamic(['1.381.2134.0','1.381.2140.0','1.381.2152.0','1.381.2163.0']);
DeviceInfo
| where OnboardingStatus == 'Onboarded'
| where isnotempty( OSBuild)
| summarize arg_max(Timestamp,*) by DeviceName
| join kind=leftouter  (DeviceTvmInfoGathering 
| extend AF = AdditionalFields)
on $left.DeviceId== $right. DeviceId
| evaluate bag_unpack(AF)
| where isnotempty( AvSignatureVersion )
| extend AdditionalFields = parse_json(AdditionalFields1)
| extend AvEngineVersion = tostring(AdditionalFields.["AvEngineVersion"])
| extend AvPlatformVersion = tostring(AdditionalFields.["AvPlatformVersion"])
| extend AvSignatureVersion = tostring(AdditionalFields.["AvSignatureVersion"])
| project Timestamp, DeviceName, AvSignatureVersion, AvPlatformVersion, AvEngineVersion, OSBuild, OSVersion, OSPlatform
| where AvSignatureVersion in (badsignatures)
```

To get a complete inventory of installed Signature updates, simply uncomment the last line in the above queries
```
// | where AvSignatureVersion in (badsignatures)
```