# Microsoft 365 Defender - password spray attacks

- [Alert classification for password spray attacks](https://learn.microsoft.com/en-us/microsoft-365/security/defender/alert-grading-password-spray-attack?view=o365-worldwide)

## Query

Use this query to identify password spray activity.


```Kusto
IdentityLogonEvents
| where Timestamp > ago(7d)
| where ActionType == "LogonFailed"
| where isnotempty(RiskLevelDuringSignIn)
| where AccountObjectId == <Impacted User Account Object ID>
| summarize TargetCount = dcount(AccountObjectId), TargetCountry = dcount(Location), TargetIPAddress = dcount(IPAddress) by ISP
| where TargetCount >= 100
| where TargetCountry >= 5
| where TargetIPAddress >= 25
```

Use this query to identify other activities from the alerted ISP.

```Kusto
CloudAppEvents
| where Timestamp > ago(7d)
| where AccountObjectId == <Impacted User Account Object ID>
| where ISP == <Alerted ISP>
| summarize count() by Application, ActionType, bin(Timestamp, 1h)
```

Use this query to identify sign-in patterns for the impacted user.

```Kusto
IdentityLogonEvents
| where Timestamp > ago(7d)
| where AccountObjectId == <Impacted User Account Object ID>
| where ISP == <Alerted ISP>
| where Application != "Active Directory"
| summarize SuccessCount = countif(ActionType == "LogonSuccess"), FailureCount = countif(ActionType == "LogonFailed") by ISP
```

Use this query to identify MFA fatigue attacks.

```Kusto
AADSignInEventsBeta
| where Timestamp > ago(1h)
//Error Code : 50088 : Limit on telecom MFA calls reached
//Error Code : 50074 : Strong Authentication is required.
| where ErrorCode in  ("50074","50088")
| where isnotempty(AccountObjectId)
| where isnotempty(IPAddress)
| where isnotempty(Country)
| summarize (Timestamp, ReportId) = arg_max(Timestamp, ReportId), FailureCount = count() by AccountObjectId, Country, IPAddress
| where FailureCount >= 10
```

Use this query to identify MFA reset activities.

```Kusto
let relevantActionTypes = pack_array("Disable Strong Authentication.","system.mfa.factor.deactivate", "user.mfa.factor.update", "user.mfa.factor.reset_all", "core.user_auth.mfa_bypass_attempted");
CloudAppEvents
AlertInfo
| where Timestamp > ago(1d)
| where isnotempty(AccountObjectId)
| where Application in ("Office 365","Okta")
| where ActionType in (relevantActionTypes)
| where RawEventData contains "success"
| project Timestamp, ReportId, AccountObjectId, IPAddress, ActionType



CloudAppEvents
| where Timestamp > ago(1d)
| where ApplicationId == 11161 
| where ActionType == "Update user." 
| where isnotempty(AccountObjectId)
| where RawEventData has_all("StrongAuthenticationRequirement","[]")
| mv-expand ModifiedProperties = RawEventData.ModifiedProperties
| where ModifiedProperties.Name == "StrongAuthenticationRequirement" and ModifiedProperties.OldValue != "[]" and ModifiedProperties.NewValue == "[]"
| mv-expand ActivityObject = ActivityObjects
| where ActivityObject.Role == "Target object”
| extend TargetObjectId = tostring(ActivityObject.Id)
| project Timestamp, ReportId, AccountObjectId, ActivityObjects, TargetObjectId
```

Use this query to find new email inbox rules created by the impacted user.

```Kusto
CloudAppEvents
| where AccountObjectId == <ImpactedUser>
| where Timestamp > ago(21d)
| where ActionType == "New-InboxRule"
| where RawEventData.SessionId in (suspiciousSessionIds)
```

