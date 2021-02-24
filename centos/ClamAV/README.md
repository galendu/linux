### clamav 病毒扫描

```bash
#官方网站
#https://www.clamav.net/downloads
yum -y install epel-release
yum clean all
yum -y install clamav-server clamav-data clamav-update clamav-filesystem clamav clamav-scanner-systemd clamav-devel clamav-lib clamav-server-systemd
sed -i -e "s/^Example/#Example/" /etc/clamd.d/scan.conf

#下载最新的扫描数据
freshclam
#开始扫描
clamscan -r --bell -i ${路径}

安装依赖
yum -y install gcc-c++ pcre-devel zlib-devel openssl-devel llvm-devel libxml2 libxml2-devel libcurl-devel

解压编译安装
tar zxf clamav-0.100.0.tar.gz
cd clamav-0.100.0
./configure --prefix=/opt/clamav
make && make install


#配置文件

groupadd clamav
useradd clamav -s /sbin/nologin
mkdir /opt/clamav/logs
mkdir /opt/clamav/share/update
touch /opt/clamav/logs/{freshclam.log,clamd.log}
chown -R clamav:clamav /opt/clamav/logs
chown clamav.clamav /opt/clamav/share/update

cp /opt/clamav/etc/clamd.conf.sample /opt/clamav/etc/clamd.conf
修改: clamd.conf
Example 注释掉这一行
LogFile /opt/clamav/logs/clamd.log
PidFile /opt/clamav/updata/clamd.pid
DatabaseDirectory /opt/clamav/updata/

cp /opt/clamav/etc/freshclam.conf.sample /opt/clamav/etc/freshclam.conf
修改: freshclam.conf
Example 注释掉这一行
```
