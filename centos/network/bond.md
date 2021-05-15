#### 1.开启bond模块
- enp0s8, and enp0s9
```bash
modprobe --first-time bonding
modinfo bonding
```
#### 2.创建bond0配置文件
```bash
vi /etc/sysconfig/network-scripts/ifcfg-bond0
DEVICE=bond0
NAME=bond0
TYPE=Bond
BONDING_MASTER=yes
IPADDR=192.168.1.150
PREFIX=24
ONBOOT=yes
BOOTPROTO=none
BONDING_OPTS="mode=1 miimon=100"


vi /etc/sysconfig/network-scripts/ifcfg-enp0s8
HWADDR="08:00:27:04:03:86"
TYPE="Ethernet"
BOOTPROTO="none"
DEFROUTE="yes"
PEERDNS="yes"
PEERROUTES="yes"
IPV4_FAILURE_FATAL="no"
IPV6INIT="yes"
IPV6_AUTOCONF="yes"
IPV6_DEFROUTE="yes"
IPV6_PEERDNS="yes"
IPV6_PEERROUTES="yes"
IPV6_FAILURE_FATAL="no"
NAME="enp0s8"
UUID="a97b23f2-fa87-49de-ac9b-39661ba9c20f"
ONBOOT="yes"
MASTER=bond0
SLAVE=yes

vi /etc/sysconfig/network-scripts/ifcfg-enp0s9
HWADDR=08:00:27:E7:ED:8E
TYPE=Ethernet
BOOTPROTO=none
DEFROUTE=yes
PEERDNS=yes
PEERROUTES=yes
IPV4_FAILURE_FATAL=no
IPV6INIT=yes
IPV6_AUTOCONF=yes
IPV6_DEFROUTE=yes
IPV6_PEERDNS=yes
IPV6_PEERROUTES=yes
IPV6_FAILURE_FATAL=no
NAME=enp0s9
UUID=e2352c46-e1f9-41d2-98f5-af24b127b3e7
ONBOOT=yes
MASTER=bond0
SLAVE=yes

#启动网卡 enp0s8  enp0s9
ifup ifcfg-enp0s8
ifup ifcfg-enp0s9

#加载配置
nmcli con reload

#重启网卡
systemctl restart network

```
