

Param(
$ProcessName
)

if([string]::IsNullOrEmpty($ProcessName))
{
    Get-Process -Name * -IncludeUserName
}
Else
{
    Get-Process -Name $ProcessName -IncludeUserName
}
