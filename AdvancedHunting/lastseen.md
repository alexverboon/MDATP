let threshold = 7d;
DeviceInfo
| summarize arg_max(Timestamp, *) by DeviceName
| project LastSeen=Timestamp, DeviceName, MachineGroup
| where LastSeen < ago(threshold)
| sort by LastSeen