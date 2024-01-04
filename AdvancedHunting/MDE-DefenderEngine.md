# Microsoft Defender - Engine , Platform states

Use the below query to retrieve information about Microsoft Defender

---

## Query

```Kusto
DeviceTvmInfoGathering
| extend xAVMode = parse_json(AdditionalFields.AvMode)
| where isnotempty(xAVMode)
| extend AF = parse_json(AdditionalFields)
| evaluate bag_unpack(AF, columnsConflict='keep_source'): (
    Timestamp: datetime, 
    DeviceName: string, 
    OSPlatform: string, 
    AsrConfigurationStates: dynamic, 
    AvEnginePublishTime: datetime, 
    AvEngineRing: string, 
    AvEngineUpdateTime: datetime,
    AvEngineVersion: string,
    AvIsEngineUptodate: string ,
    AvIsPlatformUptodate: string,
    AvIsSignatureUptoDate: string,
    AvMode: string,
    AvPlatformPublishTime: datetime,
    AvPlatformRing: string,
    AvPlatformUpdateTime: datetime,
    AvPlatformVersion: string,
    AvScanResults: string,
    AvSignatureDataRefreshTime: datetime, 
    AvSignaturePublishTime: datetime,
    AvSignatureRing: string,
    AvSignatureUpdateTime: datetime, 
    AvSignatureVersion: string,
    AdditionalFields: dynamic)
// AV Engine Version
//| project DeviceName, OSPlatform,AvIsEngineUptodate, AvEnginePublishTime,AvEngineUpdateTime,AvEngineVersion,AvEngineRing
//| summarize count() by AvEngineVersion
// AV Platformversion
//| project Timestamp, DeviceName, OSPlatform, AvIsPlatformUptodate,AvPlatformPublishTime,AvPlatformUpdateTime,AvPlatformVersion,AvPlatformRing
// AVSignatureVersion
| project Timestamp, DeviceName, OSPlatform, AvIsSignatureUptoDate,AvSignatureUpdateTime,AvSignaturePublishTime,AvSignatureDataRefreshTime,AvSignatureVersion,AvSignatureRing
```
