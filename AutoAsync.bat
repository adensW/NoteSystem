@echo off
@echo 'start async...'
cd C:\E_Disk\gitrepo\NoteSystem
@echo 'stage all change'
git add -A
set  message = Auto Async at %date% %time% 
git commit -a -m message
@echo 'up to date'
git pull git@github.com:adensW/NoteSystem.git
@echo 'push'
git push git@github.com:adensW/NoteSystem.git
@echo update finish at %date% %time% 
pause