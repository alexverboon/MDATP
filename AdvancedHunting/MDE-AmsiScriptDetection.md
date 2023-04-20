# Defender for Endpoint - AmsiScript Execution - Decode PowerShell commands

Run the below KQL query to decode powershell commands detected by AMSI
---

## Query

```Kusto
// Decode PowerShell AmsiScriptDetection's
DeviceEvents  
| where ActionType == @"AmsiScriptDetection"
| extend EncodedCommand = extract(@'\s+([A-Za-z0-9+/]{20}\S+$)', 1, InitiatingProcessCommandLine)
| extend DecodedCommand = base64_decode_tostring(EncodedCommand)
| where isnotempty( DecodedCommand)
| project Timestamp, DeviceName, InitiatingProcessFileName,FileName,DecodedCommand 
```

## Contributor info

**Contributor:** Alex Verboon
