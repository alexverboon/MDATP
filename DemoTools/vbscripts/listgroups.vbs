On Error Resume Next

Set objDomain = GetObject("WinNT://corp")

WScript.echo "Domain : " + objDomain.name

For each objDomainItem in objDomain
  if objDomainItem.Class = "Group" then
     WScript.echo objDomainItem.Name 
  end if
Next