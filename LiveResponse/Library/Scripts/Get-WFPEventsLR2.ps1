#Requires -RunAsAdministrator
function Get-WFPEventsLR2{
<#
.Synopsis
   Get-WFPEvents
.DESCRIPTION
    Get-WFPEvents retrieves Windows Filtering Platform events
   
    For more details see: 
    https://docs.microsoft.com/en-us/windows/security/threat-protection/auditing/audit-filtering-platform-connection
    https://docs.microsoft.com/en-us/windows/security/threat-protection/auditing/audit-filtering-platform-packet-drop
    https://docs.microsoft.com/en-us/microsoft-365/security/defender-endpoint/host-firewall-reporting?view=o365-worldwide
    https://docs.microsoft.com/en-us/windows/security/threat-protection/auditing/event-5031
.EXAMPLE
   Get-WFPEvents
.NOTES
    v1.0, 02.11.2021, alex Verboon
#>
    [CmdletBinding()]
    Param(
        # Number of events to retrieve
        [int]
        $MaxEvents=10
    )

    Begin{
     $fweventcodes = @{
        "5031" = "The Windows Firewall Service blocked an application from accepting incoming connections on the network";
        "5150" = "The Windows Filtering Platform blocked a packet.";
        "5151" = "A more restrictive Windows Filtering Platform filter has blocked a packet";
        "5154" = "The Windows Filtering Platform has permitted an application or service to listen on a port for incoming connections."
        "5155" = "The Windows Filtering Platform has blocked an application or service from listening on a port for incoming connections.";
        "5156" = "The Windows Filtering Platform has permitted a connection."
        "5157" = "The Windows Filtering Platform has blocked a connection.";
        "5158" = " The Windows Filtering Platform has permitted a bind to a local port."
        "5159" = "The Windows Filtering Platform has blocked a bind to a local port.";
        "5152" = "The Windows Filtering Platform blocked a packet.";
        "5153" = "A more restrictive Windows Filtering Platform filter has blocked a packet.";
        }

     $protocolcodes = @{
        "1" = "Internet Control Message Protocol (ICMP)";
        "6" = "Transmission Control Protocol (TCP)";
        "17" = "User Datagram Protocol (UDP)";
        "47" = "General Routing Encapsulation (PPTP data over GRE)";
        "51" = "Authentication Header (AH) IPSec";
        "50" = "Encapsulation Security Payload (ESP) IPSec";
        "8" = "Exterior Gateway Protocol (EGP)";
        "3" = "Gateway-Gateway Protocol (GGP)";
        "20" = "Host Monitoring Protocol (HMP)";
        "88" = "Internet Group Management Protocol (IGMP)";
        "66" = "MIT Remote Virtual Disk (RVD)";
        "89" = "OSPF Open Shortest Path First";
        "12" = "PARC Universal Packet Protocol (PUP)";
        "27" = "Reliable Datagram Protocol (RDP)";
        "46" = "Reservation Protocol (RSVP) QoS";
        }
    }
    Process{
        $EventHashTable = @{
            LogName = "Security"
            ID = 5031,5150,5151,5155,5157,5159,5152,5153
        }
        $Result = [System.Collections.ArrayList]::new()
        $EventData = Get-WinEvent -FilterHashtable $EventHashTable -MaxEvents $MaxEvents -ErrorAction SilentlyContinue

        ForEach($logentry in $EventData){
        $ParsedEventLogData = [xml]$logentry[0].ToXml()
        $Detail = $ParsedEventLogData.Event.EventData.data
        $object = [PSCustomObject]@{
                    TimeCreated       = $logentry.TimeCreated
                    EventID           = $logentry.Id
                    Description       = $fweventcodes["$($Logentry.Id)"]
                    ComputerName      = $logentry.MachineName
                    ProviderName      = $logentry.ProviderName
                    TaskDisplayName   = $logentry.TaskDisplayName
                    ProviderGUID      = $ParsedEventLogData.Event.System.Provider.guid
                    ProcessID         = $Detail[0].'#Text'
                    Application       = $Detail[1].'#Text'
                    Direction         = $Detail[2].'#Text'
                    DirectionName     = if ($Detail[2].'#text' -eq "%%14592"){"Inbound"} Elseif($Detail[2].'#text' -eq "%%14593") {"Outbound"} Else{"Undefined"}
                    SourceAddress     = $Detail[3].'#Text'
                    SourcePort        = $Detail[4].'#text'
                    DestAddress       = $Detail[5].'#text'
                    DestPort          = $Detail[6].'#text'
                    Protocol          = $Detail[7].'#Text'
                    ProtocolName      = $protocolcodes["$($Detail[7].'#Text')"]
                    }
                    [void]$Result.Add($object)
        }
    }
    End{
	$Result
    }
}
Get-WFPEventsLR2 -MaxEvents 100



