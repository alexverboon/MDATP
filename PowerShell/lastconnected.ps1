# Last MDE Connection Timestamp
$reg = "HKLM:\Software\Microsoft\Windows Advanced Threat Protection\Status"
$lastconnected = Get-itempropertyvalue $reg -Name LastConnected
[datetime]::fromFiletime([int64]::parse($lastconnected))


# Last connection to MDE Channel - attempt
$reg = "HKLM:\SOFTWARE\Microsoft\SenseCM"
$lastconnected = Get-itempropertyvalue $reg -Name LastCheckinAttempt
[datetime]::fromFiletime([int64]::parse($lastconnected))

# Last connection to MDE Channel - success
$reg = "HKLM:\SOFTWARE\Microsoft\SenseCM"
$lastconnected = Get-itempropertyvalue $reg -Name LastCheckinSuccess
[datetime]::fromFiletime([int64]::parse($lastconnected))


# maps
$reg = "HKLM:\SOFTWARE\Microsoft\Windows Defender\Spynet"
$lastconnected = Get-itempropertyvalue $reg -Name LastMAPSSuccessTime
[datetime]::fromFiletime([int64]::parse($lastconnected))
