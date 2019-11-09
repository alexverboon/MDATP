function Download-DefenderUpdates
{
<#
.Synopsis
   Download-DefenderUpdates
.DESCRIPTION
   Download-DefenderUpdates downloads the latest defender updates into the 
   specified path. 

   Create a scheduled task that executes Powershell -ExecutionPolicy Bypass \<scriptpath>\Download-DefenderUpdates.ps1
   
.PARAMETER Path
 The path to store the defender updates
.EXAMPLE
   Download-DefenderUpdates
.EXAMPLE
   Download-DefenderUpdates
.NOTES
    Author: Alex Verboon
    Version: 1.0
    Date: 07.11.2019
    Source: https://demo.wd.microsoft.com/

#>
    [CmdletBinding()]
    [Alias()]
    [OutputType([int])]
    Param
    (
        # Path where Defender updates are stored
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        $Path="c:\wdav-update"
    )

    Begin
    {
        Write-Verbose "Defender updates download path: $path"
        $vdmpathbase = "$Path\{00000000-0000-0000-0000-"
        $vdmpathtime = Get-Date -format "yMMddHHmmss"
        $vdmpath = $vdmpathbase + $vdmpathtime + '}'
        $vdmpackage = $vdmpath + '\mpam-fe.exe'
        $args = @("/x")
    }
    Process
    {
        Try{
            Write-Verbose "Creating directory $vdmpath"
            New-Item -ItemType Directory -Force -Path $vdmpath | Out-Null
        }
        Catch{
            Write-Error "Error creating Defender Download Path $Path"
            Break
        }
      
        Try
        {
            Write-Verbose "Downloading Defender update package to $vdmpackage"
            Invoke-WebRequest -Uri 'https://go.microsoft.com/fwlink/?LinkID=121721&arch=x64' -OutFile $vdmpackage
        }
        Catch{
            Write-Error "Error downloading Defender Updates"
        }        
        
        Try{
            Write-Verbose "Extracting $vdmpackage to $vdmpath"
            cmd /c "cd $vdmpath & c: & mpam-fe.exe /x" 
        }
        Catch
        {
            Write-Error "Error extracting defender update content"
        }
    }
    End
    {
    }
}
