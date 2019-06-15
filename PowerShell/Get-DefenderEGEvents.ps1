function Get-DefenderEGEvents
{
<#
.Synopsis
   Get-DefenderEGEvents

.DESCRIPTION
   Get-DefenderEGEvents retrieves Windows Defender Exploit Guard related events

.PARAMETER Component
    When not specified all Exploit Guard related events are retrieved. Otherwise use

    CFA for Controlled Folder Access
    NP for Network Protection
    ASR for Attack Surface Rules

    The current version of this function does not yet include events
    for Exploit Protetion. 


.PARAMETER EGMode
    Filter for Audit or Block Events

.PARAMETER MaxEvents
    Specifies the maximum number of events that Get-DefenderEGEvents returns. Enter an integer. The default is to return 
    all the Windows Defender Exploit Guard events in the logs.

#>
    [CmdletBinding()]

    Param
    (
        # Exploit Guard Component selection
        [Parameter(Mandatory=$false,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [ValidateSet('ASR', 'CFA','NP')]
        $Component,

        [Parameter(Mandatory=$false,
                   ValueFromPipelineByPropertyName=$true,
                   Position=1)]
        [ValidateSet('Audit', 'Block')]
        $EGMode,

        # MaxEvents
        [Parameter(Mandatory=$false,
                ValueFromPipelineByPropertyName=$true,
                Position=2)]
        [int]
        $MaxEvents
    )

    Begin
    {

    If ($Component)
    {
        $EGComponent = "EG"+"$Component"
    }


    #Controlled Folder Access
    # 1124 Audit
    # 1123 Block

    # Network Protection
    # 1125 Audit
    # 1126 Block

    # Attack Surface Rules
    # 1121 Block
    # 1122 Audit

        $log = @{
        Providername = "Microsoft-Windows-Windows Defender"
        ID = "1123","1124","1125","1126","1121","1122"
        }
    }
    Process
    {
        $output = @()
            If ($MaxEvents)
            {
                $events = Get-WinEvent -FilterHashtable $log -MaxEvents $MaxEvents
                Write-Verbose "Total $($events.count)"
            }
            Else
            {
                $events = Get-WinEvent -FilterHashtable $log
                Write-Verbose "Total $($events.count)"
            }
        
        ForEach ($event in $events)
        {
            Switch ($event.Id)
            {
             1124  { $Source = "EGCFA" ; $Mode = "Audit"}
             1123  { $Source = "EGCFA" ; $Mode = "Block"}
             1125  { $Source = "EGNP";  $Mode = "Audit"}
             1126  { $Source = "EGNP" ; $Mode = "Block"}
             1121  { $Source = "EGASR" ; $Mode = "Block"}
             1122  { $Source = "EGASR" ; $Mode = "Audit"}

            Default {$Source = "None" ; $Mode = "None"}
            }
            $event | Add-Member -MemberType NoteProperty -Name "EGSource" -Value "$Source" 
            $event | Add-Member -MemberType NoteProperty -Name "EGMode" -Value "$Mode" 
            $output = $output + $event
        }
    }
    End
    {

        If ($Component)
        {
            Write-Verbose "Component: $($Component)"

            If ($EGMode)
            {
                Write-Verbose "Mode: $($EGMode)"
                $output | Where-Object {$_.EGSource -eq "$EGComponent" -and $_.EGMode -eq "$EGMode"}
            }
            Else
            {
                Write-Verbose "Component: $($Component) with no MODE"
                $output | Where-Object {$_.EGSource -eq "$EGComponent"}
            }
        }
        Else
        {
            If ($EGMode)
            {
                Write-Verbose "Mode: $($EGMode) with no component"
                $output | Where-Object {$_.EGMode -eq "$EGMode"}
            }
            Else
            {
                Write-Verbose "All"
                $output 
            }
        }
        
}
}
