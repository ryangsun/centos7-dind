## centos7 docker-in-docker
Docker in Docker(dind) 镜像基于centos7，可用于jenkins打包编译
- 基础镜像: centos7 
- 内置用户：jenkinsbuild, 密码: jenkinsbuild, 构建文件夹: /home/jenkinsbuild/ci-jenkins
- 采用sshlogin方式登录

## 构建和使用镜像

### 构建镜像
```
./build-centos7-dind
```
### 展开容器
```
docker run -d -p 22 \
--name=centos7-dind \
-e TZ=Asia/Shanghai \
-e LANG=en_US.UTF-8  \
-v /var/run/docker.sock:/var/run/docker.sock \
-v /usr/bin/docker:/usr/bin/docker \
centos7-dind:1.0.0
```
### 将打代码copy到容器
```
scp -P \<port\> -r \<buildsourcecode\> jenkinsbuild@localhost:/home/jenkinsbuild/ci-jenkins/
```
### ssh 登录进去
```
ssh -p \<port\> jenkinsbuild@localhost  
```

### 免密登录
```
将对对应公钥copy到 /home/jenkinsbuild/ 对应位置即可。
```
