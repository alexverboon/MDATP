# Microsoft Defender for Endpoint - Troubleshooting Mode

Run the below queries to retrieve information about MDE Troublshooting mode states

Source: [Get started with troubleshooting mode in Microsoft Defender for Endpoint](https://learn.microsoft.com/en-us/microsoft-365/security/defender-endpoint/enable-troubleshooting-mode?view=o365-worldwide)

----

## Query

Search by deviceId or deviceName by commenting out the respective lines.


```Kusto
//let deviceName = "<deviceName>";   // update with device name
let deviceId = "<deviceID>";   // update with device id
DeviceEvents
| where DeviceId == deviceId
//| where DeviceName  == deviceName
| where ActionType == "AntivirusTroubleshootModeEvent"
| extend _tsmodeproperties = parse_json(AdditionalFields)
| project Timestamp,DeviceId, DeviceName, _tsmodeproperties,
 _tsmodeproperties.TroubleshootingState, _tsmodeproperties.TroubleshootingPreviousState, _tsmodeproperties.TroubleshootingStartTime,
 _tsmodeproperties.TroubleshootingStateExpiry, _tsmodeproperties.TroubleshootingStateRemainingMinutes,
 _tsmodeproperties.TroubleshootingStateChangeReason, _tsmodeproperties.TroubleshootingStateChangeSource
```

Devices currently in troubleshooting mode


```Kusto
DeviceEvents
| where Timestamp > ago(3h) // troubleshooting mode automatically disables after 3 hours 
| where ActionType == "AntivirusTroubleshootModeEvent"
| extend _tsmodeproperties = parse_json(AdditionalFields)
| where _tsmodeproperties.TroubleshootingStateChangeReason contains "started"
|summarize (Timestamp, ReportId)=arg_max(Timestamp, ReportId), count() by DeviceId
| order by Timestamp desc
```

Count of troubleshooting mode instances by device

```Kusto
DeviceEvents
| where ActionType == "AntivirusTroubleshootModeEvent"
| extend _tsmodeproperties = parse_json(AdditionalFields)
| where Timestamp > ago(30d)  // choose the date range you want
| where _tsmodeproperties.TroubleshootingStateChangeReason contains "started"
| summarize (Timestamp, ReportId)=arg_max(Timestamp, ReportId), count() by DeviceId
| sort by count_
```

Total count


```Kusto
DeviceEvents
| where ActionType == "AntivirusTroubleshootModeEvent"
| extend _tsmodeproperties = parse_json(AdditionalFields)
| where Timestamp > ago(2d) //beginning of time range
| where Timestamp < ago(1d) //end of time range
| where _tsmodeproperties.TroubleshootingStateChangeReason contains "started"
| summarize (Timestamp, ReportId)=arg_max(Timestamp, ReportId), count()
| where count_ > 5          // choose your max # of TS mode instances for your time range
```