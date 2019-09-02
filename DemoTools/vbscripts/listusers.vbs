'ListUsers.vbs
On Error Resume Next

Set objDomain = GetObject("WinNT://corp")

WScript.echo "Domain : " + objDomain.name

For each objDomainItem in objDomain
  if objDomainItem.Class = "User" then
     WScript.echo objDomainItem.Name + " : Full Name: " + objDomainItem.FullName
  end if
Next