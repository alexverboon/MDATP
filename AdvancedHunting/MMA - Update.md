# Mandatory update of MMA agent on Windows devices for Microsoft Defender for Endpoint

Upgrade to the latest version of the Windows Log Analytics / SCOM agent (MMA) by February 1st, 2023

Microsoft Defender for Endpoint (MDE) running on Windows 7 SP1, Windows 8.1, Windows Server 2008 R2 and Windows Server 2012 R2/2016 (that have not yet been upgraded to the unified solution) has a dependency on the Microsoft Monitoring Agent (MMA).

[Message Center](https://admin.microsoft.com/Adminportal/Home?source=applauncher&ref=MessageCenter/:/messages/MC455194)




## Query

To identify affected machines in your environment, you can run the following query in advanced hunting:


```Kusto

// MMA Agents end of life
DeviceTvmSoftwareInventory
| where SoftwareName == "monitoring_agent"
| where (SoftwareVersion startswith "10.22" and parse_version(SoftwareVersion) < parse_version("10.22.10056.0"))
    or (SoftwareVersion startswith "10.20" and parse_version(SoftwareVersion) < parse_version("10.20.18053.0"))
    or (parse_version(SoftwareVersion) < parse_version("10.19.101770.0"))
```

