function Validate-DefenderExclusion
<#
.Synopsis
   Validate-DefenderExclusion
.DESCRIPTION
   Validate-DefenderExclusion checks whether the specified path or file is excluded. 
   The cmdlet will return the following information

   - The path of the specified folder or file
   - The result of the check, True, False or PathNotFound 

.PARAMETER Path
  Specifies a path to a folder or file to be checked
.EXAMPLE

    Validate-DefenderExclusion -Path C:\AutomatedLab-VMs

    Path                Excluded
    ----                --------
    C:\AutomatedLab-VMs True    

    This command checks whether the specified folder has a Defender Exclusion 

.NOTES
   1.0, 21.03.2019, alex verboon
#>
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [ValidateNotNullOrEmpty()] 
        [string]$Path
    )
    Begin
    {
        If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
            [Security.Principal.WindowsBuiltInRole] “Administrator”))
        {
            Write-Warning “You do not have Administrator rights to run this script!`nPlease re-run this script as an Administrator!”
            Break
        }
        
        # Find the current most recent path of the Defender mpcmdrun.exe
        $DefenderPlatformPath = "C:\ProgramData\Microsoft\Windows Defender\Platform"
        $mpcmdrunpath = (Get-ChildItem  -Path "$DefenderPlatformPath\*\mpcmdrun.exe" | Select-Object * -Last 1).FullName

        If ([string]::IsNullOrEmpty($mpcmdrunpath))
        {
            Write-Error "Unable to locate mpcmdrun.exe"
        }
    }
    Process
    {
        $cmdArg =  "-CheckExclusion -Path $($Path)"
        $CheckResult = Start-Process -FilePath "$mpcmdrunpath" -ArgumentList "$cmdArg" -NoNewWindow -PassThru -Wait 
        #$CheckResult.ExitCode

        switch ($CheckResult.ExitCode)
        {
            0 { $Excluded = "True"}
            1 { $Excluded = "False"}
            2 { $Excluded = "PathNotFound"}
        }

    $Result = [ordered]@{
    Path = $Path
    Excluded = $Excluded
    }
    $output = (New-Object -TypeName PSObject -Property $Result)        

    }
    End
    {
        $output
    }
}