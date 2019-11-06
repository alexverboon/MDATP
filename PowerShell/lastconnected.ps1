$reg = "HKLM:\Software\Microsoft\Windows Advanced Threat Protection\Status"
$lastconnected = Get-itempropertyvalue $reg -Name LastConnected
[datetime]::fromFiletime([int64]::parse($lastconnected))