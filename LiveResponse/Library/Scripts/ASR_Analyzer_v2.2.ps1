$RulesIds = Get-MpPreference | Select-Object -ExpandProperty AttackSurfaceReductionRules_Ids
$RulesActions = Get-MpPreference | Select-Object -ExpandProperty AttackSurfaceReductionRules_Actions
$RulesExclusions = Get-MpPreference | Select-Object -ExpandProperty AttackSurfaceReductionOnlyExclusions

$RulesIdsArray = @()
$RulesIdsArray += $RulesIds

$counter = 0
$TotalNotConfigured = 0
$TotalAudit = 0
$TotalBlock = 0

ForEach ($i in $RulesActions){
    If ($RulesActions[$counter] -eq 0){$TotalNotConfigured++}
    ElseIf ($RulesActions[$counter] -eq 1){$TotalBlock++}
    ElseIf ($RulesActions[$counter] -eq 2){$TotalAudit++}
    $counter++
}

Write-Host 
Write-Host ====================================== ASR Summary ======================================

Write-Host "=> There's"($RulesIds).Count"rules configured"
Write-Host "=>"$TotalNotConfigured "in Disabled Mode **" $TotalAudit "in Audit Mode **" $TotalBlock "in Block Mode"

Write-Host 
Write-Host ====================================== ASR Rules ======================================

$counter = 0

ForEach ($j in $RulesIds){
    ## Convert GUID into Rule Name
    If ($RulesIdsArray[$counter] -eq "D4F940AB-401B-4EFC-AADC-AD5F3C50688A"){$RuleName = "Block all Office applications from creating child processes"}
    ElseIf ($RulesIdsArray[$counter] -eq "5BEB7EFE-FD9A-4556-801D-275E5FFC04CC"){$RuleName = "Block execution of potentially obfuscated scripts"}
    ElseIf ($RulesIdsArray[$counter] -eq "92E97FA1-2EDF-4476-BDD6-9DD0B4DDDC7B"){$RuleName = "Block Win32 API calls from Office macro"}
    ElseIf ($RulesIdsArray[$counter] -eq "3B576869-A4EC-4529-8536-B80A7769E899"){$RuleName = "Block Office applications from creating executable content"}
    ElseIf ($RulesIdsArray[$counter] -eq "75668C1F-73B5-4CF0-BB93-3ECF5CB7CC84"){$RuleName = "Block Office applications from injecting code into other processes"}
    ElseIf ($RulesIdsArray[$counter] -eq "D3E037E1-3EB8-44C8-A917-57927947596D"){$RuleName = "Block JavaScript or VBScript from launching downloaded executable content"}
    ElseIf ($RulesIdsArray[$counter] -eq "BE9BA2D9-53EA-4CDC-84E5-9B1EEEE46550"){$RuleName = "Block executable content from email client and webmail"}
    ElseIf ($RulesIdsArray[$counter] -eq "01443614-cd74-433a-b99e-2ecdc07bfc25"){$RuleName = "Block executable files from running unless they meet a prevalence, age, or trusted list criteria"}
    ElseIf ($RulesIdsArray[$counter] -eq "c1db55ab-c21a-4637-bb3f-a12568109d35"){$RuleName = "Use advanced protection against ransomware"}
    ElseIf ($RulesIdsArray[$counter] -eq "9e6c4e1f-7d60-472f-ba1a-a39ef669e4b2"){$RuleName = "Block credential stealing from the Windows local security authority subsystem (lsass.exe)"}
    ElseIf ($RulesIdsArray[$counter] -eq "d1e49aac-8f56-4280-b9ba-993a6d77406c"){$RuleName = "Block process creations originating from PSExec and WMI commands"}
    ElseIf ($RulesIdsArray[$counter] -eq "b2b3f03d-6a65-4f7b-a9c7-1c7ef74a9ba4"){$RuleName = "Block untrusted and unsigned processes that run from USB"}
    ElseIf ($RulesIdsArray[$counter] -eq "26190899-1602-49e8-8b27-eb1d0a1ce869"){$RuleName = "Block Office communication applications from creating child processes"}
    ElseIf ($RulesIdsArray[$counter] -eq "7674ba52-37eb-4a4f-a9a1-f0f9a1619a2c"){$RuleName = "Block Adobe Reader from creating child processes"}
    ElseIf ($RulesIdsArray[$counter] -eq "e6db77e5-3df2-4cf1-b95a-636979351e5b"){$RuleName = "Block persistence through WMI event subscription"}
    ## Check the Action type
    If ($RulesActions[$counter] -eq 0){$RuleAction = "Disabled"}
    ElseIf ($RulesActions[$counter] -eq 1){$RuleAction = "Block"}
    ElseIf ($RulesActions[$counter] -eq 2){$RuleAction = "Audit"}
    ## Output Rule Id, Name and Action
    Write-Host "=>" $RulesIdsArray[$counter] " **" $RuleName "**" "Action:"$RuleAction
    $counter++
}

Write-Host 
Write-Host ====================================== ASR Exclusions ======================================

$counter = 0

## Output ASR exclusions
ForEach ($f in $RulesExclusions){
    Write-Host "=>" $RulesExclusions[$counter]
    $counter++
    }
