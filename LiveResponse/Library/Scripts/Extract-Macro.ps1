<#
.SYNOPSIS
PS script to extract macro to from Excel and Word files. Also checks the macro for suspecious code patterns

.DESCRIPTION
This script will take Excel/Word file as input and extract macro code if any.
Supported filetypes: xls,xlsm,doc,docm

.PARAMETER file
Path to Excel/Word file

.PARAMETER fp
Selection of Base64 regex depending on value (0-false negative prone, 1-false positive prone)

.NOTES
  Version:        0.3
  Author:         0xm4v3rick (Samir Gadgil)
  Source:  https://github.com/0xm4v3rick/Extract-Macro/blob/master/Extract-Macro.ps1

.EXAMPLE
PS > ./Extract-Macro.ps1 C:\Sheet1.xls
PS > ./Extract-Macro.ps1 -file C:\Sheet1.xls -fp 1

#>

[CmdletBinding()]
Param (
  [Parameter(Mandatory=$True)]
  [string]$file,

  [Parameter(Mandatory=$False)]
  [int]$fp=0
)

# Heavily edited from https://github.com/enigma0x3/Generate-Macro/blob/master/Generate-Macro.ps1

function Word {
    
    Try{
        
        #Create Word document
        $Word = New-Object -ComObject "Word.Application"
        $WordVersion = $Word.Version
        $Word.Visible = $False 
        $Word.DisplayAlerts = "wdAlertsNone"

        #Disable Macro Security
        New-ItemProperty -Path "HKCU:\Software\Microsoft\Office\$WordVersion\Word\Security" -Name AccessVBOM -PropertyType DWORD -Value 1 -Force | Out-Null
        New-ItemProperty -Path "HKCU:\Software\Microsoft\Office\$WordVersion\Word\Security" -Name VBAWarnings -PropertyType DWORD -Value 1 -Force | Out-Null


        $Document = $Word.Documents.open($file,$true)
        $xlModule = $Document.VBProject.VBComponents

        foreach($module in $xlModule){
            $line = $module.CodeModule.CountOfLines
                if($line -gt 0){
                    $code = $module.CodeModule.Lines(1, $line)
                    Write-Host "======== Macro Code Start ============" -foregroundcolor "green"
                    $code 
                    Write-Host "======== Macro Code End ============" -foregroundcolor "green"
    
                    # Detecting malicous code in the Macro
                    Detection($code)

                }
        }

    
        #Cleanup
        $Word.Documents.Close()
        $Word.Quit()
        [System.Runtime.Interopservices.Marshal]::ReleaseComObject($Word) | out-null
        $Word = $Null
        #if (ps Word){kill -name Word}
    }
    Catch
    {
        $ErrorMessage = $_.Exception.Message
        $ErrorMessage
        $FailedItem = $_.Exception.ItemName
        $FailedItem
    }

    #Enable Macro Security
    New-ItemProperty -Path "HKCU:\Software\Microsoft\Office\$WordVersion\Word\Security" -Name AccessVBOM -PropertyType DWORD -Value 0 -Force | Out-Null
    New-ItemProperty -Path "HKCU:\Software\Microsoft\Office\$WordVersion\Word\Security" -Name VBAWarnings -PropertyType DWORD -Value 0 -Force | Out-Null
}

function Excel{

    Try{    

        #Create excel document
        $Excel = New-Object -ComObject "Excel.Application"
        $ExcelVersion = $Excel.Version
        $Excel.Visible = $False 
        $Excel.DisplayAlerts = "wdAlertsNone"

        #Disable Macro Security
        New-ItemProperty -Path "HKCU:\Software\Microsoft\Office\$ExcelVersion\Excel\Security" -Name AccessVBOM -PropertyType DWORD -Value 1 -Force | Out-Null
        New-ItemProperty -Path "HKCU:\Software\Microsoft\Office\$ExcelVersion\Excel\Security" -Name VBAWarnings -PropertyType DWORD -Value 1 -Force | Out-Null


        $Workbook = $Excel.Workbooks.open($file,$true)
        $xlModule = $Workbook.VBProject.VBComponents
        foreach($module in $xlModule){
            $line = $module.CodeModule.CountOfLines
                if($line -gt 0){
                    $code = $module.CodeModule.Lines(1, $line)
                    Write-Host "======== Macro Code Start ============" -foregroundcolor "green"
                    $code 
                    Write-Host "======== Macro Code End ============" -foregroundcolor "green"

                    # Detecting malicous code in the Macro
                    Detection($code)

                }
        }
    
        #Cleanup
        $Excel.Workbooks.Close()
        $Excel.Quit()
        [System.Runtime.Interopservices.Marshal]::ReleaseComObject($Excel) | out-null
        $Excel = $Null
        if (ps excel){kill -name excel}
    }

    Catch
    {
        $ErrorMessage = $_.Exception.Message
        $ErrorMessage
        $FailedItem = $_.Exception.ItemName
        $FailedItem
    }

    #Enable Macro Security
    New-ItemProperty -Path "HKCU:\Software\Microsoft\Office\$ExcelVersion\Excel\Security" -Name AccessVBOM -PropertyType DWORD -Value 0 -Force | Out-Null
    New-ItemProperty -Path "HKCU:\Software\Microsoft\Office\$ExcelVersion\Excel\Security" -Name VBAWarnings -PropertyType DWORD -Value 0 -Force | Out-Null
}

