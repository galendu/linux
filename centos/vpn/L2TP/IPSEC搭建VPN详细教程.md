# 依赖环境
```
yum update
yum install -y make gcc gmp-devel xmlto bison flex xmlto libpcap-devel lsof vim-enhanced man
```
# openswan（ipsec）
#### 什么是openswan呢，可以百科一下。简单的说它就是ipsec。安装openswan也就是安装ipsec。但是如果你深入去了解，就知道openswan是一套方案。我们这篇文章的目的是搭建起VPN，所以不深入探讨。
```
yum install openswan
mkdir ~/~etc
mv /etc/ipsec.conf ~/~etc/ipsec.conf
```
```
vi /etc/ipsec.conf
config setup
    nat_traversal=yes
    virtual_private=%v4:10.0.0.0/8,%v4:192.168.0.0/16,%v4:172.16.0.0/12
    oe=off
    protostack=netkey
 
conn L2TP-PSK-NAT
    rightsubnet=vhost:%priv
    also=L2TP-PSK-noNAT
 
conn L2TP-PSK-noNAT
    authby=secret
    pfs=no
    auto=add
    keyingtries=3
    rekey=no
    ikelifetime=8h
    keylife=1h
    type=transport
    left=xxx.xxx.xxx.xxx
    leftprotoport=17/1701
    right=%any
    rightprotoport=17/%any
```    
    
### 填写服务器地址
上面有一行是left=xxx.xx.xx.xx，这里要把left的值改为你的服务器的ip地址，外网可以访问的IP地址。
```
mv /etc/ipsec.secrets ~/~etc/ipsec.secrets
vi /etc/ipsec.secrets
```
然后把下面的内容放到新建的配置文件中：
```
xxx.xxx.xxx.xxx %any: PSK "YourPsk"
```
同理，上面的xxx.xxx.xxx.xxx是服务器的公网IP，而后面的"YourPsk"中的YourPsk就是密钥的内容。你可以改为自己的任意字符串。反正在你连接登录VPN的时候，是需要这个PSK的。

# 运行ipsec.
```
ipsec setup restart
chkconfig ipsec on
```
# PPP
PPP就是一个拨号软件，用来提供用户登录的用户名和密码验证用的。所以在上面那篇文章里，PPTP搭建的VPN也会用到PPP。所以，实际上，PPTP和L2TP是可以共存在一台服务器上的，而且它们还可以共享用户登录账号信息，因为它们都用PPP作为用户登录连接。
```
yum install ppp
vi /etc/ppp/chap-secrets
```
在上面的文件中新增一行：
``
username *  password  *
```
# xl2tpd
就像pptp和pptpd一样，L2TP也依赖于xl2tpd。
``
yum install xl2tpd -y
```
安装失败后使用rpm包安装
```
wget http://dl.fedoraproject.org/pub/epel/6/x86_64/xl2tpd-1.3.6-2.el6.x86_64.rpm
yum install xl2tpd-1.3.6-2.el6.x86_64.rpm

mkdir ~/~etc/xl2tpd
mv /etc/xl2tpd/xl2tpd.conf ~/~etc/xl2tpd/xl2tpd.conf
```
```
vi /etc/xl2tpd/xl2tpd.conf

[global]
ipsec saref = yes
listen-addr = xxx.xxx.xxx.xxx
[lns default]
ip range = 192.168.1.2-192.168.1.100
local ip = 192.168.1.1
refuse chap = yes
refuse pap = yes
require authentication = yes
ppp debug = yes
pppoptfile = /etc/ppp/options.xl2tpd
length bit = yes
```
```
mkdir ~/~etc/ppp
mv /etc/ppp/options.xl2tpd ~/~etc/ppp/opitons.xl2tpd
vi /etc/ppp/options.xl2tpd
```
```
require-mschap-v2
ms-dns 8.8.8.8
ms-dns 8.8.4.4
asyncmap 0
auth
crtscts
lock
hide-password
modem
debug
name l2tpd
proxyarp
lcp-echo-interval 30
lcp-echo-failure 4
```
# 启动xl2tpd服务
```
service xl2tpd restart
chkconfig xl2tpd on
```
# sysctl
sysctl的功能是开启转发。它能够将服务器内部的ip地址关系进行转发和映射，从而实现我们链接VPN之后的用户，能够通过内部的一些端口进行请求的转发。
```
vi /etc/sysctl.conf
net.ipv4.ip_forward = 1
net.ipv4.conf.default.rp_filter = 0
net.ipv4.conf.default.accept_source_route = 0
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.default.send_redirects = 0
net.ipv4.conf.all.log_martians = 0
net.ipv4.conf.default.log_martians = 0
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.default.accept_redirects = 0
net.ipv4.icmp_ignore_bogus_error_responses = 1
```
# 使上面的配置生效
sysctl -p

# 添加防火墙规则
```
iptables
iptables -A INPUT -m policy --dir in --pol ipsec -j ACCEPT
iptables -A FORWARD -m policy --dir in --pol ipsec -j ACCEPT
iptables -t nat -A POSTROUTING -m policy --dir out --pol none -j MASQUERADE
iptables -A FORWARD -i ppp+ -p all -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A INPUT -m policy --dir in --pol ipsec -p udp --dport 1701 -j ACCEPT
iptables -A INPUT -p udp --dport 500 -j ACCEPT
iptables -A INPUT -p udp --dport 4500 -j ACCEPT
iptables -t nat -A POSTROUTING -s 192.168.1.0/24 -o eth0 -j MASQUERADE
```
service iptables save
service iptables restart
# 重启ipsec
```
ipsec setup restart
ipsec verify
```
```
netstat -tunlp| grep 1701
udp        0      0 192.168.0.167:1701      0.0.0.0:*                           9784/xl2tpd  
```
