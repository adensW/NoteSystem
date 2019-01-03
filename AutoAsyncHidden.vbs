Set ws = CreateObject("Wscript.Shell")
dim batpath 
w=ws.CurrentDirectory
batpath = "cmd /c"+w+"\AutoAsync.bat"
ws.run batpath 
