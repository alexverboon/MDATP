# Disabling Security Tools

[Disabling Security Tools](https://attack.mitre.org/techniques/T1089/)

## Suspicious Windows Defender Antivirus exclusion

A process has unexpectedly modified the Windows Defender Antivirus exclusion list. Attempts to modify the exclusion list can indicate attempts to evade detection.

Check the items that have been added to the exclusion list and the process that performed the modification.

### Advanced Hunting

```sql
DeviceRegistryEvents 
| where ActionType == "RegistryValueSet"
| where RegistryKey startswith 'HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows Defender\\Exclusions'
```

```sql
DeviceProcessEvents 
| where InitiatingProcessCommandLine contains "add-mppreference"
| parse InitiatingProcessCommandLine with * '-ExclusionPath' Exclusion
| project Timestamp, DeviceName, Exclusion, FileName, ProcessCommandLine, AccountName, InitiatingProcessFileName, InitiatingProcessCommandLine, InitiatingProcessParentFileName, ReportId
```

```sql
DeviceProcessEvents
| where InitiatingProcessCommandLine contains "add-mppreference"
| parse InitiatingProcessCommandLine with * '-ExclusionPath' Exclusion
| project Timestamp, DeviceName, Exclusion, FileName, ProcessCommandLine, AccountName, InitiatingProcessFileName, InitiatingProcessCommandLine, InitiatingProcessParentFileName, ReportId
```

```sql
DeviceEvents
| where InitiatingProcessFileName == "powershell.exe"
| where AdditionalFields  has_any ("Get-MpPreference","Add-MpPreference","Set-MpPreference","Get-mpcomputerstatus")
```

### Live Response

Save the below code as defenderexclusions.ps1 and load it up to the MDATP script library

```PowerShell
Write-Host "Retrieving Defender Configuration"
$DefenderSettings = Get-MpPreference

Write-Host "Excluded Processes"
write-host $DefenderSettings.ExclusionProcess

Write-Host "Excluded Paths"
write-host $DefenderSettings.ExclusionPath

Write-Host "Excluded Exentsions"
write-host $DefenderSettings.ExclusionExtension
```

Within the live response session run the following command

```bash
run defenderexclusions.ps1
```
