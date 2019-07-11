<#
.Synopsis
   CI_DefenderMAPS_Discovery
.DESCRIPTION
    Script for Configuration Manager - Configuration Item

    The CI_DefenderMAPS_Discovery script checks whether the client
    can successfully communicate communicate with the Windows 
    Defender Antivirus cloud service (MAPS)

    https://docs.microsoft.com/en-us/windows/security/threat-protection/windows-defender-antivirus/configure-network-connections-windows-defender-antivirus
.NOTES
    v1.0, 11.07.2019, alex verboon
#>

$DefenderPlatformPath = "C:\ProgramData\Microsoft\Windows Defender\Platform"
$mpcmdrunpath = (Get-ChildItem  -Path "$DefenderPlatformPath\*\mpcmdrun.exe" -ErrorAction SilentlyContinue | Select-Object * -Last 1).FullName
If ([string]::IsNullOrEmpty($mpcmdrunpath))
{
    return $false
}
Else
{
    $cmdArg =  "-validatemapsconnection"
    $CheckResult = Start-Process -FilePath "$mpcmdrunpath" -ArgumentList "$cmdArg" -WindowStyle Hidden -PassThru -Wait 
    $MAPSConnectivity = switch ($CheckResult.ExitCode)
        {
            0 { $true}
            default {$false}
        }
            If ($MAPSConnectivity -eq "True")
            {
            return $true
            }
            Else
            {
                return $false
            }
}

