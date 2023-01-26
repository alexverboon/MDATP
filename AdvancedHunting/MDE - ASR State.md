# MDE Attack Surface Reduction Rule State

Use the below query to retrieve information about the state of the individual Attack Surface Reduction rules by using the [DeviceTvmInfoGathering](https://learn.microsoft.com/en-us/microsoft-365/security/defender/advanced-hunting-devicetvminfogathering-table?view=o365-worldwide) table from Microsoft Defender Threat and Vulnerability Management. 

----

## Query

```Kusto

DeviceInfo
| where OnboardingStatus == 'Onboarded'
| where isnotempty(OSPlatform)
| summarize arg_max(Timestamp, *) by DeviceName
| where OSPlatform startswith "Windows"
| project DeviceName, OSPlatform
| join kind=leftouter (
    DeviceTvmInfoGathering
    | extend AF = parse_json(AdditionalFields)
    | extend ASR1 = parse_json(AdditionalFields.AsrConfigurationStates)
    | project DeviceName, ASR1
    | evaluate bag_unpack(ASR1)
    )
    on $left.DeviceName == $right.DeviceName
    | project-away DeviceName1

```


----


## Work in Progress...... just trying.... :-)


```Kusto

let asrkb = materialize (DeviceTvmInfoGatheringKB
| where Categories has "asr"
| extend AsrRuleName = replace_regex(FieldName,"Asr","")
| project AsrRuleName, Description
);
DeviceInfo
| where OnboardingStatus == 'Onboarded'
| where isnotempty( OSPlatform)
| summarize arg_max(Timestamp,*) by DeviceName
| where OSPlatform startswith "Windows"
| project DeviceName, OSPlatform
| join kind=leftouter (DeviceTvmInfoGathering
| extend AF = parse_json(AdditionalFields)
| extend ASR1 = parse_json(AdditionalFields.AsrConfigurationStates)
| project DeviceName, ASR1
| mv-expand parse_json(ASR1)
| extend ASRRule = tostring(bag_keys(ASR1)[0])
| extend AsrRuleSetting = extract(@':"(.*?)"',1,tostring(ASR1))
)
on $left.DeviceName == $right.DeviceName
| join kind=leftouter (asrkb)
on $left. ASRRule == $right. AsrRuleName
| project DeviceName, OSPlatform, Description, AsrRuleName, AsrRuleSetting
| summarize AsrRuleSet = parse_json(make_set(AsrRuleSetting)[0]) by DeviceName, Description
| evaluate pivot(Description,make_set(AsrRuleSet), DeviceName)
```Kusto
