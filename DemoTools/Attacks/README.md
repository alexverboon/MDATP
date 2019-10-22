# Security Demos

This repository contains scripts and playbooks to conduct Security Demos.

## Getting Started

The "Attacker" client is running Windows 10 and is configured as following:

- Local User Account is MSF and is a local Administrator
- [MetaSploit Framework for Windows](https://github.com/rapid7/metasploit-framework/wiki/Nightly-Installers)
- Windows Defender is Disabled
- Windows Firewall is disabled
- The below folders are excluded in Windows Defender to avoid files being removed should Windows Defender be enabled.

    - C:\Temp
    - C:\Payloads
    - C:\MSFInstall
    - C:\metasploit-framework
    - C:/Users/msf/.msf4/

## MetaSploit Framework First Start

Run the following commands when starting MetaSploit for the first time

```batch
C:\metasploit-framework\bin>msfdb.bat init
```

Wait until the database is created

> Creating database at C:/Users/msf/.msf4/db
> Starting database at C:/Users/msf/.msf4/db...success
> Creating database users
> Creating initial database schema

Next start the Metasploit framework console
```batch
C:\metasploit-framework\bin>msfconsole.bat
```
If all goes well, you should see the MSF Console

