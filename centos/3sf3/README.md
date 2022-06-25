## s3fs


### 基础

### 安装
```shell
https://ghproxy.com/https://github.com/s3fs-fuse/s3fs-fuse/archive/refs/tags/v1.91.tar.gz
yum -y install automake fuse fuse-devel gcc-c++ git libcurl-devel libxml2-devel make openssl-devel
./configure
make -j 4
make install
# 编辑/etc/profile,添加     pathmunge /usr/local/bin
source /etc/profile
```

### 使用
