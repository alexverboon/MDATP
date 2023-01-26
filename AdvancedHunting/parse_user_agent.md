# Parse User Agent

[parse_user_agent()](https://learn.microsoft.com/en-us/azure/data-explorer/kusto/query/parse-useragentfunction)


---

## Query

```Kusto
(union isfuzzy=true
(
OfficeActivity
| where isnotempty( UserAgent)
| project UserAgent, Type, TimeGenerated
| extend xUA = parse_user_agent(UserAgent, dynamic(["browser","os","device"])) 
| extend BrowserFamiliy = tostring(parse_json(tostring(xUA.Browser)).Family)
| extend BrowserMajorVersion = tostring(parse_json(tostring(xUA.Browser)).MajorVersion)
| extend DeviceBrand = tostring(parse_json(tostring(xUA.Device)).Brand)
| extend OSFamily = tostring(parse_json(tostring(xUA.OperatingSystem)).Family)
| extend OSMajorVersion = tostring(parse_json(tostring(xUA.OperatingSystem)).MajorVersion)
| extend dSource = Type
| project-away xUA, UserAgent
),
(union isfuzzy=true
SigninLogs, AADNonInteractiveUserSignInLogs
| where isnotempty( UserAgent)
| project UserAgent, Category, TimeGenerated
| extend xUA = parse_user_agent(UserAgent, dynamic(["browser","os","device"])) 
| extend BrowserFamiliy = tostring(parse_json(tostring(xUA.Browser)).Family)
| extend BrowserMajorVersion = tostring(parse_json(tostring(xUA.Browser)).MajorVersion)
| extend DeviceBrand = tostring(parse_json(tostring(xUA.Device)).Brand)
| extend OSFamily = tostring(parse_json(tostring(xUA.OperatingSystem)).Family)
| extend OSMajorVersion = tostring(parse_json(tostring(xUA.OperatingSystem)).MajorVersion)
| extend dSource = Category
| project-away xUA, UserAgent
))
| project TimeGenerated, dSource,BrowserFamiliy, BrowserMajorVersion, DeviceBrand, OSFamily, OSMajorVersion
| distinct BrowserFamiliy
```


```Kusto
OfficeActivity
| where isnotempty( UserAgent)
| project UserAgent, Type, TimeGenerated
| extend xUA = parse_user_agent(UserAgent, dynamic(["browser","os","device"])) 
| extend BrowserFamiliy = tostring(parse_json(tostring(xUA.Browser)).Family)
| extend BrowserMajorVersion = tostring(parse_json(tostring(xUA.Browser)).MajorVersion)
| extend DeviceBrand = tostring(parse_json(tostring(xUA.Device)).Brand)
| extend OSFamily = tostring(parse_json(tostring(xUA.OperatingSystem)).Family)
| extend OSMajorVersion = tostring(parse_json(tostring(xUA.OperatingSystem)).MajorVersion)
| extend dSource = Type
| project TimeGenerated, dSource,BrowserFamiliy, BrowserMajorVersion, DeviceBrand, OSFamily, OSMajorVersion
```

```Kusto
union isfuzzy=true
SigninLogs, AADNonInteractiveUserSignInLogs
| where isnotempty( UserAgent)
| project UserAgent, Category,TimeGenerated
| extend xUA = parse_user_agent(UserAgent, dynamic(["browser","os","device"])) 
| extend BrowserFamiliy = tostring(parse_json(tostring(xUA.Browser)).Family)
| extend BrowserMajorVersion = tostring(parse_json(tostring(xUA.Browser)).MajorVersion)
| extend DeviceBrand = tostring(parse_json(tostring(xUA.Device)).Brand)
| extend OSFamily = tostring(parse_json(tostring(xUA.OperatingSystem)).Family)
| extend OSMajorVersion = tostring(parse_json(tostring(xUA.OperatingSystem)).MajorVersion)
| extend dSource = Category
| project TimeGenerated, dSource,BrowserFamiliy, BrowserMajorVersion, DeviceBrand, OSFamily, OSMajorVersion
```

```Kusto
let commonuseragents=dynamic(['Microsoft SkyDriveSync',
'Edge',
'Chrome',
'Mobile Safari UI/WKWebView',
'Android',
'Samsung Internet',
'IE',
'Chrome Mobile',
"Mobile Safari",
"Edge Mobile",
"Microsoft%20Teams",
"Outlook",
"SharePoint",
"OneDrive",
"OneNote",
"PowerPoint",
"Office",
'Visio']);
(union isfuzzy=true
(
OfficeActivity
| where isnotempty( UserAgent)
| project UserAgent, Type, TimeGenerated, UserId
| extend UserPrincipalName = UserId
| extend xUA = parse_user_agent(UserAgent, dynamic(["browser","os","device"])) 
| extend BrowserFamiliy = tostring(parse_json(tostring(xUA.Browser)).Family)
| extend BrowserMajorVersion = tostring(parse_json(tostring(xUA.Browser)).MajorVersion)
| extend DeviceBrand = tostring(parse_json(tostring(xUA.Device)).Brand)
| extend OSFamily = tostring(parse_json(tostring(xUA.OperatingSystem)).Family)
| extend OSMajorVersion = tostring(parse_json(tostring(xUA.OperatingSystem)).MajorVersion)
| extend dSource = Type
| project-away xUA, UserAgent
),
(union isfuzzy=true
SigninLogs, AADNonInteractiveUserSignInLogs
| where isnotempty( UserAgent)
| project UserAgent, Category, TimeGenerated, UserPrincipalName
| extend xUA = parse_user_agent(UserAgent, dynamic(["browser","os","device"])) 
| extend BrowserFamiliy = tostring(parse_json(tostring(xUA.Browser)).Family)
| extend BrowserMajorVersion = tostring(parse_json(tostring(xUA.Browser)).MajorVersion)
| extend DeviceBrand = tostring(parse_json(tostring(xUA.Device)).Brand)
| extend OSFamily = tostring(parse_json(tostring(xUA.OperatingSystem)).Family)
| extend OSMajorVersion = tostring(parse_json(tostring(xUA.OperatingSystem)).MajorVersion)
| extend dSource = Category
| project-away xUA, UserAgent
))
| project TimeGenerated, dSource,BrowserFamiliy, BrowserMajorVersion, DeviceBrand, OSFamily, OSMajorVersion, UserPrincipalName
| where BrowserFamiliy !in (commonuseragents)
// | distinct BrowserFamiliy
| where BrowserFamiliy == "Go-http-client" or BrowserFamiliy == "Java" or BrowserFamiliy == "Apache-HttpClient"
```