Function Dump-LRNTFSInfo
{
<#
.Synopsis
    Executes ntfsinfo64.exe witin an MDATP Live response session

.Description
    Executes ntfsinfo64.exe witin an MDATP Live response session

    ntfsinfo64.exe binaries can be downloaded from: https://docs.microsoft.com/en-us/sysinternals/downloads/ntfsinfo

    ntfsinfo64.exe and dump-LRNTFSInfo must be stored in the MDATP Script Library and downloaded
    to the remote machine  

    Within an MDATP Live Response session run the following commands to download the content to the machine

    putfile ntfsinfo64.exe
    putfile Dump-LRNTFSInfo.ps1

    Then run the following command to execute the sript

    run Dump-LRNTFSInfo.ps1
#>

If (Test-Path $PSScriptRoot\ntfsinfo64.exe -PathType Leaf)
{
    .\ntfsinfo64.exe /accepteula c:\
}
Else
{
    Write-Warning "ntfsinfo64.exe not found in $PSScriptRoot. Run 'putfile ntfsinfo64.exe'"
}
}

## Run it
Dump-LRNTFSInfo