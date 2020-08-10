## nodejs部署
## 下载安装二进制包
https://nodejs.org/en/download/
## 解压tar -xvf node-*
## 重命名
mv node-v10.6.0-linux-x64 nodejs
## 通过建立软连接变为全局
1 ln -s /usr/local/application/nodejs/bin/npm /usr/local/bin/
2 ln -s /usr/local/application/nodejs/bin/node /usr/local/bin/

## node -v 检查是否成功安装

## 安装脚本
```
#!/bin/bash
set -ex
cd /opt
wget https://nodejs.org/dist/v12.18.2/node-v12.18.2-linux-x64.tar.xz
tar xf node-* nodejs
ln -s /usr/local/application/nodejs/bin/npm /usr/local/bin/
ln -s /usr/local/application/nodejs/bin/node /usr/local/bin/
node -v && echo "success"
```

## 处理npm ERR! Unexpected end of JSON input while parsing near ...

`npm cache clean --force`
