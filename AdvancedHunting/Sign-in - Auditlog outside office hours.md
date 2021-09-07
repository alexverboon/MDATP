# Outside Office Hours activity

Use the below queries to identify sign-ins and activities that take place outside of regular office hours such as
between 6PM to 6AM or during weekends. 

---

## Query

```Kusto
// Sign-ins that happen outside of regular office hours


SigninLogs
| where TimeGenerated > ago(180d)
| extend hour = datetime_part("hour", TimeGenerated)
| extend dayofmonth = datetime_part("Day", TimeGenerated)
| extend dayofweek = toint(format_timespan(dayofweek(TimeGenerated), 'd'))
| extend dayname = case (dayofweek == 0, "Sunday",
    dayofweek == 1, "Monday",
    dayofweek == 2, "Tuesday",
    dayofweek == 3, "Wednesday",
    dayofweek == 4, "Thursday",
    dayofweek == 5, "Firday",
    dayofweek == 6, "Saturday",
    dayofweek == 7, "Sunday",
    "unknown")
| extend DeviceName = tostring(DeviceDetail.displayName)
| extend browser = tostring(DeviceDetail.browser)
| extend trustType = tostring(DeviceDetail.trustType)
| extend operatingSystem = tostring(DeviceDetail.operatingSystem)
| extend city = tostring(LocationDetails.city)
| extend state = tostring(LocationDetails.state)
| where ResultType == 0
| where hourofday(TimeGenerated) !between (6 .. 18)
    or dayofweek == 0
    or dayofweek == 6
| sort by TimeGenerated desc 
| project
    TimeGenerated,
    hour,
    dayofweek,
    dayname,
    UserPrincipalName,
    Location,
    city,
    ['state'],
    DeviceName,
    trustType,
    operatingSystem,
    browser,
    ClientAppUsed,
    AppDisplayName
// | where trustType <> "Azure AD joined"
| where AppDisplayName in ("Azure Portal", "Microsoft Exchange Online Remote PowerShell", "Microsoft Exchange REST API Based Powershell")
// | summarize count() by bin(TimeGenerated,1h), dayname
// | render timechart 
```


```Kusto
// AzureAD activities outside office hours
AuditLogs 
| where TimeGenerated > ago(134d)
| extend InitiatedUPN = tostring(parse_json(tostring(InitiatedBy.user)).userPrincipalName)
| extend InitiatedDisplayName = tostring(parse_json(tostring(InitiatedBy.user)).displayName)
| extend AppDisplayName = tostring(parse_json(tostring(InitiatedBy.app)).displayName)
| extend hour = datetime_part("hour", TimeGenerated)
| extend dayofmonth = datetime_part("Day", TimeGenerated)
| extend dayofweek = toint(format_timespan(dayofweek(TimeGenerated), 'd'))
| extend dayname = case (dayofweek == 0, "Sunday",
    dayofweek == 1, "Monday",
    dayofweek == 2, "Tuesday",
    dayofweek == 3, "Wednesday",
    dayofweek == 4, "Thursday",
    dayofweek == 5, "Firday",
    dayofweek == 6, "Saturday",
    dayofweek == 7, "Sunday",
    "unknown")
| where hourofday(TimeGenerated) !between (6 .. 18)
    or dayofweek == 0
    or dayofweek == 6
| sort by TimeGenerated desc 
| where OperationName startswith "Add"
| where isnotempty( InitiatedUPN)
| project
    TimeGenerated,
    hour,
    dayofweek,
    dayname,
    OperationName,
    InitiatedUPN,
    InitiatedDisplayName

```




## Category

This query can be used to detect the following attack techniques and tactics ([see MITRE ATT&CK framework](https://attack.mitre.org/)) or security configuration states.

| Technique, tactic, or state | Covered? (v=yes) | Notes |
|-|-|-|
| Initial access |  |  |
| Execution |  |  |
| Persistence |  |  |
| Privilege escalation | |  |
| Defense evasion |  |  |
| Credential Access |  |  |
| Discovery |  |  |
| Lateral movement |  |  |
| Collection |  |  |
| Command and control |  |  |
| Exfiltration |  |  |
| Impact |  |  |
| Vulnerability |  |  |
| Misconfiguration |  |  |
| Malware, component |  |  |

## See also

## Contributor info

**Contributor:** Alex Verboon