Function Get-WFPAuditStatus
{
<#
.Synopsis
    Executes whoami witin an MDATP Live response session

.Description
    Executes the following commands to retreive the Windows Filtering Platform Audit status

	auditpol /get /subcategory:"Filtering Platform Packet Drop" 
	auditpol /get /subcategory:"Filtering Platform Connection" 


    run the following command witin the live response session to execute the sript
    run Get-WFPAuditStatus.ps1

#>
auditpol /get /subcategory:"Filtering Platform Packet Drop" 
auditpol /get /subcategory:"Filtering Platform Connection" 
}

## Run it
Get-WFPAuditStatus