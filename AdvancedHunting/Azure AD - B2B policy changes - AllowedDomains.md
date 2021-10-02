# Azure AD - Allow or block invitations to B2B users

Use the following query to identify allowed domain changes in the Azure AD B2B policy. 

---

## Query

```Kusto
// Monitor allow/deny domain changes on the Azure AD B2B policy
AuditLogs
| where OperationName == "Update policy" or OperationName == 'Add policy'
| where TargetResources[0].displayName == "B2BManagementPolicy"
| extend InitiatedBy = tostring(parse_json(tostring(InitiatedBy.user)).userPrincipalName)
| extend ModifiedNew = iff(OperationName == "Update policy", (parse_json(TargetResources)[0].modifiedProperties[0].newValue),
    iff(OperationName == "Add policy", (parse_json(TargetResources)[0].modifiedProperties[1].newValue), "undefined"))
| extend ModifiedOld = iff(OperationName == "Update policy", (parse_json(TargetResources)[0].modifiedProperties[0].oldValue),
    iff(OperationName == "Add policy", (parse_json(TargetResources)[0].modifiedProperties[1].oldValue), "undefined"))
| extend newPolicy = parse_json(parse_json(tostring((ModifiedNew)))[0])
| extend newAllowedDomains = parse_json(parse_json(tostring(extractjson("$.B2BManagementPolicy", tostring(newPolicy)))).InvitationsAllowedAndBlockedDomainsPolicy).AllowedDomains
| extend oldPolicy = parse_json(parse_json(tostring((ModifiedOld)))[0])
| extend oldAllowedDomains = parse_json(parse_json(tostring(extractjson("$.B2BManagementPolicy", tostring(oldPolicy)))).InvitationsAllowedAndBlockedDomainsPolicy).AllowedDomains
| extend AddedDomain = parse_json(parse_json(set_difference(newAllowedDomains, oldAllowedDomains)))
| extend RemovedDomain = parse_json(parse_json(set_difference(oldAllowedDomains, newAllowedDomains)))
| project
    TimeGenerated,
    InitiatedBy,
    OperationName,
    AddedDomain,
    RemovedDomain,
    newAllowedDomains,
    oldAllowedDomains
| sort by TimeGenerated desc  

```



## Category

This query can be used to detect the following attack techniques and tactics ([see MITRE ATT&CK framework](https://attack.mitre.org/)) or security configuration states.

| Technique, tactic, or state | Covered? (v=yes) | Notes |
|-|-|-|
| Initial access |  |  |
| Execution |  |  |
| Persistence |  |  |
| Privilege escalation | |  |
| Defense evasion |  | |
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
https://docs.microsoft.com/en-us/azure/active-directory/external-identities/allow-deny-list

## Contributor info

**Contributor:** Alex Verboon