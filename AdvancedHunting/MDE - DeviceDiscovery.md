# Device Discovery

Device discovery uses Microsoft Defender for Endpoint on onboarded Windows 10 and Server 2019 devices to discover unmanaged devices in your corporate network. 
For each discovered device you see which onboarded device it was seen by. This information can help determine the network location of each discovered device and subsequently, help to identify it in the network. 

For a particular discovered device in the network, you can now look at a new "SeenBy” column, added to the DeviceInfo record in Advanced Hunting. This lists the device ids of the last devices (up to 5) to have seen the discovered device.


You can use the following query to return the relevant data on the specified discovered device id, along with the list of devices that have seen it in the network. 

---

## Query

```Kusto
let deviceId = ""; // Fill ID for specific device, leave blank for all 
let lookback = ago(7d);  
let machines = DeviceInfo  
| where Timestamp >= lookback  
| where isempty(deviceId) or DeviceId == deviceId 
| where OnboardingStatus != "Onboarded" and isempty(MergedToDeviceId) 
| summarize arg_max(Timestamp, *) by DeviceId 
| join kind=leftouter (DeviceNetworkInfo | where Timestamp > lookback) on DeviceId 
| summarize arg_max(Timestamp, *) by DeviceId 
| mv-expand todynamic(SeenBy) 
| extend SeenByDeviceId = tostring(SeenBy.DeviceId), LastEncountered = todatetime(SeenBy.LastEncountered) 
| project DeviceName, DeviceId, DeviceType, DeviceSubtype, OnboardingStatus, OSPlatform, Vendor, SeenByDeviceId, LastEncountered, IPAddresses 
; 
machines 
| join (DeviceInfo | where Timestamp > lookback and OnboardingStatus == "Onboarded" and OSPlatform != "") on $left.SeenByDeviceId == $right.DeviceId 
| summarize arg_max(Timestamp, *) by DeviceId, SeenByDeviceId 
//| join (DeviceNetworkInfo | where Timestamp > lookback) on $left.SeenByDeviceId == $right.DeviceId // Uncomment to extend with more network info as needed 
| project DeviceName, DeviceId, SeenByDeviceId, SeenByDeviceName = DeviceName1, DeviceType, DeviceSubtype, OnboardingStatus, OSPlatform, Vendor, IPAddresses, LastEncountered 
| summarize SeenByDeviceNames=make_set(SeenByDeviceName), SeenByDeviceIds=make_set(SeenByDeviceId) by DeviceName, DeviceId, DeviceType, DeviceSubtype, OnboardingStatus, OSPlatform, Vendor, IPAddresses 
| project-reorder DeviceName, DeviceId, SeenByDeviceNames, SeenByDeviceIds, * 

```

Run this query on the DeviceInfo table to return all discovered devices along with the most up-to-date details for each device:

```
DeviceInfo
| summarize arg_max(Timestamp, *) by DeviceId  // Get latest known good per device Id
| where isempty(MergedToDeviceId) // Remove invalidated/merged devices
| where OnboardingStatus != "Onboarded"
```

By invoking the SeenBy function, in your advanced hunting query, you can get detail on which onboarded device a discovered device was seen by. 
This information can help determine the network location of each discovered device and subsequently, help to identify it in the network.

```
DeviceInfo
| where OnboardingStatus != "Onboarded"
| summarize arg_max(Timestamp, *) by DeviceId 
| where isempty(MergedToDeviceId) 
| limit 100
| invoke SeenBy()
| project DeviceId, DeviceName, DeviceType, SeenBy
```

Device discovery leverages Microsoft Defender for Endpoint onboarded devices as a network data source to attribute activities to non-onboarded devices. The network sensor on the Microsoft Defender for Endpoint onboarded device identifies two new connection types:

- ConnectionAttempt - An attempt to establish a TCP connection (syn)
- ConnectionAcknowledged - An acknowledgment that a TCP connection was accepted (syn\ack)

This means that when a non-onboarded device attempts to communicate with an onboarded Microsoft Defender for Endpoint device, the attempt will generate a DeviceNetworkEvent and the non-onboarded device activities can be seen on the onboarded device timeline, and through the Advanced hunting DeviceNetworkEvents table.

```
DeviceNetworkEvents
| where ActionType == "ConnectionAcknowledged" or ActionType == "ConnectionAttempt"
| take 10
```




## See also

[Device discovery overview](https://learn.microsoft.com/en-us/microsoft-365/security/defender-endpoint/device-discovery?view=o365-worldwide)\



## Contributor info

**Contributor:** Alex Verboon, Microsoft 