Write-Host "Retrieving Defender Configuration"
$DefenderSettings = Get-MpPreference

Write-Host "Excluded Processes"
write-host $DefenderSettings.ExclusionProcess


Write-Host "Excluded Paths"
write-host $DefenderSettings.ExclusionPath

Write-Host "Excluded Exentsions"
write-host $DefenderSettings.ExclusionExtension



