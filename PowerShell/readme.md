# Microsoft Defender Advanced Threat Protection PowerShell Scripts

PowerShell CmdLets and code snippets to interact with Windows Defender or Microsoft Defender Advanced Threat Protection

## Microsoft Defender Advanced Threat Protection PowerShell Module

* [PSMDATP](https://github.com/alexverboon/PSMDATP)

---

## Get-DefenderATPStatus

 Get-DefenderATPStatus retrieves the Agent and configuration status of Windows Defender ATP on a Windows 10 device

```powershell
 Get-DefenderATPStatus

ComputerName                    : DESKTOP-002
OnboardingState                 : True
OSBuild                         : 18363
OSEditionID                     : Enterprise
OSProductName                   : Windows 10 Enterprise
Machinebuildnumber              : Microsoft Windows NT 10.0.18363.0
SenseID                         : 
MMAAgentService                 : not required
SenseConfigVersion              : 6999.4507483.4090661.4179641 
```

## Get-DefenderEGEvents

Get-DefenderEGEvents retrieves Windows Defender Exploit Guard related events from a Windows 10 device

## Validate-DefenderExclusion

 Validate-DefenderExclusion checks whether the specified path or file is excluded.


##https://wdtestgroundstorage.blob.core.windows.net/public/validate/validatecloud.exe

## Other PowerShell Modules

DefenderASR

find-module -name "DefenderASR" | Install-module

