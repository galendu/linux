#!/bin/bash
#author yundd by 
#this script is only for CentOS 7.x
#check the OS

platform=`uname -i`
if [ $platform != "x86_64" ];then 
echo "this script is only for 64bit Operating System !"
exit 1
fi
echo "the platform is ok"
cat << EOF
 your system is CentOS 7 x86_64  
EOF

#添加公网DNS地址
# cat >> /etc/resolv.conf << EOF
# nameserver 114.114.114.114
# EOF
#Yum源更换为国内阿里源
yum install wget  -y
mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
# wget -O  /etc/yum.repos.d/CentOS-Base-163.repo http://mirrors.163.com/.help/CentOS7-Base-163.repo
wget -O /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo
#yum重新建立缓存
yum clean all
yum makecache
#安装epel源
yum -y install epel-release
#同步时间
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
yum -y install ntp
/usr/sbin/ntpdate cn.pool.ntp.org
echo "* 4 * * * /usr/sbin/ntpdate cn.pool.ntp.org > /dev/null 2>&1" >> /var/spool/cron/root
# #清理缓存
# echo "* 4 * * *   /bin/sync;/bin/sync;/bin/sync>/proc/sys/vm/drop_caches > /dev/null 2>&1" >> /var/spool/cron/root
# echo "* 4 * * *   /bin/echo  3>/proc/sys/vm/drop_caches > /dev/null 2>&1" >> /var/spool/cron/root
systemctl  restart crond.service
#安装vim
yum -y install vim
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
#安装lrzsz实现win与linux之间的文件互相下载上传
yum -y install lrzsz

#设置最大打开文件描述符数
echo "ulimit -SHn 102400" >> /etc/rc.local
cat >> /etc/security/limits.conf << EOF
*           soft   nofile       655350
*           hard   nofile       655350
EOF


#禁用selinux
sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
setenforce 0

#关闭防火墙
systemctl disable firewalld.service 
systemctl stop firewalld.service 

#set ssh
sed -i 's/^GSSAPIAuthentication yes$/GSSAPIAuthentication no/' /etc/ssh/sshd_config
sed -i 's/#UseDNS yes/UseDNS no/' /etc/ssh/sshd_config
systemctl  restart sshd.service


#vim定义退格键可删除最后一个字符类型
echo 'alias vi=vim' >> /etc/profile
echo 'stty erase ^H' >> /etc/profile
cat >> /root/.vimrc << EOF
set tabstop=4
set shiftwidth=4
set expandtab
syntax on
set number
EOF

# update soft
yum -y update
#安装基础包
echo "-------------------开始安装基础工具----------------------"
yum groupinstall -y "base"
yum groupinstall -y "compatibility libraries"
yum groupinstall -y "debuging tools"
yum groupinstall -y "development tools"
yum install -y deltarpm gcc gcc-c++ make cmake autoconf libjpeg libjpeg-devel libpng libpng-devel freetype freetype-devel libxml2 libxml2-devel zlib zlib-devel glibc glibc-devel glib2 glib2-devel bzip2 bzip2-devel ncurses ncurses-devel libaio readline-devel curl curl-devel e2fsprogs e2fsprogs-devel krb5-devel libidn libidn-devel openssl openssl-devel libxslt-devel libicu-devel libevent-devel libtool libtool-ltdl bison gd-devel vim-enhanced pcre-devel zip unzip ntpdate patch bc expect rsync git lsof vim telnet tree nmap sysstat lrzsz dos2unix iotop iftop nethogs nload net-tools bash-completion sshpass
