# Microsoft Defender for Endpoint - Tamper Protection

Run the below queries to find Microsoft Defender tampering attempts

## Query Information


```
DeviceEvents
| where TimeGenerated > ago (30d)
| where ActionType == @"TamperingAttempt"
| extend AF = parse_json(AdditionalFields)
| evaluate bag_unpack(AF,columnsConflict='keep_source') : (DeviceName:string,TimeGenerated:datetime,ActionType:string,Status:string, TamperingAction:long,Target:string)
```

#### MITRE ATT&CK Technique(s)

| Technique ID | Title    | Link    |
| ---  | --- | --- |
| T1562.001 | Disable or Modify Tools | https://attack.mitre.org/techniques/T1562/001/ |


### References

- [Introducing tamper protection for exclusions](https://techcommunity.microsoft.com/t5/microsoft-defender-for-endpoint/introducing-tamper-protection-for-exclusions/ba-p/3713761)

- [Protect security settings with tamper protection](https://learn.microsoft.com/en-us/microsoft-365/security/defender-endpoint/prevent-changes-to-security-settings-with-tamper-protection?view=o365-worldwide)

- [Current limits of Defender AV Tamper Protection](https://cloudbrothers.info/en/current-limits-defender-av-tamper-protection/)



## Contributor info

**Contributor:** Alex Verboon








