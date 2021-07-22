// The below query attempts to get the avg Size in MB per client that is send from Microosoft Defender for Endpoint to Azure Sentinel when using the M365 Defender connector
// The calculation is done as following:
// 1. Collect the Usage data for the specified table from the Usage table, for example 'DeviceFileEvents'
// 2. Collect the total # of devices that submitted information into the specified table, for example 'DeviceFileEvents"
// 3 Divide the total BillableDataGB per DataType by the total number of devices that send data to get the avg MB send by client
// 4 finally 'uniion' all tables

let xagotime = 32d;
let xstarttime = 31d;
// File Events
let xDeviceFileEvents  = Usage 
| where TimeGenerated > ago(xagotime)
| where Solution contains "SecurityInsights"
| where DataType == "DeviceFileEvents"
| where StartTime >= startofday(ago(xstarttime)) and EndTime < startofday(now())
| summarize BillableDataGB = sum(Quantity) / 1000. by bin(StartTime, 1d), DataType 
| join (DeviceFileEvents
| where TimeGenerated > ago(xagotime)
| summarize TotalDevices = dcount(DeviceId) by bin(TimeGenerated,1d))
 on $left.StartTime == $right.TimeGenerated 
  | extend AverageMBClient = BillableDataGB / TotalDevices * 1000;
// Process Events
let xDeviceProcessEvents = Usage 
| where TimeGenerated > ago(xagotime)
| where Solution contains "SecurityInsights"
| where DataType == "DeviceProcessEvents"
| where StartTime >= startofday(ago(xstarttime)) and EndTime < startofday(now())
| summarize BillableDataGB = sum(Quantity) / 1000. by bin(StartTime, 1d), DataType 
| join (DeviceProcessEvents
| where TimeGenerated > ago(xagotime)
| summarize TotalDevices = dcount(DeviceId) by bin(TimeGenerated,1d))
 on $left.StartTime == $right.TimeGenerated 
| extend AverageMBClient = BillableDataGB / TotalDevices * 1000;
// logon events
let xDeviceLogonEvents =  Usage 
| where TimeGenerated > ago(xagotime)
| where Solution contains "SecurityInsights"
| where DataType == "DeviceLogonEvents"
| where StartTime >= startofday(ago(xstarttime)) and EndTime < startofday(now())
| summarize BillableDataGB = sum(Quantity) / 1000. by bin(StartTime, 1d), DataType 
| join (DeviceLogonEvents
| where TimeGenerated > ago(xagotime)
| summarize TotalDevices = dcount(DeviceId) by bin(TimeGenerated,1d))
 on $left.StartTime == $right.TimeGenerated 
| extend AverageMBClient = BillableDataGB / TotalDevices * 1000;
 // Registry Events
let xDeviceRegistryEvents =  Usage 
| where TimeGenerated > ago(xagotime)
| where Solution contains "SecurityInsights"
| where DataType == "DeviceRegistryEvents"
| where StartTime >= startofday(ago(xstarttime)) and EndTime < startofday(now())
| summarize BillableDataGB = sum(Quantity) / 1000. by bin(StartTime, 1d), DataType 
| join (DeviceRegistryEvents
| where TimeGenerated > ago(xagotime)
| summarize TotalDevices = dcount(DeviceId) by bin(TimeGenerated,1d))
 on $left.StartTime == $right.TimeGenerated 
| extend AverageMBClient = BillableDataGB / TotalDevices * 1000;
  // Network Events
 let xDeviceNetworkEvents =   Usage 
| where TimeGenerated > ago(xagotime)
| where Solution contains "SecurityInsights"
| where DataType == "DeviceNetworkEvents"
| where StartTime >= startofday(ago(xstarttime)) and EndTime < startofday(now())
| summarize BillableDataGB = sum(Quantity) / 1000. by bin(StartTime, 1d), DataType 
| join (DeviceNetworkEvents
| where TimeGenerated > ago(xagotime)
| summarize TotalDevices = dcount(DeviceId) by bin(TimeGenerated,1d))
 on $left.StartTime == $right.TimeGenerated 
