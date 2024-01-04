# Microsoft Defender for Endpoint - Zeek

 - [Enrich your advanced hunting experience using network layer signals from Zeek](https://techcommunity.microsoft.com/t5/microsoft-defender-for-endpoint/enrich-your-advanced-hunting-experience-using-network-layer/ba-p/3794693)

----

## Query

```Kusto
DeviceNetworkEvents
| where ActionType contains 'ConnectionInspected'
| distinct ActionType

```


look for rare user agents in the environment to identify potentially suspicious outbound web requests and cover the "T1071.001: (Application Layer Protocol) Web Protocols" technique.

```Kusto
// Identify rare User Agent strings used in http conversations
DeviceNetworkEvents
| where ActionType == 'HttpConnectionInspected'
| extend json = todynamic(AdditionalFields)
| extend direction = tostring(json.direction), user_agent = tostring(json.user_agent)
| where direction == 'Out'
| summarize Devices = dcount(DeviceId) by user_agent
| sort by Devices asc
```

Suppose you have identified a suspicious-looking user-agent named “TrickXYZ 1.0” and need to determine which user/process/commandline combination had initiated that connection.  Currently, the HttpConnectionInspected events, as with all Zeek-related action types, do not contain that information, so you must execute a follow-up query by joining with events from  ConnectionEstablished action type. Here’s an example of a follow-up query:

```Kusto
// Identify usage of a suspicious user agent
DeviceNetworkEvents
| where Timestamp > ago(1h) and ActionType == "HttpConnectionInspected"
| extend json = todynamic(AdditionalFields)
| extend user_agent = tostring(json.user_agent)
| where user_agent == "TrickXYZ"
| project ActionType,AdditionalFields, LocalIP,LocalPort,RemoteIP,RemotePort, TimeKey = bin(Timestamp, 5m)
| join kind = inner (
DeviceNetworkEvents
| where Timestamp > ago(1h) and ActionType == "ConnectionSuccess"
| extend TimeKey = bin(Timestamp, 5m)) on LocalIP,RemoteIP,LocalPort,TimeKey
| project DeviceId, ActionType, AdditionalFields, LocalIP,LocalPort,RemoteIP,RemotePort , InitiatingProcessId,InitiatingProcessFileName,TimeKey

```

In another example, let’s look for file downloads from HTTP, particularly files of executable and compressed file extensions to cover the "T1105: Ingress tool transfer" technique:


```Kusto
// Detect file downloads
DeviceNetworkEvents
| where ActionType == 'HttpConnectionInspected'
| extend json = todynamic(AdditionalFields)
| extend direction= tostring(json.direction), user_agent=tostring(json.user_agent), uri=tostring(json.uri)
| where uri matches regex @"\.(?:dll|exe|zip|7z|ps1|ps|bat|sh)$"

```

Let’s look at a few advanced hunting examples using this action type. In the first example, you want to look for potentially infected devices trying to perform "T1110: Brute-Force" against remote servers using SSH as an initial step to “T1021.004: Lateral Movement - Remote Services: SSH”.
 

The query below will give you a list of Local/Remote IP combinations with at least 12 failed attempts (three failed authentications on four sessions) of SSH connections in the last hour. Feel free to use this example and adapt it to your needs.

```Kusto
// Detect potential bruteforce/dictionary attacks against SSH
DeviceNetworkEvents
| where ActionType == 'SshConnectionInspected'
| extend json = todynamic(AdditionalFields)
| extend direction=tostring(json.direction), auth_attempts = toint(json.auth_attempts), auth_success=tostring(json.auth_success)
| where auth_success=='false'
| where auth_attempts > 3
| summarize count() by LocalIP, RemoteIP
| where count_ > 4
| sort by count_ desc

```

In the next example, let’s suppose you are looking to identify potentially vulnerable SSH versions and detect potentially unauthorized client software being used to initiate SSH connections and operating systems that are hosting SSH server services in your environment:

```Kusto
// Identify Server/Client pairs being used for SSH connections
DeviceNetworkEvents
| where  ActionType == "SshConnectionInspected"
| extend json = todynamic(AdditionalFields)
| project Server = tostring(json.server),Client = tostring(json.client)
| distinct Server ,Client

```

In the first example, you wish to look for potential data leakage via ICMP to cover the "T1048: Exfiltration Over Alternative Protocol" or "T1041: Exfiltration Over C2 Channel" techniques. The idea is to look for outbound connections and check the payload bytes a device sends in a given timeframe. We will parse the direction, orig_bytes, and duration fields and look for conversations over 100 seconds where more than 500,000 were sent. The numbers are used as an example and do not necessarily indicate malicious activity. Usually, you will see the download and upload are almost equal for ICMP traffic because most devices generate “ICMP reply” with the same payload that was observed on the “ICMP echo” request.


```Kusto
// search for high upload over ICMP
DeviceNetworkEvents
| where ActionType == "IcmpConnectionInspected"
| extend json = todynamic(AdditionalFields)
| extend Upload = tolong(json['orig_bytes']), Download = tolong(json['resp_bytes']), Direction = tostring(json.direction), Duration = tolong(json.duration)
| where Direction == "Out" and Duration > 100 and Upload > 500000
| top 10 by Upload
| project RemoteIP, LocalIP, Upload = format_bytes(Upload, 2, "MB"), Download = format_bytes(Download, 2, "MB"),Direction,Duration,Timestamp,DeviceId,DeviceName

```

In the last example, you wish to create another hunting query that helps you detect potential Ping sweep activities in your environment to cover the "T1018: Remote System Discovery" and "T1595: Active Scanning" techniques. The query will look for outbound ICMP traffic to internal IP addresses, create an array of the targeted IPs reached from the same source IP, and display them if the same source IP has pinged more than 5 IP Addresses within a 10-minute time window.

```Kusto
// Search for ping scans
DeviceNetworkEvents
| where ActionType == "IcmpConnectionInspected"
| extend json = todynamic(AdditionalFields)
| extend Direction = json.direction
| where Direction == "Out" and ipv4_is_private(RemoteIP)
| summarize IpsList = make_set(RemoteIP) by DeviceId, bin(Timestamp, 10m)
| where array_length(IpsList) > 5
```

Identifying the origin process of ICMP traffic can be challenging as ICMP is an IP-Layer protocol. Still, we can use some OS-level indications to narrow down our search. We can use the following query to identify which process-loaded network, or even ICMP-specific, binaries:


```Kusto
DeviceImageLoadEvents
| where FileName =~ "icmp.dll" or FileName =~ "Iphlpapi.dll"
```


----

## More...


```Kusto
DeviceNetworkEvents
| where ActionType == 'HttpConnectionInspected'
| extend json = todynamic(AdditionalFields)
| extend direction= tostring(json.direction), user_agent=tostring(json.user_agent), uri=tostring(json.uri)
| where uri matches regex @"\.(?:dll|exe|zip|7z|ps1|ps|bat|sh)$"
| extend DotCount = countof(uri,".")
| extend FileExtension = strcat(".", split(uri,".",DotCount)[0])
| summarize count() by uri
```Kusto
