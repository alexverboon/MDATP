# Microsoft Defender ATP - Attack Surface Reduction / Network Protection / Controlled Folder Access

## Block Executable Content Creation

### ASR Configuration Block Executable Content Creation

Use the bellow commands to configure the ASR rules

```powershell

# Enable Rule (Block)
Add-MpPreference -AttackSurfaceReductionRules_Ids '3B576869-A4EC-4529-8536-B80A7769E899' -AttackSurfaceReductionRules_Actions enable

# Disable Rule
Add-MpPreference -AttackSurfaceReductionRules_Ids '3B576869-A4EC-4529-8536-B80A7769E899' -AttackSurfaceReductionRules_Actions disable

# Enable Rule (Audit)
Add-MpPreference -AttackSurfaceReductionRules_Ids '3B576869-A4EC-4529-8536-B80A7769E899' -AttackSurfaceReductionRules_Actions AuditMode
```

Use the following commands to check the current configuration

```powershell

$mppref = Get-MpPreference
$mppref.AttackSurfaceReductionRules_Ids
$mppref.AttackSurfaceReductionOnlyExclusions
$mppref.AttackSurfaceReductionRules_Actions
```

### Sample Code Excel Marco create content

Add the following sample code to an Excel Sheet

```script

Sub Auto_Open()
    Dim fso As Object
    Set fso = CreateObject("Scripting.FileSystemObject")
    Dim oFile As Object
    Dim TmpFolder As Object
    Set TmpFolder = fso.GetSpecialFolder(2)
    Set oFile = fso.CreateTextFile(TmpFolder & "\script.vbs")
    oFile.WriteLine "Set wsh = CreateObject('wscript.shell')"
    oFile.WriteLine "wsh.Run 'calc.exe', 1"
    oFile.Close
End Sub

```


```script
Sub Button1_Click()
  
  dblShellReturn = Shell("powershell.exe", vbNormalFocus)
  BasicPath = "C:\temp\testdl.ps1"
  strCommand = "Powershell.exe -ExecutionPolicy ByPass -NoExit -File " & BasicPath
   Set WsShell = CreateObject("WScript.Shell")
   WsShell.Run (strCommand)
```script

End Sub



### Event Log

The following events are created for ASR Block/ Audit mode

* 1121 Event when rule fires in Block-mode
* 1122 Event when rule fires in Audit-mode

```powershell

$Filter=@{
    #ID=1122,1121
    LogName='Microsoft-Windows-Windows Defender/Operational'
}

#    Data='3B576869-A4EC-4529-8536-B80A7769E899'}
$events = Get-WinEvent -FilterHashtable $filter -MaxEvents 1
$events
```

## Block all Office applications from creating child processes

### ASR Configuration Block all Office applications from creating child processes

Use the bellow commands to configure the ASR rules

```powershell

# Enable Rule (Block)
Add-MpPreference -AttackSurfaceReductionRules_Ids 'D4F940AB-401B-4EFC-AADC-AD5F3C50688A' -AttackSurfaceReductionRules_Actions enable
# Disable Rule
Add-MpPreference -AttackSurfaceReductionRules_Ids 'D4F940AB-401B-4EFC-AADC-AD5F3C50688A' -AttackSurfaceReductionRules_Actions disable
# Enable Rule (Audit)
Add-MpPreference -AttackSurfaceReductionRules_Ids 'D4F940AB-401B-4EFC-AADC-AD5F3C50688A' -AttackSurfaceReductionRules_Actions AuditMode
```

Use the following commands to check the current configuration

```powershell

$mppref = Get-MpPreference
$mppref.AttackSurfaceReductionRules_Ids
$mppref.AttackSurfaceReductionOnlyExclusions
$mppref.AttackSurfaceReductionRules_Actions
```

### Sample Code Excel Marco launch powershell process

Add the following sample code to an Excel Sheet

```script
Sub Button4_Click()

    dblShellReturn = Shell("powershell.exe", vbNormalFocus)

End Sub
```

See Event log in previous section.

## Network Protection

### Network Protection Configuration

Use the bellow commands to configure network protection

```powershell
Set-MpPreference -EnableNetworkProtection Enabled
Set-MpPreference -EnableNetworkProtection AuditMode
Set-MpPreference -EnableNetworkProtection Disabled
```

Use the following commands to check the current configuration

```powershell
$networkprotectionstatus = Get-MpPreference
$networkprotectionstatus.EnableNetworkProtection
```

## Advanced Hunting Queries

### KQL - Attack Surface Reduction

```kql
MiscEvents  
| where ActionType startswith "Asr"
```

[More details](https://github.com/microsoft/WindowsDefenderATP-Hunting-Queries/blob/master/Protection%20events/ExploitGuardAsrDescriptions.txt)

### KQL - Network Protection

```kql
MiscEvents
| where  ActionType  =~ "ExploitGuardNetworkProtectionBlocked"
| summarize count(RemoteUrl) by InitiatingProcessFileName, RemoteUrl, Audit_Only=tostring(parse_json(AdditionalFields).IsAudit)
| sort by count_RemoteUrl desc
```

## Controlled Folder Access

```powershell

Set-MpPreference -EnableControlledFolderAccess Enabled
Add-MpPreference -ControlledFolderAccessAllowedApplications "c:\demoapps\test.exe"
Add-MpPreference -ControlledFolderAccessProtectedFolders "c:\demo"
```
