# MDE - Show users that logon with local administrative rights

Use the below queries to identify devices and users logging on with local administrative rights. 

---

## Query


```Kusto
// Show devices and users where they logon as local admin
let exclude = dynamic(['font driver host','window manager','nt service']);
DeviceLogonEvents
| where AccountDomain !in (exclude)
| where IsLocalAdmin == True
| where LogonType == @"Interactive"
| where ActionType == @"LogonSuccess"
| extend locallogon = extractjson("$.IsLocalLogon",AdditionalFields, typeof(string))
| project Timestamp, DeviceName, AccountName, AccountSid
| where isnotempty( AccountSid)
| summarize arg_max(Timestamp,*) by DeviceName, AccountName
```


```Kusto
// local logon users with Department details
let identities = IdentityInfo
| extend OnPremAccountName = AccountName
| distinct OnPremSid, AccountDisplayName, AccountDomain, OnPremAccountName, AccountUpn, Department, City, Country, IsAccountEnabled, Surname, GivenName;
let exclude = dynamic(['font driver host','window manager','nt service']);
DeviceLogonEvents
| where IsLocalAdmin == True
| where AccountDomain !in (exclude)
| where LogonType == @"Interactive"
| where ActionType == @"LogonSuccess"
| extend locallogon = extractjson("$.IsLocalLogon",AdditionalFields, typeof(string))
| project Timestamp, DeviceName, AccountName, AccountSid
| where isnotempty( AccountSid)
| summarize arg_max(Timestamp,*) by AccountName
| join kind=innerunique   (identities)
on $left. AccountSid == $right. OnPremSid
| project Timestamp, DeviceName, AccountName, AccountSid, OnPremSid, OnPremAccountName, AccountDisplayName, AccountDomain, AccountUpn, Department, City, Country, IsAccountEnabled
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