## dive

#### 简介: 
镜像分析工具

用于探索 Docker 映像、图层内容和发现缩小 Docker/OCI 映像大小的方法的工具。

#### 源码地址
https://github.com/wagoodman/dive

#### 安装方式
```bash
rpm  -ivh https://ghproxy.com/https://github.com/wagoodman/dive/releases/download/v0.10.0/dive_0.10.0_linux_amd64.rpm
dpkg install -f https://ghproxy.com/https://github.com/wagoodman/dive/releases/download/v0.10.0/dive_0.10.0_linux_amd64.deb
```
#### 使用

![使用示例](https://github.com/wagoodman/dive/raw/master/.data/demo.gif)

```bash
# 分析镜像
dive images-name
```