function Detection($vba){

    $keywords = @{"chr\(" = "Use of Char encoding";"Shell"="Use of shell function";"schtasks"="scheduled tasks invocation. Possible backdoor";"Document_Open"="Auto run macro Document_Open";"(?i:auto_open)"="Auto run macro Auto_Open";"(?:[A-Za-z0-9+/]{4}){1,}(?:[A-Za-z0-9+/]{2}[AEIMQUYcgkosw048]=|[A-Za-z0-9+/][AQgw]==)?"="base64 encoded strings [false positive prone]";"(?:[A-Za-z0-9+/]{4}){1,}(?:[A-Za-z0-9+/]{2}[AEIMQUYcgkosw048]=|[A-Za-z0-9+/][AQgw]==)"="Base64 encoded strings [Confirmed]";"WinHttp"="HTTP Request modules used";"(WinHttp|XMLHTTP)"="HTTP Request modules used";"https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)"="URL detected - Probable data transfer";'("(\s)*&(\s)*")'="string concatination for AV evasion";"(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])"="IP Address - Possible Data transfer"}
    
    $tabName = "SampleTable"

    #Create Table object
    $table = New-Object system.Data.DataTable “$tabName”

    #Define Columns
    $col1 = New-Object system.Data.DataColumn Checks_for,([string])
    $col2 = New-Object system.Data.DataColumn Count,([string])
    #$col3 = New-Object system.Data.DataColumn Instances,([string])

    #Add the Columns
    $table.columns.add($col1)
    $table.columns.add($col2)
    #$table.columns.add($col3)


    $tabName1 = "decodetable"

    #Create Table object
    $table1 = New-Object system.Data.DataTable "$tabName1"

    #Define Columns
    $col1 = New-Object system.Data.DataColumn EncodedText,([string])
    $col2 = New-Object system.Data.DataColumn DecodedText,([string])
    #$col3 = New-Object system.Data.DataColumn Instances,([string])

    #Add the Columns
    $table1.columns.add($col1)
    $table1.columns.add($col2)

    if ($fp) { $base="base64" } else { $base="Base64" }

    foreach($keyword in $keywords.Keys){
        
        $value = $keywords[$keyword]
        $Matches = Select-String -InputObject $vba -Pattern $keyword -AllMatches

                if(($value.StartsWith($base)) -and ($Matches.Matches.Count -gt 0) ) {
                    Write-Host "========  base64 data found ============" -foregroundcolor "green"
                    
                    foreach($EncodedText in $Matches.Matches.Value){
                    Try{
                    $DecodedText = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($EncodedText))
                    #$DecodedText

                    #Create a row
                    $row1 = $table1.NewRow()

                    #Enter data in the row
                    $row1.EncodedText = $EncodedText
                    $row1.DecodedText = $DecodedText 
            

                    #Add the row to the table
                    $table1.Rows.Add($row1)
                    }
                
                    Catch
                    {
                        #continue
                    }
                
                
                
                }
                $table1 | format-table -Wrap #-AutoSize  
        }
        #Write-Host "========  $keyword count ============"
        #$Matches.Matches.Count
        #$Matches

        #Create a row
        $row = $table.NewRow()

        #Enter data in the row
        $row.Checks_for = $value
        $row.Count =   $Matches.Matches.Count 
        #$row.Instances =   $Matches 

        #Add the row to the table
        $table.Rows.Add($row)

    }
    
    Write-Host "======== Suspecious Macro Code Patterns ============" -foregroundcolor "green"

    $table | format-table -Wrap #-AutoSize  

}

function DDECheck{
    Try{  
        $DocumentFullPathName=$file

        Add-Type -AssemblyName System.IO.Compression.FileSystem

        # This function unzips a zip file -- and it works on MS Office files directly: no need to
        # rename them from foo.xlsx to foo.zip. It expects the full path name of the zip file
        # and the path name for the unzipped files
        function Unzip
        {
            param([string]$zipfile, [string]$outpath)

            [System.IO.Compression.ZipFile]::ExtractToDirectory($zipfile, $outpath) *>$null
        }

        # Compose the name of the folder where we will unzip files
        $zipDirectoryName = $env:TEMP + "\" + "TempZip"

        # delete the zip directory if present
        remove-item $zipDirectoryName -force -recurse -ErrorAction Ignore | out-null

        # create the zip directory
        New-Item -ItemType directory -Path $zipDirectoryName | out-null

        # Unzip the files -- i.e. extract the xml files embedded within the MS Office document
        unzip $DocumentFullPathName $zipDirectoryName

        # get the docProps\core.xml file as [xml]
        $coreXmlName = $zipDirectoryName + "\word\document.xml"
        $coreXml = get-content -path $coreXmlName
        $a=$coreXml -replace '<.+?>',"`n"
        $str=$a[1].split("`n")
        $start=0
        $dde="DDE*"
        $end="Error! No topic specified*"
        foreach($s in $str){
            if(($s -like $dde) -or ($start -eq 1)){
                $start=1
                if ($s -like $end){
                break
                }
                else{
                    if($s -eq "`r"){
                    }
                    else{
                        $payload = $payload + $s
                    }
                }
            }
    }


    Write-Host "======== DDE Code Start ============" -foregroundcolor "green"
    $payload 
    Write-Host "======== DDE Code End ============" -foregroundcolor "green"


    #clean up
    remove-item $zipDirectoryName -force -recurse
    }
    Catch
    {
        $ErrorMessage = $_.Exception.Message
        $ErrorMessage
        $FailedItem = $_.Exception.ItemName
        $FailedItem
    }
}

$extn = [IO.Path]::GetExtension($file)
if (($extn -eq ".doc") -or ($extn -eq ".docm"))
{
    Word
}
elseif(($extn -eq ".docx"))
{
    DDECheck
}
elseif(($extn -eq ".xls") -or ($extn -eq ".xlsm"))
{
    Excel
}
else {
    Write-Host "Currently cannot check for this filetype..." -foregroundcolor "red"
    exit
}
