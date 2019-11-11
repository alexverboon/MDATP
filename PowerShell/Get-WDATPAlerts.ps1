function Get-WDATPAlerts
<#
.Synopsis
   Get-WDATPAlerts

.DESCRIPTION
   Get-WDATPAlerts retrieves Windows Defender Advanced Threat Protection alerts exposed
   through the Windows Defender Advanced Threat Protection Alerts Rest API. 

.PARAMETER Severity
  Provides an option to filter the output by Severity. Low, Medium, High. 

.PARAMETER PastHours
 Provides an option to filter the results by past hours when the alert was created. 

.EXAMPLE
   Get-WDATPAlerts

.NOTES
 v1.0, 21.03.2019, alex verboon

#>
{
    [CmdletBinding()]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$false,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [ValidateSet('High', 'Medium', 'Low')]
        [String]$Severity,

        [Parameter(Mandatory=$false,
                   ValueFromPipelineByPropertyName=$true,
                   Position=1)]
        [ValidateSet('12', '24', '48','72','168')]
        [String]$PastHours
    )

    Begin
    {

        If ($PastHours -eq $null)
        {
            $PastHours = 24
        }

        #WDATP Alerts - Europe
        $uri = "https://wdatp-alertexporter-eu.windows.com/api/alerts"

        <#
        For EU: https://wdatp-alertexporter-eu.windows.com/api/alerts 
        For US: https://wdatp-alertexporter-us.windows.com/api/alerts 
        For UK: https://wdatp-alertexporter-uk.windows.com/api/alerts
        #>

        # Update the below variables to match the target WDATP tenant
        $OAuthUri = "https://login.windows.net/<TENANTIT>/oauth2/token"
        $ClientID = ""
        $ClientSecret = ""
    
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
         #resource = "https://api.securitycenter.windows.com"

        $Body = @{
        resource = "https://graph.windows.net"
        client_id = $ClientID
        client_secret = $ClientSecret
        grant_type = 'client_credentials'
        redirectUri = "https://localhost:8000"
        }
        $Response = Invoke-RestMethod -Method Post -Uri $OAuthUri -Body $Body
        $Authorization = Invoke-RestMethod -Method Post -Uri $OAuthUri -Body $Body -ContentType "application/x-www-form-urlencoded" -UseBasicParsing
        $access_token = $Authorization.access_token 
        $Headers = @{ Authorization = "Bearer $($Response.access_token)"}

    }
    Process
    {
        
        # Define the time range from till now
        $dateTime = (Get-Date).ToUniversalTime().AddHours(-$PastHours).ToString("o")      
        $body = @{
        #sinceTimeUtc="2019-03-01T00:00:00.000"
        sinceTimeUtc=$dateTime
        }

        #Write-output  $Results
        $output = Invoke-RestMethod -Uri $uri -Headers $Headers -Body $Body -Method Get -Verbose -ContentType application/json
    }
    End
    {
        If ([string]::IsNullOrEmpty($Severity))
        {
            $output
        }
        Else
        {
            $output | Where-Object Severity -eq "$Severity"
        }
    }
}