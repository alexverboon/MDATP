Function Run-LRWhoami
{
<#
.Synopsis
    Executes whoami witin an MDATP Live response session

.Description
    Executes whoami witin an MDATP Live response session

    Within an MDATP Live Response session run the following commands to download the content to the machine
    putfile Run-LRWhoami.ps1

    run the following command witin the live response session to execute the sript
    run Run-LRWhoami.ps1

#>
whoami /ALL /FO TABLE
}

## Run it
Run-LRWhoami