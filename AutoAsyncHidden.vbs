Set ws = CreateObject("Wscript.Shell")
dim bat 
path=ws.CurrentDirectory
bat = "cmd /c"+path+"\AutoAsync.bat"
ws.run bat ,vbhide 
