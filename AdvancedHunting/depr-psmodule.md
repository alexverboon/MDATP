# Depreciated PowerShell Modules

Use the below KQL queries to identify devices / users that are still using the depreciated PowerShell Modules

- Azure AD PowerShell 
- MSOnline PowerShell


## PowerShell Deprecation 

As we approach the end of the support period for the three PowerShell Modules - Azure AD, Azure AD Preview, and MSOnline - we want to remind you that the planned deprecation date is June 30th, 2023. Depending on the status of Azure AD API, some cmdlets might stop working after June 30th, 2023. We will continue to check usage and provide time for customers to migrate off the three PowerShell modules before retiring them. We will not retire an API/cmdlet unless we have feature parity for that API in Microsoft Graph. 

Source: [Microsoft Entra Change Announcements – March 2023 Train](https://techcommunity.microsoft.com/t5/microsoft-entra-azure-ad-blog/microsoft-entra-change-announcements-march-2023-train/ba-p/2967448)


----


## Query

```Kusto
// Search for PowerShell commands included in the PowerShell module: AzureADPreview Version:2.0.2.149)
let pscommands = dynamic (["Add-AzureADAdministrativeUnitMember","Add-AzureADApplicationOwner","Add-AzureADApplicationPolicy","Add-AzureADDeviceRegisteredOwner","Add-AzureADDeviceRegisteredUser","Add-AzureADDirectoryRoleMember","Add-AzureADGroupMember","Add-AzureADGroupOwner","Add-AzureADMSAdministrativeUnitMember","Add-AzureADMSApplicationOwner","Add-AzureADMScustomSecurityAttributeDefinitionAllowedValues","Add-AzureADMSFeatureRolloutPolicyDirectoryObject","Add-AzureADMSLifecyclePolicyGroup","Add-AzureADMSPrivilegedResource","Add-AzureADMSScopedRoleMembership","Add-AzureADMSServicePrincipalDelegatedPermissionClassification","Add-AzureADScopedRoleMembership","Add-AzureADServicePrincipalOwner","Add-AzureADServicePrincipalPolicy","Close-AzureADMSPrivilegedRoleAssignmentRequest","Confirm-AzureADDomain","Connect-AzureAD","Disconnect-AzureAD","Enable-AzureADDirectoryRole","Get-AzureADAdministrativeUnit","Get-AzureADAdministrativeUnitMember","Get-AzureADApplication","Get-AzureADApplicationExtensionProperty","Get-AzureADApplicationKeyCredential","Get-AzureADApplicationLogo","Get-AzureADApplicationOwner","Get-AzureADApplicationPasswordCredential","Get-AzureADApplicationPolicy","Get-AzureADApplicationProxyApplication","Get-AzureADApplicationProxyApplicationConnectorGroup","Get-AzureADApplicationProxyConnector","Get-AzureADApplicationProxyConnectorGroup","Get-AzureADApplicationProxyConnectorGroupMembers","Get-AzureADApplicationProxyConnectorMemberOf","Get-AzureADApplicationServiceEndpoint","Get-AzureADApplicationSignInDetailedSummary","Get-AzureADApplicationSignInSummary","Get-AzureADAuditDirectoryLogs","Get-AzureADAuditSignInLogs","Get-AzureADContact","Get-AzureADContactDirectReport","Get-AzureADContactManager","Get-AzureADContactMembership","Get-AzureADContactThumbnailPhoto","Get-AzureADContract","Get-AzureADCurrentSessionInfo","Get-AzureADDeletedApplication","Get-AzureADDevice","Get-AzureADDeviceConfiguration","Get-AzureADDeviceRegisteredOwner","Get-AzureADDeviceRegisteredUser","Get-AzureADDirectoryRole","Get-AzureADDirectoryRoleMember","Get-AzureADDirectoryRoleTemplate","Get-AzureADDirectorySetting","Get-AzureADDirectorySettingTemplate","Get-AzureADDomain","Get-AzureADDomainNameReference","Get-AzureADDomainServiceConfigurationRecord","Get-AzureADDomainVerificationDnsRecord","Get-AzureADExtensionProperty","Get-AzureADExternalDomainFederation","Get-AzureADGroup","Get-AzureADGroupAppRoleAssignment","Get-AzureADGroupMember","Get-AzureADGroupOwner","Get-AzureADMSAdministrativeUnit","Get-AzureADMSAdministrativeUnitMember","Get-AzureADMSApplication","Get-AzureADMSApplicationExtensionProperty","Get-AzureADMSApplicationOwner","Get-AzureADMSApplicationTemplate","Get-AzureADMSAttributeSet","Get-AzureADMSAuthorizationPolicy","Get-AzureADMSConditionalAccessPolicy","Get-AzureADMSCustomSecurityAttributeDefinition","Get-AzureADMSCustomSecurityAttributeDefinitionAllowedValue","Get-AzureADMSDeletedDirectoryObject","Get-AzureADMSDeletedGroup","Get-AzureADMSFeatureRolloutPolicy","Get-AzureADMSGroup","Get-AzureADMSGroupLifecyclePolicy","Get-AzureADMSGroupPermissionGrant","Get-AzureADMSIdentityProvider","Get-AzureADMSLifecyclePolicyGroup","Get-AzureADMSNamedLocationPolicy","Get-AzureADMSPasswordSingleSignOnCredential","Get-AzureADMSPermissionGrantConditionSet","Get-AzureADMSPermissionGrantPolicy","Get-AzureADMSPrivilegedResource","Get-AzureADMSPrivilegedRoleAssignment","Get-AzureADMSPrivilegedRoleAssignmentRequest","Get-AzureADMSPrivilegedRoleDefinition","Get-AzureADMSPrivilegedRoleSetting","Get-AzureADMSRoleAssignment","Get-AzureADMSRoleDefinition","Get-AzureADMSScopedRoleMembership","Get-AzureADMSServicePrincipal","Get-AzureADMSServicePrincipalDelegatedPermissionClassification","Get-AzureADMSTrustFrameworkPolicy","Get-AzureADMSUser","Get-AzureADOAuth2PermissionGrant","Get-AzureADObjectByObjectId","Get-AzureADObjectSetting","Get-AzureADPolicy","Get-AzureADPolicyAppliedObject","Get-AzureADPrivilegedRole","Get-AzureADPrivilegedRoleAssignment","Get-AzureADScopedRoleMembership","Get-AzureADServiceAppRoleAssignedTo","Get-AzureADServiceAppRoleAssignment","Get-AzureADServicePrincipal","Get-AzureADServicePrincipalCreatedObject","Get-AzureADServicePrincipalKeyCredential","Get-AzureADServicePrincipalMembership","Get-AzureADServicePrincipalOAuth2PermissionGrant","Get-AzureADServicePrincipalOwnedObject","Get-AzureADServicePrincipalOwner","Get-AzureADServicePrincipalPasswordCredential","Get-AzureADServicePrincipalPolicy","Get-AzureADSubscribedSku","Get-AzureADTenantDetail","Get-AzureADTrustedCertificateAuthority","Get-AzureADUser","Get-AzureADUserAppRoleAssignment","Get-AzureADUserCreatedObject","Get-AzureADUserDirectReport","Get-AzureADUserExtension","Get-AzureADUserLicenseDetail","Get-AzureADUserManager","Get-AzureADUserMembership","Get-AzureADUserOAuth2PermissionGrant","Get-AzureADUserOwnedDevice","Get-AzureADUserOwnedObject","Get-AzureADUserRegisteredDevice","Get-AzureADUserThumbnailPhoto","Get-CrossCloudVerificationCode","Get-RbacApplicationRoleAssignment","Get-RbacApplicationRoleDefinition","New-AzureADAdministrativeUnit","New-AzureADApplication","New-AzureADApplicationExtensionProperty","New-AzureADApplicationKeyCredential","New-AzureADApplicationPasswordCredential","New-AzureADApplicationProxyApplication","New-AzureADApplicationProxyConnectorGroup","New-AzureADDevice","New-AzureADDirectorySetting","New-AzureADDomain","New-AzureADExternalDomainFederation","New-AzureADGroup","New-AzureADGroupAppRoleAssignment","New-AzureADMSAdministrativeUnit","New-AzureADMSAdministrativeUnitMember","New-AzureADMSApplication","New-AzureADMSApplicationExtensionProperty","New-AzureADMSApplicationFromApplicationTemplate","New-AzureADMSApplicationKey","New-AzureADMSApplicationPassword","New-AzureADMSAttributeSet","New-AzureADMSConditionalAccessPolicy","New-AzureADMSCustomSecurityAttributeDefinition","New-AzureADMSFeatureRolloutPolicy","New-AzureADMSGroup","New-AzureADMSGroupLifecyclePolicy","New-AzureADMSIdentityProvider","New-AzureADMSInvitation","New-AzureADMSNamedLocationPolicy","New-AzureADMSPasswordSingleSignOnCredential","New-AzureADMSPermissionGrantConditionSet","New-AzureADMSPermissionGrantPolicy","New-AzureADMSRoleAssignment","New-AzureADMSRoleDefinition","New-AzureADMSServicePrincipal","New-AzureADMSTrustFrameworkPolicy","New-AzureADMSUser","New-AzureADObjectSetting","New-AzureADPolicy","New-AzureADPrivilegedRoleAssignment","New-AzureADServiceAppRoleAssignment","New-AzureADServicePrincipal","New-AzureADServicePrincipalKeyCredential","New-AzureADServicePrincipalPasswordCredential","New-AzureADTrustedCertificateAuthority","New-AzureADUser","New-AzureADUserAppRoleAssignment","New-RbacApplicationRoleAssignment","New-RbacApplicationRoleDefinition","Open-AzureADMSPrivilegedRoleAssignmentRequest","Remove-AzureADAdministrativeUnit","Remove-AzureADAdministrativeUnitMember","Remove-AzureADApplication","Remove-AzureADApplicationExtensionProperty","Remove-AzureADApplicationKeyCredential","Remove-AzureADApplicationOwner","Remove-AzureADApplicationPasswordCredential","Remove-AzureADApplicationPolicy","Remove-AzureADApplicationProxyApplication","Remove-AzureADApplicationProxyApplicationConnectorGroup","Remove-AzureADApplicationProxyConnectorGroup","Remove-AzureADContact","Remove-AzureADContactManager","Remove-AzureADDeletedApplication","Remove-AzureADDevice","Remove-AzureADDeviceRegisteredOwner","Remove-AzureADDeviceRegisteredUser","Remove-AzureADDirectoryRoleMember","Remove-AzureADDirectorySetting","Remove-AzureADDomain","Remove-AzureADExternalDomainFederation","Remove-AzureADGroup","Remove-AzureADGroupAppRoleAssignment","Remove-AzureADGroupMember","Remove-AzureADGroupOwner","Remove-AzureADMSAdministrativeUnit","Remove-AzureADMSAdministrativeUnitMember","Remove-AzureADMSApplication","Remove-AzureADMSApplicationExtensionProperty","Remove-AzureADMSApplicationKey","Remove-AzureADMSApplicationOwner","Remove-AzureADMSApplicationPassword","Remove-AzureADMSApplicationVerifiedPublisher","Remove-AzureADMSConditionalAccessPolicy","Remove-AzureADMSDeletedDirectoryObject","Remove-AzureADMSFeatureRolloutPolicy","Remove-AzureADMSFeatureRolloutPolicyDirectoryObject","Remove-AzureADMSGroup","Remove-AzureADMSGroupLifecyclePolicy","Remove-AzureADMSIdentityProvider","Remove-AzureADMSLifecyclePolicyGroup","Remove-AzureADMSNamedLocationPolicy","Remove-AzureADMSPasswordSingleSignOnCredential","Remove-AzureADMSPermissionGrantConditionSet","Remove-AzureADMSPermissionGrantPolicy","Remove-AzureADMSRoleAssignment","Remove-AzureADMSRoleDefinition","Remove-AzureADMSScopedRoleMembership","Remove-AzureADMSServicePrincipalDelegatedPermissionClassification","Remove-AzureADMSTrustFrameworkPolicy","Remove-AzureADOAuth2PermissionGrant","Remove-AzureADObjectSetting","Remove-AzureADPolicy","Remove-AzureADScopedRoleMembership","Remove-AzureADServiceAppRoleAssignment","Remove-AzureADServicePrincipal","Remove-AzureADServicePrincipalKeyCredential","Remove-AzureADServicePrincipalOwner","Remove-AzureADServicePrincipalPasswordCredential","Remove-AzureADServicePrincipalPolicy","Remove-AzureADTrustedCertificateAuthority","Remove-AzureADUser","Remove-AzureADUserAppRoleAssignment","Remove-AzureADUserExtension","Remove-AzureADUserManager","Remove-RbacApplicationRoleAssignment","Remove-RbacApplicationRoleDefinition","Reset-AzureADMSLifeCycleGroup","Restore-AzureADDeletedApplication","Restore-AzureADMSDeletedDirectoryObject","Revoke-AzureADSignedInUserAllRefreshToken","Revoke-AzureADUserAllRefreshToken","Select-AzureADGroupIdsContactIsMemberOf","Select-AzureADGroupIdsGroupIsMemberOf","Select-AzureADGroupIdsServicePrincipalIsMemberOf","Select-AzureADGroupIdsUserIsMemberOf","Set-AzureADAdministrativeUnit","Set-AzureADApplication","Set-AzureADApplicationLogo","Set-AzureADApplicationProxyApplication","Set-AzureADApplicationProxyApplicationConnectorGroup","Set-AzureADApplicationProxyApplicationCustomDomainCertificate","Set-AzureADApplicationProxyApplicationSingleSignOn","Set-AzureADApplicationProxyConnector","Set-AzureADApplicationProxyConnectorGroup","Set-AzureADDevice","Set-AzureADDirectorySetting","Set-AzureADDomain","Set-AzureADGroup","Set-AzureADMSAdministrativeUnit","Set-AzureADMSApplication","Set-AzureADMSApplicationLogo","Set-AzureADMSApplicationVerifiedPublisher","Set-AzureADMSAttributeSet","Set-AzureADMSAuthorizationPolicy","Set-AzureADMSConditionalAccessPolicy","Set-AzureADMSCustomSecurityAttributeDefinition","Set-AzureADMSCustomSecurityAttributeDefinitionAllowedValue","Set-AzureADMSFeatureRolloutPolicy","Set-AzureADMSGroup","Set-AzureADMSGroupLifecyclePolicy","Set-AzureADMSIdentityProvider","Set-AzureADMSNamedLocationPolicy","Set-AzureADMSPasswordSingleSignOnCredential","Set-AzureADMSPermissionGrantConditionSet","Set-AzureADMSPermissionGrantPolicy","Set-AzureADMSPrivilegedRoleAssignmentRequest","Set-AzureADMSPrivilegedRoleSetting","Set-AzureADMSRoleDefinition","Set-AzureADMSServicePrincipal","Set-AzureADMSTrustFrameworkPolicy","Set-AzureADMSUser","Set-AzureADObjectSetting","Set-AzureADPolicy","Set-AzureADServicePrincipal","Set-AzureADTenantDetail","Set-AzureADTrustedCertificateAuthority","Set-AzureADUser","Set-AzureADUserExtension","Set-AzureADUserLicense","Set-AzureADUserManager","Set-AzureADUserPassword","Set-AzureADUserThumbnailPhoto","Set-RbacApplicationRoleDefinition","Update-AzureADSignedInUserPassword"]);
DeviceEvents
| where ActionType contains "PowerShellCommand"
| where AdditionalFields has_any (pscommands)
| extend command = parse_json(AdditionalFields)
| evaluate bag_unpack(command)
| project DeviceName,InitiatingProcessAccountName, InitiatingProcessFileName, Command
| summarize PowerShellCommands = make_set(Command) by DeviceName, InitiatingProcessAccountName

```

```Kusto
// Search for PowerShell commands included in the PowerShell module: MSOnline Version:1.1.183.66)
let pscommands = dynamic (["Add-MsolAdministrativeUnitMember","Add-MsolForeignGroupToRole","Add-MsolGroupMember","Add-MsolRoleMember","Add-MsolScopedRoleMember","Confirm-MsolDomain","Confirm-MsolEmailVerifiedDomain","Connect-MsolService","Convert-MsolDomainToFederated","Convert-MsolDomainToStandard","Convert-MsolFederatedUser","Disable-MsolDevice","Enable-MsolDevice","Get-MsolAccountSku","Get-MsolAdministrativeUnit","Get-MsolAdministrativeUnitMember","Get-MsolCompanyAllowedDataLocation","Get-MsolCompanyInformation","Get-MsolContact","Get-MsolDevice","Get-MsolDeviceRegistrationServicePolicy","Get-MsolDirSyncConfiguration","Get-MsolDirSyncFeatures","Get-MsolDirSyncProvisioningError","Get-MsolDomain","Get-MsolDomainFederationSettings","Get-MsolDomainVerificationDns","Get-MsolFederationProperty","Get-MsolGroup","Get-MsolGroupMember","Get-MsolHasObjectsWithDirSyncProvisioningErrors","Get-MsolPartnerContract","Get-MsolPartnerInformation","Get-MsolPasswordPolicy","Get-MsolRole","Get-MsolRoleMember","Get-MsolScopedRoleMember","Get-MsolServicePrincipal","Get-MsolServicePrincipalCredential","Get-MsolSubscription","Get-MsolUser","Get-MsolUserByStrongAuthentication","Get-MsolUserRole","New-MsolAdministrativeUnit","New-MsolDomain","New-MsolFederatedDomain","New-MsolGroup","New-MsolLicenseOptions","New-MsolServicePrincipal","New-MsolServicePrincipalAddresses","New-MsolServicePrincipalCredential","New-MsolUser","New-MsolWellKnownGroup","Redo-MsolProvisionContact","Redo-MsolProvisionGroup","Redo-MsolProvisionUser","Remove-MsolAdministrativeUnit","Remove-MsolAdministrativeUnitMember","Remove-MsolApplicationPassword","Remove-MsolContact","Remove-MsolDevice","Remove-MsolDomain","Remove-MsolFederatedDomain","Remove-MsolForeignGroupFromRole","Remove-MsolGroup","Remove-MsolGroupMember","Remove-MsolRoleMember","Remove-MsolScopedRoleMember","Remove-MsolServicePrincipal","Remove-MsolServicePrincipalCredential","Remove-MsolUser","Reset-MsolStrongAuthenticationMethodByUpn","Restore-MsolUser","Set-MsolADFSContext","Set-MsolAdministrativeUnit","Set-MsolCompanyAllowedDataLocation","Set-MsolCompanyContactInformation","Set-MsolCompanyMultiNationalEnabled","Set-MsolCompanySecurityComplianceContactInformation","Set-MsolCompanySettings","Set-MsolDeviceRegistrationServicePolicy","Set-MsolDirSyncConfiguration","Set-MsolDirSyncEnabled","Set-MsolDirSyncFeature","Set-MsolDomain","Set-MsolDomainAuthentication","Set-MsolDomainFederationSettings","Set-MsolGroup","Set-MsolPartnerInformation","Set-MsolPasswordPolicy","Set-MsolServicePrincipal","Set-MsolUser","Set-MsolUserLicense","Set-MsolUserPassword","Set-MsolUserPrincipalName","Update-MsolFederatedDomain"]);
DeviceEvents
| where ActionType contains "PowerShellCommand"
| where AdditionalFields has_any (pscommands)
| extend command = parse_json(AdditionalFields)
| evaluate bag_unpack(command)
| project DeviceName,InitiatingProcessAccountName, InitiatingProcessFileName, Command
| summarize PowerShellCommands = make_set(Command) by DeviceName, InitiatingProcessAccountName

```

## Generating KQL queries to find PowerShell commands

The New-KQPSModulecmdlets creates kusto query to search for PowerShell commands included in the specified PowerShell module name


```PowerShell
function New-KQPSModuleFunctions
{
<#
.Synopsis
   New-KQPSModulecmdlets
.DESCRIPTION
   New-KQPSModulecmdlets creates kusto query to search for PowerShell commands
   included in the specified PowerShell module name
.PARAMETER ModuleName
    The name of the PowerShell module

.PARAMETER ImportPsd
    The path to the PowerShell module psd file

.PARAMETER Path
    The path where the generated kql query is saved

.EXAMPLE
    New-KQPSModuleFunctions -ImportPsd C:\temp\powersploit.psd1 

    This command creates a kql query including all functions included in the Powersploit 
    module and saves the query to the clipboard

.EXAMPLE
    New-KQPSModuleFunctions -ImportPsd C:\temp\powersploit.psd1 -Path C:\Temp

    This command creates a kql query including all functions included in the powersploit 
    module and saves the query to c:\temp\ps_powersploit.kql

.EXAMPLE
    New-KQPSModuleFunctions -ModuleName netsecurity

    This command creates a kql query including all functions included in the netsecurity 
    module and saves the query to the clipboard

.EXAMPLE
    New-KQPSModuleFunctions -ModuleName netsecurity -Path c:\temp

    This command creates a kql query including all functions included in the netsecurity 
    module and saves the query to c:\temp\ps_netsecurity.kql

.NOTES
    Author: Alex Verboon
    Date: 11.07.2020
    Version 1.0
#>
    [CmdletBinding()]
    Param
    (
        # PowerShell Module
        [Parameter(ParameterSetName='Module',Mandatory=$true)]
        $ModuleName,
        # The path to the PowerShell module psd1 file
        [Parameter(ParameterSetName='Import',mandatory=$true)]
        $ImportPsd,
         # The path where the kql query is saved
        [Parameter(mandatory=$false)]
        $Path
    )

    Begin{}
    Process
    {
    If ($ImportPsd){
        $psdcontent = Import-PowerShellDataFile -Path $ImportPsd
        $PsCmds = ($psdcontent.FunctionsToExport) -join '","' 
        $ModuleVersion = $psdcontent.ModuleVersion
        $ModuleName = (Split-Path $ImportPsd -Leaf).Split(".")[0]
    }
    Else{
        if (-not (Get-Module -ListAvailable -Name $ModuleName)){
        Write-Error "Specified Module $ModuleName not found"
        break} 
        $PsCmds = (get-command -Module "$ModuleName").Name -join '","' 
        $ModuleInfo = Get-Module -Name "$ModuleName"
        $ModuleVersion = $ModuleInfo.Version
    }
    $let = 'let pscommands = dynamic ([' + '"' + $PsCmds + '"' + ']);'
$kqlquery = @"
// Search for PowerShell commands included in the PowerShell module: $ModuleName Version:$ModuleVersion)
$let
DeviceEvents
| where ActionType contains "PowerShellCommand"
| where AdditionalFields has_any (pscommands)
"@
    }
    End{
        If($Path){
        If (Test-Path $Path){
            Write-Output "Saving KQL query to $path\kql_$ModuleName.kql"
            Set-Content -Path "$path\ps_$ModuleName.kql" -Value $kqlquery -Force
            }
        }
        Else{
            Write-Output "KQL query saved to clipboard"
            $kqlquery | clip
        }
   }
}
```






