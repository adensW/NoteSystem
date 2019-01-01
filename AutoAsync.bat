@echo off
@echo '开始同步...'
cd C:\E_Disk\gitrepo\NoteSystem
@echo '提交所有更改'
git add -A
set  message = Auto Async at %date% %time% 
git commit -a -m message
@echo '拉取远程服务器,与本地合并'
git pull git@github.com:adensW/NoteSystem.git
@echo '推送本地到服务器'
git push git@github.com:adensW/NoteSystem.git
@echo update finish at %date% %time% 
pause