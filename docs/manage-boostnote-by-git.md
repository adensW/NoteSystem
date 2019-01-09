# 带版本控制和同步功能的笔记系统

使用BoostNote笔记软件+Git+github+bat脚本+Windows定时任务创建一个多端同步非即时带版本管理的笔记同步系统
BoostNote支持使用第三方云盘服务进行同步的功能.设置方法就是把笔记保存地址放在同步云盘服务的文件夹下,例如OneDriver.云盘同步了,它的笔记也就同步了.多省时省力的方法.但是生命不止,折腾不息.云盘都没有一个版本管理的功能.所以,就折腾一个带版本管理的笔记系统.一下都在github公有库上实现.如果由私有需求的可以自己建立私有的git服务器或者购买私有的github仓库.

## 1 基本思路
BoostNote基本设置就是把文件保存在同步盘的文件夹下就没他的事了,其他的都是同步盘的工作.
所以将文件保存在git文件夹下,启用git版本管理,同时使用git的pull,push实现同步的功能.
但是每次同步都需要手动去pull,push就不是我想要的了.必须自动的pull,和push才行.所以使用bat脚本和Windows定时任务去实现自动pull和push的操作

## 2 BoostNote设置和Git设置

这个没什么好说的.就是创建一个GIt 仓库.和设置BoostNote的存储地址为git的工作目录.
本文使用的是github公共库作为同步和版本管理的储存库.如果有私密要求的话,可以自建一个git服务或者购买git的私有库.

## 3 使用Bat脚本自动push和pull
新建一个bat文件放到git工作目录下面

``` 
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
@echo 同步成功. %date% %time% 
pause
```
手动点击测试,流程走完就OK了.

## 4 建立自动任务

1.快捷键 win+R 输入 taskschd.msc.打开任务计划程序
2.创建任务.输入任务名称.(随意写).
3.点触发器,新建.创建一个或多个触发器.这里基本上就按照个人需求进行填写.
    要是想尽可能快速的同步.开始任务就选登陆时,,高级设置里勾上重复任务间隔.一小时或者更低.持续时间无期限
    要是没有必要很高的要求的话.开始任务选按预定计划.设置每天的时间.
    触发器可以建立多个.我建立了两个触发器,中午一次,晚上一次.
4.点操作,新建.选择刚才创建的bat脚本.
5.条件和设置里可以选择当电脑空闲,以及在某些网络下面运行任务.可忽略不考虑.

以上所有的步骤就ok了.现在可以使用BoostNote写笔记.等待计划任务执行bat脚本.执行完就同步以及更新了所有的笔记.还有了版本管理的功能.这个功能基本上就是使用git来操作了.
### 4.1 隐藏 运行bat脚本的Dos窗口

使用vbs脚本运行bat脚本.
1.新建vbs结尾的文件.输入代码
```
Set ws = CreateObject("Wscript.Shell") 
ws.run "cmd /c AutoAsyncMission.bat" ,vbhide
```
放到同步脚本同一文件下.
将计划任务改为运行这个脚本.就ok了

更新: 计划任务执行这个脚本路径为~\system32> 导致到不到AutoAsyncMission.bat脚本.即不运行bat脚本.同时在计划任务里也显示已运行.需要提供完整的bat脚本路径
```
Set ws = CreateObject("Wscript.Shell") 
ws.run "cmd /c C:\E_Disk\gitrepo\NoteSystem\AutoAsyncMission.bat" ,vbhide
```
注意一下bat脚本之前就是先运行了 ``` cd C:\E_Disk\gitrepo\NoteSystem ``` 进入git文件夹下.

## 5 被忽略的问题

1.更新的时候可能会出现合并冲突.需要手动解决.
2.我本地的github key是没有密码的.如果生成ssh key 的时候有密码,每次更新就需要输入密码.

## 6 扩展
图片仓库.经常的需要导入一些图片在我们的笔记中.就需要一个图床.现在可以直接使用git.

首先在这个git项目下建立一个文件夹.ImageStorage.把图片放进去
文档插入图片地址修改一下
比如本地的地址为:
{C:\E_Disk\gitrepo\NoteSystem}mageStorage\ExampleIMG.jpg
文档里插入远程的地址为
{https://raw.githubusercontent.com/adensW/NoteSystem/master/}ImageStorage/ExampleIMG.jpg

对比一下就是将本地GIt项目地址之前的的路径(上文{}里面的地址)换成github查看原始数据的地址
![ExampleIMG.jpg](https://raw.githubusercontent.com/adensW/NoteSystem/master/ImageStorage/ExampleIMG.jpg)