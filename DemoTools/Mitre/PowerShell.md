# PowerShell Execution

[PowerShell](https://attack.mitre.org/techniques/T1086/)

## A malicious PowerShell Cmdlet was invoked on the machine

A malicious PowerShell Cmdlet was invoked on the machine. The Cmdlet may be associated with credential theft, exploitation, network reconnaissance or code injection.

Inspect the process responsible for the invocation of the Cmdlet - if it is not a valid tool used by a network administrator or other expected user, remove the tool and isolate the machine from the network

## Suspicious PowerShell command line

A suspicious PowerShell activity was observed on the machine. This behavior may indicate that PowerShell was used during installation, exploration, or in some cases in lateral movement activities which are used by attackers to invoke modules, download external payloads, or get more information about the system. Attackers usually use PowerShell to bypass security protection mechanisms by executing their payload in memory without touching the disk and leaving any trace.
Recommended actions:

Examine the PowerShell commandline to understand what commands were executed. Note: the content may need to be decoded if it is base64-encoded
Search the script for more indicators to investigate - for example IP addresses (potential C&C servers), target computers etc.
Explore the timeline of this and other related machines for additional suspect activities around the time of the alert.
Look for the process that invoked this PowerShell run and their origin. Consider submitting any suspect files in the chain for deep analysis for detailed behavior information.

## Advanced hunting

```sql
// List relevant events 30 minutes before and after selected Alert event
let selectedEventTimestamp = datetime(2020-04-26T14:19:10.0273986Z);
search in (DeviceFileEvents, DeviceProcessEvents, DeviceEvents, DeviceRegistryEvents, DeviceNetworkEvents, DeviceImageLoadEvents, DeviceLogonEvents)
    Timestamp between ((selectedEventTimestamp - 30m) .. (selectedEventTimestamp + 30m))
    and DeviceId == "e5c30d8c0607564282e7714750925a7811540fab"
| sort by Timestamp desc
| extend Relevance = iff(Timestamp == selectedEventTimestamp, "Selected event", iff(Timestamp < selectedEventTimestamp, "Earlier event", "Later event"))
| project-reorder Relevance
```

```sql
// powershell cmdlets executed
DeviceEvents 
| where ActionType == "PowerShellCommand" and Timestamp > ago(7d) 
| project Timestamp, Command=tostring(parse_json(AdditionalFields).Command) 
| where Command !endswith ".ps1" and Command !startswith "Script_" 
| summarize Num=count() by Command | sort by Num asc
```

```sql
// Finds PowerShell execution events that could involve a download.
DeviceProcessEvents  
| where Timestamp > ago(7d)
| where FileName in ("powershell.exe", "POWERSHELL.EXE", "powershell_ise.exe", "POWERSHELL_ISE.EXE") 
| where ProcessCommandLine has "Net.WebClient"
        or ProcessCommandLine has "DownloadFile"
        or ProcessCommandLine has "Invoke-WebRequest"
        or ProcessCommandLine has "Invoke-Shellcode"
        or ProcessCommandLine contains "http:"
| project Timestamp, DeviceName, InitiatingProcessFileName, FileName, ProcessCommandLine
| top 100 by Timestamp
```

```sql
// PowerShell executed
DeviceEvents 
| where ActionType == "PowerShellCommand" 
| project Timestamp, Command=tostring(parse_json(AdditionalFields).Command) 
```

```sql
// PowerShell with encoded content
DeviceEvents 
| where ActionType == "PowerShellCommand"
| project Timestamp, InitiatingProcessCommandLine , Command=tostring(parse_json(AdditionalFields).Command) 
| where InitiatingProcessCommandLine contains "==" 
```

```sql
// Finds all PowerShell execution events wherein the PowerShell window has been explicitly hidden.
DeviceProcessEvents
| where InitiatingProcessFileName =~ "powershell.exe"
| where InitiatingProcessCommandLine has "-Command"
| where InitiatingProcessCommandLine has "-w hidden" or InitiatingProcessCommandLine has "-windowstyle hidden"
| project Timestamp, DeviceName, InitiatingProcessCommandLine
```

```sql
DeviceProcessEvents
| where InitiatingProcessFileName in~ ("winword.exe","excel.exe","powerpnt.exe")
// For more detailed query, that find a document file that was downloaded from the
// internet, comment out the following line. Also modify the following line if the
// document resides in a folder other than “downloads”
// | where InitiatingProcessFolderPath contains "downloads"
| where FileName =~ "powershell.exe"
```