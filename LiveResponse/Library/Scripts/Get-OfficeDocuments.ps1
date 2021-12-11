
Function Get-OfficeDocuments(){

$Drives = Get-PSDrive | Select-Object -ExpandProperty 'Name' | Select-String -Pattern '^[a-z]$'
$FileInfo = [System.Collections.ArrayList]::new()
$Filetypes =  @("*.docx","*.pptx","*.xlsx","*.pdf","*.doc","*.xls")
ForEach($DriveLetter in $Drives)
{
    $Drive = "$DriveLetter" + ":\"
    $DriveFiles = Get-ChildItem -Path $Drive -Include $Filetypes -Recurse -File -ErrorAction SilentlyContinue | Select-Object FullName
    [void]$FileInfo.Add($DriveFiles)
    }
$FileInfo
}
Get-OfficeDocuments



