# Defender for Office 365 - Post Delivery Events Actions, Delivery Location and Duration

Use the following query to see the Defender for Office 365 email information about all actions attempted on an email after delivery

---

## Query

```Kusto
// show email actions and the post delivery actions
EmailEvents 
| join (
    EmailPostDeliveryEvents
    | extend PostThreatType = ThreatTypes
    | extend PostDetectionMethod = DetectionMethods
    | extend PostTimeStamp = Timestamp
    | extend PostDeliveryLocation = DeliveryLocation
    | extend PostActionType = ActionType
    )
    on NetworkMessageId, RecipientEmailAddress
| extend PostActionDuration = PostTimeStamp - Timestamp
| project Timestamp, RecipientEmailAddress, Subject, ThreatTypes, DetectionMethods, DeliveryLocation, PostTimeStamp, PostThreatType, PostDetectionMethod, PostDeliveryLocation, PostActionType, PostActionDuration, NetworkMessageId
| where DeliveryLocation != PostDeliveryLocation


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
https://techcommunity.microsoft.com/t5/microsoft-365-defender/advanced-hunting-surfacing-more-email-data-from-microsoft/ba-p/2678118

## Contributor info

**Contributor:** Alex Verboon