#Requires -Module ExchangeOnlineManagement
<#
.DESCRIPTION
   This script checks if any accepted domains are whitelisted in anti-spam policy and prepares 
   the KQL query for further analysis in Microsoft 365 Defender.
.INPUTS
   None. You cannot pipe objects to the script.
.OUTPUTS
   KQL query to check if mails in the past were affected.
.NOTES
   Script created to check if an envirionment is affected by roadmap change 93436
   https://www.microsoft.com/de-ch/microsoft-365/roadmap?owM365RoadmapSearchInput=93436&owM365RoadmapSearchButton=&filters=&searchterms=93436

   Authors: Yves Fankhauser, Alex Verboon
   Version 1.0.0

.ROLE
   Service Account need Security reader role.
.FUNCTIONALITY
   
#>
#Establish Exchange online conneciton
Connect-ExchangeOnline
#Get all accepted (owned) domains of the organization
$OwnedDomains = Get-AcceptedDomain | Select DomainName
#Get content of all filter policy
$Policies = Get-HostedContentFilterPolicy
$AllowedDomain = @()
$AllowedSenderDomain = @()
$AllowedSenderAddress = @()
$OwnedDomainInAllowedDomain = @()
$OwnedDomainInAllowedAllowedSenderDomain= @()

#Save all allowed (whitelisted) domains & users into an array
ForEach($policy in $Policies){
    $AllowedDomain += $policy.AllowedSenderDomains.Domain
    $AllowedSenderDomain += $policy.AllowedSenders.Sender.Domain
    #$AllowedSenderAddress += $policy.AllowedSenders.Sender.Address
}

#check if any accepted (owned) domain or user is whitelisted
$OwnedDomains | ForEach-Object{
    If ($AllowedDomain -contains $_.DomainName){
        Write-Host "$($_.DomainName) is in the allowed domain list"
        $OwnedDomainInAllowedDomain += $_.DomainName
    }
    If ($AllowedUser -contains $_.DomainName){
        Write-Host "User(s) from the domain $($_.DomainName) is in the allowed domain list"
        $OwnedDomainInAllowedAllowedSenderDomain += $_.DomainName
    }
}
Disconnect-ExchangeOnline -confirm:$false

$pOwneddomains         = ($OwnedDomains.DomainName -join '","')
$letowneddomains     = 'let owneddomains = dynamic ([' + '"' + $pOwneddomains + '"' + ']);'

$pAllowedDomains       = ($AllowedDomain -join '","')
$letalloweddomains     = 'let alloweddomains = dynamic ([' + '"' + $pAllowedDomains + '"' + ']);'

$pAllowedSenderDomain   = ($AllowedSenderDomain -join '","')
$letAllowedSenderDomain = 'let AllowedSenderDomain = dynamic ([' + '"' + $pAllowedSenderDomain + '"' + ']);'

#$pAllowedSenderAddress   = ($AllowedSenderAddress -join '","')
#$letAllowedSenderAddress = 'let AllowedSenderAddress = dynamic ([' + '"' + $pAllowedSenderAddress + '"' + ']);'

$pOwnedDomainInAllowedDomain = ($OwnedDomainInAllowedDomain -join '","')
$letOwnedDomainInAllowedDomain = 'let OwnedDomainInAllowedDomain = dynamic ([' + '"' + $pOwnedDomainInAllowedDomain + '"' + ']);'

$pOwnedDomainInAllowedAllowedSenderDomain = ($OwnedDomainInAllowedAllowedSenderDomain -join '","')
$letpOwnedDomainInAllowedAllowedSenderDomain = 'let OwnedDomainInAllowedAllowedSenderDomain = dynamic ([' + '"' + $pOwnedDomainInAllowedAllowedSenderDomain + '"' + ']);'


$kqlquery = @"
// owned domains
$letowneddomains
// Allowed Domains
$letalloweddomains
// Allowed Sender Domains
$letAllowedSenderDomain
// Allowed Sender Addresses
// $letAllowedSenderAddress
// Owned domains that are in the allowed domain list
$letOwnedDomainInAllowedDomain
// Owned domains that are in the allowed sender domain list
$letpOwnedDomainInAllowedAllowedSenderDomain
EmailEvents 
|where Timestamp > ago (30d) 
| where SenderFromDomain in (OwnedDomainInAllowedDomain)
//| where SenderFromDomain in (OwnedDomainInAllowedAllowedSenderDomain)
| project Timestamp, AR=parse_json(AuthenticationDetails) , NetworkMessageId, EmailDirection, Subject, SenderFromAddress, SenderIPv4, DeliveryLocation , OrgLevelAction, OrgLevelPolicy, UserLevelPolicy, UserLevelAction
| evaluate bag_unpack(AR) 
| where DeliveryLocation contains "Inbox"
| where EmailDirection == @"Inbound"
| where OrgLevelAction contains "Allow"
| where OrgLevelPolicy == @"Sender domain list (Safe domain / Blocked domain)"
| where DKIM != "pass" or SPF != "pass" or DMARC != 'pass'
| where DMARC == 'fail'
"@

$kqlquery | clip
Write-Host "KQL query saved to clipboard"