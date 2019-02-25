# Docker 的基本使用

## 1.安装Docker

### 1.1 Windows 安装

Windows pro 可以直接下载安装Docker Desktop,其他版本通过使用Docker Toolbox安装使用 [下载Docker ToolBox for windows](https://download.docker.com/win/stable/DockerToolbox.exe)
本文所用个人电脑是家庭版的win10,所以使用Docker Toolbox 安装

安装Toolbox完成后点击 Docker Quickstart Terminal 进行初始化

这里会遇到一些问题

问题1. 无法打开进行初始化.这个快捷方式是使用git bash 执行 ``` start.sh ``` Docker的初始化脚本.

  错误原因可能是
    1. 没有安装git.在安装toolbox的时候一般会默认选中安装git,但是被取消掉了,导致未安装.重新安装git即可.
    2. git的安装位置不是默认地址.我安装git在其他的盘,但是 Docker Quickstart Terminal 仍使用默认的c盘地址.导致失败.解决办法是修改启动路径.右键Docker Quickstart Terminal  图标 ->属性 .在快捷方式->目标里写上正确的地址.例如``` E:\software\Git\bin\bash.exe --login -i "E:\software\Docker Toolbox\start.sh" ```

问题2. 能打开无法完成初始化,报错显示翻译过来就是 bios 未启动 虚拟化选项,这个需要进bios启动这个选项就可以了

问题3. 由于某些原因导致无法下载 ``` boot2docker.iso ``` ,可以手动复制下载地址,自己想办法下载后放到 
C:\Users\{username}\.docker\machine\cache 重新执行就ok了

### 1.2 Linux 安装
CentOS 7 安装
最新版本的Docker 支持 CentOS7 及以上,CentOS 6.5 已经不在支持了
根据官方文档基本上是一遍过的[安装文档](https://docs.docker.com/install/linux/docker-ce/centos/)

1. 卸载旧版本
```
sudo yum remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-engine
```
2. 安装依赖包
```
sudo yum install -y yum-utils \
  device-mapper-persistent-data \
  lvm2
```
3. 配置标准仓库地址
```
sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo
```
4. 安装docker
```
sudo yum install docker-ce docker-ce-cli containerd.io
```
5. 启动docker
```
sudo systemctl start docker
```
检查是否安装成功,运行helloworld
```
sudo docker run hello-world
```
### 1.3 配置镜像加速
阿里云docker 镜像地址 [选择镜像加速器](https://cr.console.aliyun.com/)会自动分配一个镜像地址

Windows Toolbox 添加方法.以执行初始化之后操作方式
```
docker-machine ssh default 
sudo sed -i "s|EXTRA_ARGS='|EXTRA_ARGS='--registry-mirror=<your-mirror-address> |g" /var/lib/boot2docker/profile
exit 
docker-machine restart default
```
## 2.基本操作

### 2.1 拉取

1. 拉取官方仓库

```
docker pull user/imagename:tag
//例如
docker pull mysql
// 等同于 docker pull library/mysql:latest
// 拉取 Docker官方维护的mysql镜像
// 未写 tag 默认为latest
docker pull mysql/mysql:5.7
// 拉取 MySQL官方 维护的镜像
```
2. 拉取自建docker仓库镜像
```
docker pull [host]/[user]/imagename:tag
// 例如
docker pull http://localhost:5000/adens/mynginx:latest
```
### 2.2 构建

一个简单node.js web app例子[Dockerizing a Node.js web app](https://nodejs.org/en/docs/guides/nodejs-docker-webapp/) 
#### 2.2.0 前置条件
1. 新建一个Node.js Web App
新建 app.js
```
const express = require('express');

// Constants
const PORT = 8081;
const HOST = '0.0.0.0';

// App
const app = express();
app.get('/', (req, res) => {
  res.send('Hello world\n');
});

app.listen(PORT, HOST);
console.log(`Running on http://${HOST}:${PORT}`);
```
2. 新建一个package.json 用来描述App的基本信息和依赖项
```
{
  "name": "docker_web_app",
  "version": "1.0.0",
  "description": "Node.js on Docker",
  "author": "adens",
  "main": "app.js",
  "scripts": {
    "start": "node app.js"
  },
  "dependencies": {
    "express": "^4.16.1"
  }
}
```
可以测试运行一下,``` node app.js ``` 访问出Hello world

#### 2.2.1 .dockerfile

在项目根目录新建``` .dockerfile ``` 文件
```
FROM node:10

WORKDIR /usr/src/express

COPY package*.json ./

RUN npm install

COPY . .
ENV NODE_ENV=production \
    APP_PORT=8081
EXPOSE $APP_PORT

CMD ["npm","start"]
```

#### 2.2.2 .dockerignore

```
node_modules
npm-debug.log
```

#### 2.2.3 build
命令行运行
```
docker build -t adens/express:1 .
```
这样 一个简单的docker化的expressjs后端镜像就做好了.使用 2.3 的docker 运行命令,注意一下访问的时候就不是localhost了.而是启动docker分配给docker虚拟机的端口了.默认是192.168.99.100.通过访问192.168.99.100:8081就会输出 Hello world.这样一个简单的构建流程就完成了.

### 2.3 运行

```
docker run --name mynode --env NODE_ENV=development -p 8081:8081 adens/express:1
```
--name 赋予要运行的镜像一个别名.未使用会默认随机分配一个.
-p 将虚拟机端口8081映射到运行镜像的8081端口.
-d 后台运行,斌在启动后打印container id
--env 给.dockerfile 定义的变量赋值.

如果本地仓库没有该镜像会尝试从dockerhub 拉取下载在运行.

### 2.4 推送
```
docker pull adens/express:1
```
### 2.5 停止
```
docker stop mynode
```
### 2.6 删除
1. 删除容器
```
docker rm mynode
```
2. 删除镜像
```
docker image rm adens/express:1
```
3. 删除tag
```
docker rmi adens/express:1
```
### 2.7 其他

1. 列出所有镜像
``` 
docker images 
```
2. 列出所有容器
```
//列出正在运行的容器
docker ps
//列出所有的容器
docker ps -a
```
3. 停止运行的容器
```
docker stop mynginx
```

## 3.自建registry
1. docker 建立自己的docker 仓库也是非常简单的,直接运行官方的registry就可以完成自建仓库了.
```
docker run -d -p 5000:5000 --name registry registry:2
```
这样就运行了一个私人仓库在5000端口,通过访问``` http://localhost:5000/v2/_catalog``` 就会列出所有push到该仓库的所有镜像了
但是这个私有仓库在容器删除后所有的上传镜像都会被删除.而且也不带有验证能力

2. 创建带验证和本地保存的registry
首先使用 htpasswd 新建一个包含用户名和密码的 ```passwd ```文件,[htpasswd 参考地址](http://man.linuxde.net/htpasswd)
```
htpasswd -bc .passwd admin password
```
创建 config.yml 文件
```
version: 0.1
log:
  fields:
    service: registry
storage:
  cache:
    blobdescriptor: inmemory
  filesystem:
    rootdirectory: /var/lib/registry
  delete:
    enabled: true
http:
  addr: :5000
  headers:
    X-Content-Type-Options: [nosniff]
auth:
  htpasswd:
    realm: basic-realm
    path: /etc/registry/htpasswd
health:
  storagedriver:
    enabled: true
    interval: 10s
    threshold: 3
```
使用 -v 选项挂载本地目录到registry镜像的仓库目录

```
docker run -d -p 5000:5000 --restart=always --name registry \
             -v $PWD/registry/config.yml:/etc/docker/registry/config.yml \
              -v $PWD/registry:/var/lib/registry \
              -v $PWD/auth/htpasswd:/etc/registry/htpasswd \
             registry:2
```
-d 后台运行并打印container id
-p 映射5000端口到image的5000端口
--restart=always 始终重启
-v $PWD/registry/config.yml:/etc/docker/registry/config.yml 挂载当前目录下/registry/config.yml到image的config.yml
-v $PWD/registry:/var/lib/registry 挂载当前目录/registry 作为自建仓库的存储地址
-v $PWD/auth/htpasswd:/etc/registry/htpasswd  挂载当请目录/auth/htpasswd文件作为自建仓库的密码保存地址
这样在访问的时候都会要求登陆才行

在命令行输入
```
docker login youhost:5000
```
输入用户名和密码就可以登陆使用了
3. push到自建仓库
```
docker tag adens/express:1 127.0.0.1:5000/adens/express:1
docker push 127.0.0.1:5000/adens/express:1
```
直接push会报http: server gave HTTP response to HTTPS client 错误.docker push 是使用https进行传输的
所以最好的做法是使用一个域名并配置ssl证书进行访问


