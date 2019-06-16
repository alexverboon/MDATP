# Microsoft Defender Advanced Threat Protection - Live Response

# Help

```
help

C:\> help
For more information on a specific command, type HELP command-name

analyze         Analyzes the entity for threats and returns a verdict (malicious, clean, suspicious)                       
cd              Changes the current folder                                                                                 
cls             Clears the console screen                                                                                  
connect         Establishes connection with the machine for the live response session                                      
connections     Shows all active connections                                                                               
dir             Shows the list of files and sub-folders in a folder                                                        
drivers         Shows all drivers installed on the machine                                                                 
fileinfo        Shows information about a file                                                                             
findfile        Locates files with a given name on the machine                                                             
getfile         Downloads a file from the machine                                                                          
help            Shows information about live response commands                                                             
library         Lists or takes action on files in the live response library                                                
persistence     Shows all known persistence methods on the machine                                                         
processes       Shows all processes running on the machine                                                                 
putfile         Uploads a file from the library to a temporary working folder on the machine                               
registry        Shows information about specific keys or values in the registry                                            
remediate       Remediates an entity on the machine. The remediation action taken will vary depending on the type of entity
run             Runs a PowerShell script from the library on the machine                                                   
scheduledtasks  Shows all scheduled tasks on the machine                                                                   
services        Shows all the services on the machine                                                                      
trace           Sets logging on this console to debug mode                                                                 
undo            Restores an entity that was remediated     
```

## Connections

```
C:\> connections
Name                            Pid     Process Name                    Local Ip        Local Port      Remote Ip       Remote Port     Status     
==========================      ====    ==========================      ========        ==========      ==============  ===========    ===========
svchost.exe                     612     svchost.exe                     0.0.0.0         135             0.0.0.0                         LISTEN     
svchost.exe                     5336    svchost.exe                     0.0.0.0         3389            0.0.0.0                         LISTEN     
svchost.exe                     4552    svchost.exe                     0.0.0.0         5040            0.0.0.0                         LISTEN     
svchost.exe                     4080    svchost.exe                     0.0.0.0         7680            0.0.0.0                         LISTEN     
lsass.exe                       836     lsass.exe                       0.0.0.0         49664           0.0.0.0                         LISTEN     
wininit.exe                     664     wininit.exe                     0.0.0.0         49665           0.0.0.0                         LISTEN     
svchost.exe                     1812    svchost.exe                     0.0.0.0         49666           0.0.0.0                         LISTEN     
spoolsv.exe                     2712    spoolsv.exe                     0.0.0.0         49667           0.0.0.0                         LISTEN     
services.exe                    808     services.exe                    0.0.0.0         49668           0.0.0.0                         LISTEN     
svchost.exe                     1340    svchost.exe                     0.0.0.0         49711           0.0.0.0                         LISTEN     
svchost.exe                     4668    svchost.exe                     0.0.0.0         49721           0.0.0.0                         LISTEN     
svchost.exe                     5336    svchost.exe                     10.1.1.4        3389            77.56.3.22      1542            ESTABLISHED
WindowsAzureGuestAgent.exe      3316    WindowsAzureGuestAgent.exe      10.1.1.4        49677           168.63.129.16   80              ESTABLISHED
WindowsAzureGuestAgent.exe      3316    WindowsAzureGuestAgent.exe      10.1.1.4        49681           168.63.129.16   32526           ESTABLISHED
WindowsAzureGuestAgent.exe      3316    WindowsAzureGuestAgent.exe      10.1.1.4        49683           52.239.136.132  443             ESTABLISHED
WaAppAgent.exe                  3160    WaAppAgent.exe                  10.1.1.4        49686           168.63.129.16   80              ESTABLISHED
svchost.exe                     3908    svchost.exe                     10.1.1.4        49797           40.67.254.36    443             ESTABLISHED
Microsoft.Photos.exe            9588    Microsoft.Photos.exe            10.1.1.4        50182           93.184.220.29   80              CLOSE_WAIT 
SenseIR.exe                     6396    SenseIR.exe                     10.1.1.4        50375           104.41.228.90   443             ESTABLISHED
OfficeClickToRun.exe            3372    OfficeClickToRun.exe            10.1.1.4        50377           13.107.5.88     443             ESTABLISHED
OfficeClickToRun.exe            3372    OfficeClickToRun.exe            10.1.1.4        50378           13.107.3.128    443             ESTABLISHED
svchost.exe                     4080    svchost.exe                     10.1.1.4        50380           13.78.187.58    443             ESTABLISHED
```