| extend AverageMBClient = BillableDataGB / TotalDevices * 1000;
// Device Network Info
let xDeviceNetworkInfo =  Usage 
| where TimeGenerated > ago(xagotime)
| where Solution contains "SecurityInsights"
| where DataType == "DeviceNetworkInfo"
| where StartTime >= startofday(ago(xstarttime)) and EndTime < startofday(now())
| summarize BillableDataGB = sum(Quantity) / 1000. by bin(StartTime, 1d), DataType 
| join (DeviceNetworkInfo
| where TimeGenerated > ago(xagotime)
| summarize TotalDevices = dcount(DeviceId) by bin(TimeGenerated,1d))
 on $left.StartTime == $right.TimeGenerated 
| extend AverageMBClient = BillableDataGB / TotalDevices * 1000;
// Device Info 
let xDeviceInfo =  Usage 
| where TimeGenerated > ago(xagotime)
| where Solution contains "SecurityInsights"
| where DataType == "DeviceInfo"
| where StartTime >= startofday(ago(xstarttime)) and EndTime < startofday(now())
| summarize BillableDataGB = sum(Quantity) / 1000. by bin(StartTime, 1d), DataType 
| join (DeviceInfo
| where TimeGenerated > ago(xagotime)
| summarize TotalDevices = dcount(DeviceId) by bin(TimeGenerated,1d))
 on $left.StartTime == $right.TimeGenerated 
| extend AverageMBClient = BillableDataGB / TotalDevices * 1000;
// Image load events
let xDeviceImageLoadEvents =  Usage 
| where TimeGenerated > ago(xagotime)
| where Solution contains "SecurityInsights"
| where DataType == "DeviceImageLoadEvents"
| where StartTime >= startofday(ago(xstarttime)) and EndTime < startofday(now())
| summarize BillableDataGB = sum(Quantity) / 1000. by bin(StartTime, 1d), DataType 
| join (DeviceImageLoadEvents
| where TimeGenerated > ago(xagotime)
| summarize TotalDevices = dcount(DeviceId) by bin(TimeGenerated,1d))
 on $left.StartTime == $right.TimeGenerated 
| extend AverageMBClient = BillableDataGB / TotalDevices * 1000;
// Device Events
let xDeviceevents =  Usage 
| where TimeGenerated > ago(xagotime)
| where Solution contains "SecurityInsights"
| where DataType == "DeviceEvents"
| where StartTime >= startofday(ago(xstarttime)) and EndTime < startofday(now())
| summarize BillableDataGB = sum(Quantity) / 1000. by bin(StartTime, 1d), DataType 
| join (DeviceEvents
| where TimeGenerated > ago(xagotime)
| summarize TotalDevices = dcount(DeviceId) by bin(TimeGenerated,1d))
 on $left.StartTime == $right.TimeGenerated 
| extend AverageMBClient = BillableDataGB / TotalDevices * 1000;
// File Cert Info
let xDeviceCertInfo =  Usage 
| where TimeGenerated > ago(xagotime)
| where Solution contains "SecurityInsights"
| where DataType == "DeviceFileCertificateInfo"
| where StartTime >= startofday(ago(xstarttime)) and EndTime < startofday(now())
| summarize BillableDataGB = sum(Quantity) / 1000. by bin(StartTime, 1d), DataType 
| join (DeviceFileCertificateInfo
| where TimeGenerated > ago(xagotime)
| summarize TotalDevices = dcount(DeviceId) by bin(TimeGenerated,1d))
 on $left.StartTime == $right.TimeGenerated 
| extend AverageMBClient = BillableDataGB / TotalDevices * 1000;
// bring all together
union xDeviceCertInfo, xDeviceevents, xDeviceImageLoadEvents, xDeviceInfo, xDeviceLogonEvents, xDeviceNetworkEvents, xDeviceNetworkInfo, xDeviceProcessEvents, xDeviceRegistryEvents, xDeviceFileEvents
// calculate avg per device per data type per day
| summarize AvgMBClient = sum(AverageMBClient) by bin(TimeGenerated,1d) , DataType
| render columnchart 
