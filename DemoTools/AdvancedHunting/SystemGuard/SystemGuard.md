# Advanced Hunting queries for System Guard runtime attestation

Reference article: [How insights from system attestation and advanced hunting can improve enterprise security](https://techcommunity.microsoft.com/t5/Microsoft-Defender-ATP/How-insights-from-system-attestation-and-advanced-hunting-can/ba-p/969252)

```kql
MiscEvents
| where ActionType == “DeviceBootAttestationInfo”
```

This will return each row in the MiscEvents table that matches the ActionType of DeviceBootAttestationInfo with the boot attestation data itself in the AdditionalFields column.  We can then extract that data using the parse_json() function.

```kql
MiscEvents
| where ActionType == "DeviceBootAttestationInfo"
| extend AdditionalFieldData = parse_json(AdditionalFields)
```

The following advanced hunting query can be used as a basis for determining which machines are candidates for improvement:

```kql
// Establish a baseline SystemGuardSecurityLevel and show the machines that are below that baseline
let TargetSecurityLevel = 700;
MiscEvents
| where EventTime >= ago(30d)
| where ActionType == "DeviceBootAttestationInfo"
| extend AdditionalFieldData = parse_json(AdditionalFields)
| project ComputerName, ReportTime = todatetime(AdditionalFieldData.ReportValidityStartTime), CurrentSecurityLevel = toint(AdditionalFieldData.SystemGuardSecurityLevel), AdditionalFieldData.ReportValidityStartTime
| where CurrentSecurityLevel < TargetSecurityLevel
| summarize arg_max(ReportTime, CurrentSecurityLevel) by ComputerName
```

The next example is a custom query that identifies machines exhibiting a drop in SystemGuardSecurityLevel across boot sessions:

```kql
// Goal: Find machines in the last N days where the SystemGuardSecurityLevel value NOW is less than it was BEFORE
// Step 1: Get a list of all security levels in the system where the level is not null
let SecurityLevels = MiscEvents
    | where ActionType == "DeviceBootAttestationInfo"
    | extend AdditionalFieldData = parse_json(AdditionalFields)
    | project MachineId, EventTime, SystemGuardSecurityLevel = toint(AdditionalFieldData.SystemGuardSecurityLevel), ReportId
    | where isnotnull(SystemGuardSecurityLevel);
// Step 2: Get the *latest* record for *each* machine from the SecurityLevels table
let LatestLevelsPerMachine = SecurityLevels
    | summarize arg_max(EventTime, SystemGuardSecurityLevel) by MachineId
    | project MachineId, LatestSystemGuardSecurityLevel=SystemGuardSecurityLevel, LatestEventTime=EventTime;
// Step 3: Join the two tables together where the LatestSystemGuardSecurityLevel is LESS than the SystemGuardSecurityLevel 
let MachinesExhibitingSecurityLevelDrop = LatestLevelsPerMachine
    | join (
        SecurityLevels
    ) on MachineId
    | project-away MachineId1
    | where LatestSystemGuardSecurityLevel < SystemGuardSecurityLevel 
    | summarize arg_max(EventTime, LatestSystemGuardSecurityLevel, SystemGuardSecurityLevel, LatestEventTime, ReportId) by MachineId;
MachinesExhibitingSecurityLevelDrop
```
## My Samples

```kql
MiscEvents
| where ActionType == "DeviceBootAttestationInfo"
| extend IsSecureBootOn = tolower(tostring(parsejson(AdditionalFields).IsSecureBootOn))
| extend IsHvciOn = tolower(tostring(parsejson(AdditionalFields).IsHvciOn))
| extend IsVsmOn = tolower(tostring(parsejson(AdditionalFields).IsVsmOn))
| extend IsIommuOn = tolower(tostring(parsejson(AdditionalFields).IsIommuOn))
| extend TpmVersion = tolower(tostring(parsejson(AdditionalFields).TpmVersion))
| extend SystemGuardSecurityLevel = tolower(tostring(parsejson(AdditionalFields).SystemGuardSecurityLevel))
| extend IsDriverCodeIntegrityEnforced = tolower(tostring(parsejson(AdditionalFields).IsDriverCodeIntegrityEnforced))
| extend IsElamDriverLoaded = tolower(tostring(parsejson(AdditionalFields).IsElamDriverLoaded))
| extend ValidationResult = tolower(tostring(parsejson(AdditionalFields).ValidationResult))
| project ComputerName , IsSecureBootOn, IsHvciOn , IsVsmOn , IsIommuOn , SystemGuardSecurityLevel , ValidationResult 
```kql

