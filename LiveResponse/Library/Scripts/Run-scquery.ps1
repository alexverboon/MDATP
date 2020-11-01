Function Run-scquery
{
<#
.Synopsis
    Executes sc querywitin an MDATP Live response session

.Description
    Executes sc query witin an MDATP Live response session

    Within an MDATP Live Response session run the following commands to download the content to the machine
    putfile Run-scquery.ps1

    run the following command witin the live response session to execute the sript
    run Run-sqquery.ps1

#>
Start-Process sc -ArgumentList "query" -NoNewWindow
}

## Run it
Run-scquery