## Processes

```
C:\> processes
Name                                                                    PID     Status          User Name                       Cpu Cycles (K)  Memory (K)
==================================================================      =====   =========       ============================    ==============  ==========
Registry                                                                104     Running         NT AUTHORITY\SYSTEM
smss.exe                                                                460     Running         NT AUTHORITY\SYSTEM
csrss.exe                                                               588     Running         NT AUTHORITY\SYSTEM
wininit.exe                                                             664     Running         NT AUTHORITY\SYSTEM
csrss.exe                                                               672     Running         NT AUTHORITY\SYSTEM
winlogon.exe                                                            732     Running         NT AUTHORITY\SYSTEM             120499262652
services.exe                                                            808     Running         NT AUTHORITY\SYSTEM
lsass.exe                                                               836     Running         NT AUTHORITY\SYSTEM             16793236        6680      
svchost.exe                                                             948     Running         NT AUTHORITY\SYSTEM             35621           924       
svchost.exe                                                             972     Running         NT AUTHORITY\SYSTEM             17072889        11368     
fontdrvhost.exe                                                         996     Running         Font Driver Host\UMFD-1         6049241         1548      
fontdrvhost.exe                                                         1004    Running         Font Driver Host\UMFD-0         928119          1400      
svchost.exe                                                             612     Running         NT AUTHORITY\NETWORK SERVICE    29745660        7632      
svchost.exe                                                             884     Running         NT AUTHORITY\SYSTEM             1985268         2696      
dwm.exe                                                                 1040    Running         Window Manager\DWM-1            24410130        25420     
svchost.exe                                                             1084    Running         NT AUTHORITY\SYSTEM             82844           1000      
svchost.exe                                                             1156    Running         NT AUTHORITY\LOCAL SERVICE      979267          1484      
svchost.exe                                                             1240    Running         NT AUTHORITY\LOCAL SERVICE      84702           1420      
svchost.exe                                                             1424    Running         NT AUTHORITY\LOCAL SERVICE      53304           1284      
```

## Drivers

```
C:\> drivers
Path                                                                                                    Driver Loaded   Service Name                            Service State   Service Type              
======================================================================================================= =============   ==================================      =============== ==========================
c:\windows\system32\drivers\1394ohci.sys                                                                                1394ohci                                SERVICE_STOPPED SERVICE_KERNEL_DRIVER     
c:\windows\system32\drivers\3ware.sys                                                                                   3ware                                   SERVICE_STOPPED SERVICE_KERNEL_DRIVER     
c:\windows\system32\drivers\acpi.sys                                                                    true            ACPI                                    SERVICE_RUNNING SERVICE_KERNEL_DRIVER     
c:\windows\system32\drivers\acpidev.sys                                                                                 AcpiDev                                 SERVICE_STOPPED SERVICE_KERNEL_DRIVER     
c:\windows\system32\drivers\acpiex.sys                                                                  true            acpiex                                  SERVICE_RUNNING SERVICE_KERNEL_DRIVER     
c:\windows\system32\drivers\acpipagr.sys                                                                                acpipagr                                SERVICE_STOPPED SERVICE_KERNEL_DRIVER     
c:\windows\system32\drivers\acpipmi.sys                                                                                 AcpiPmi                                 SERVICE_STOPPED SERVICE_KERNEL_DRIVER     
c:\windows\system32\drivers\acpitime.sys                                                                                acpitime                                SERVICE_STOPPED SERVICE_KERNEL_DRIVER     
c:\windows\system32\drivers\acx01000.sys                                                                                Acx01000                                SERVICE_STOPPED SERVICE_KERNEL_DRIVER     
c:\windows\system32\drivers\adp80xx.sys                                                                                 ADP80XX                                 SERVICE_STOPPED SERVICE_KERNEL_DRIVER     
c:\windows\system32\drivers\afd.sys                                                                     true            AFD                                     SERVICE_RUNNING SERVICE_KERNEL_DRIVER     
c:\windows\system32\drivers\afunix.sys                                                                  true            afunix                                  SERVICE_RUNNING SERVICE_KERNEL_DRIVER     
c:\windows\system32\drivers\ahcache.sys                                                                 true            ahcache                                 SERVICE_RUNNING SERVICE_KERNEL_DRIVER     
c:\windows\system32\drivers\amdgpio2.sys                                                                                amdgpio2                                SERVICE_STOPPED SERVICE_KERNEL_DRIVER     
```