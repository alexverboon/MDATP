# just a few lines of PS Code that pulls AD object information

# Collect AD object information
$allusers = (New-Object DirectoryServices.DirectorySearcher “ObjectCategory=user”).FindAll() | Select path
$allcomputers = (New-Object DirectoryServices.DirectorySearcher “ObjectClass=Computer”).FindAll() | Select path
$allous = (New-Object DirectoryServices.DirectorySearcher “ObjectClass=OrganizationalUnit”).FindAll() | Select path
$allgroups = (New-Object DirectoryServices.DirectorySearcher “ObjectClass=Group”).FindAll() | Select path

$allusers
$allcomputers
$allous
$allgroups