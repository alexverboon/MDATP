# WDAC Block List

Use the below query to identify processes that are on Microsoft's recommended WDAC block list

---

## Query

```Kusto
// WDAC block list - https://docs.microsoft.com/en-us/windows/security/threat-protection/windows-defender-application-control/microsoft-recommended-block-rules
// Identify processes that are on the WDAC recommended block list
let wdacblock = (externaldata(lolbin: string)
    [@"https://raw.githubusercontent.com/alexverboon/MDATP/master/AdvancedHunting/Externaldata/wdacblockrules.txt"] 
    with (format="txt", ignoreFirstRecord=true));
DeviceProcessEvents 
| where FileName in (wdacblock) or InitiatingProcessFileName in (wdacblock)
| project Timestamp, DeviceName, FileName, InitiatingProcessFileName, InitiatingProcessParentFileName, ProcessCommandLine, InitiatingProcessCommandLine, AccountName, InitiatingProcessAccountName
```

```kql
// another approach shared by Kim Oppalfens - @TheWMIGuy
let wdacblock = (externaldata(lolbin: string)
    [@"https://raw.githubusercontent.com/MicrosoftDocs/windows-itpro-docs/public/windows/security/threat-protection/windows-defender-application-control/microsoft-recommended-block-rules.md"] 
    with (format="txt", ignoreFirstRecord=true));
wdacblock
| where lolbin has '<Deny ID="ID_DENY_'
| extend lolbinxml = parse_xml(lolbin)
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

**Contributor:** Alex Verboon, Kim Oppalfens - @TheWMIGuy