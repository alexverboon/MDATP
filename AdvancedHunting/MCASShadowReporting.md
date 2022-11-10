# Microsoft Defender for Cloud Apps - Shadow IT Reporting

---

## Query

```Kusto
// mcas shadown reporting
McasShadowItReporting
| where TimeGenerated > ago (90d)
| where StreamName == "Win10 Endpoint Users"
| summarize Totalbytes = sum(TotalBytes), UploadBytes = sum( UploadedBytes), DownloadBytes = sum(DownloadedBytes), Users = make_set(EnrichedUserName), Devices = make_set(MachineName), IPAddresses = make_set(IpAddress)  by AppName, AppScore
| extend TotalDevices = array_length(Devices)
| extend TotalIPAddresses = array_length(IPAddresses)
| extend Totalusers = array_length(Users)
| extend UploadMB = format_bytes(UploadBytes,0,"MB")
| extend TotalTraffic = format_bytes(Totalbytes,0,"MB")
| extend DownloadMB = format_bytes(DownloadBytes,0,"MB")
| project AppName,AppScore, TotalDevices, TotalIPAddresses, Totalusers, TotalTraffic, UploadMB, DownloadMB, IPAddresses, Devices, Users
```

```Kusto
McasShadowItReporting
| where TimeGenerated > ago (90d)
| where StreamName == "Win10 Endpoint Users"
| summarize Totalbytes = sum(TotalBytes), UploadBytes = sum( UploadedBytes), DownloadBytes = sum(DownloadedBytes), Users = make_set(EnrichedUserName), Devices = make_set(MachineName), IPAddresses = make_set(IpAddress) , Apps = make_set(AppName) by EnrichedUserName
| extend TotalDevices = array_length(Devices)
| extend TotalIPAddresses = array_length(IPAddresses)
| extend Totalusers = array_length(Users)
| extend TotalApps = array_length(Apps)
| extend UploadMB = format_bytes(UploadBytes,0,"MB")
| extend TotalTraffic = format_bytes(Totalbytes,0,"MB")
| extend DownloadMB = format_bytes(DownloadBytes,0,"MB")
| project EnrichedUserName, TotalDevices, TotalIPAddresses, Totalusers,TotalApps, TotalTraffic, UploadMB, DownloadMB, IPAddresses, Devices, Users, Apps

```




## Contributor info

**Contributor:** Alex Verboon, Kim Oppalfens - @TheWMIGuy