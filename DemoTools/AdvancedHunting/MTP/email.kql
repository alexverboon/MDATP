EmailEvents 
| summarize count() by FinalEmailActionPolicy

EmailEvents 
| summarize count() by DeliveryAction

EmailEvents 
| summarize count() by DeliveryLocation

EmailEvents 
| summarize count() by EmailDirection

EmailEvents 
| summarize count() by EmailLanguage

EmailEvents 
| summarize count() by FinalEmailAction

EmailEvents 
| summarize count() by FinalEmailActionPolicy

EmailEvents 
| summarize count() by tostring(MalwareDetectionMethod)

EmailEvents 
| summarize count()  by tostring(PhishDetectionMethod)


EmailEvents 
| summarize count() by MalwareFilterVerdict

EmailEvents 
| summarize count() by PhishFilterVerdict

EmailEvents 
| where UrlCount > 0
| project FinalEmailAction , FinalEmailActionPolicy , NetworkMessageId , DeliveryLocation  , MalwareFilterVerdict , PhishFilterVerdict 
| where DeliveryLocation in ("Junk folder", "Deleted items")
| join ( EmailUrlInfo
| project Url  , NetworkMessageId 
)
on NetworkMessageId 
| project Url, FinalEmailAction, FinalEmailActionPolicy , DeliveryLocation,MalwareFilterVerdict , PhishFilterVerdict ,   NetworkMessageId 

EmailEvents 
| where PhishDetectionMethod == @"[""ATP Safe Links URL Detonation""]"

EmailEvents 
| where PhishDetectionMethod == @"[""User impersonation""]"

EmailEvents 

| where PhishDetectionMethod == @"[""Malicious URL reputation""]"

EmailEvents 

| where PhishDetectionMethod == @"[""Domain impersonation""]"


EmailEvents 
| where PhishDetectionMethod == @"[""ATP Safe Links URL Detonation""]"
| project NetworkMessageId, DeliveryAction , DeliveryLocation 
| join ( EmailUrlInfo
| project Url, NetworkMessageId  )
on NetworkMessageId 
| project Url, DeliveryAction , DeliveryLocation 

EmailEvents 
| where PhishDetectionMethod == @"["" Malicious URL reputation""]"
| project NetworkMessageId, DeliveryAction , DeliveryLocation 
| join ( EmailUrlInfo
| project Url, NetworkMessageId  )
on NetworkMessageId 
| project Url, DeliveryAction , DeliveryLocation 


EmailEvents 
| where PhishDetectionMethod == @"[""Malicious URL reputation""]"
| project NetworkMessageId, DeliveryAction , DeliveryLocation 
| join ( EmailUrlInfo
| project Url, NetworkMessageId  )
on NetworkMessageId 
| project Url, DeliveryAction , DeliveryLocation 
