## ipmitool

### 安装 
```shell
 yum -y install ipmitool
```

### 帮助信息
```shell

# Specification Version: 2.0
ipmitool -h #查看帮助
#ipmitool version 1.8.18
#usage: ipmitool [options...] <command>
#-h  #打印帮助
#-V  #打印版本
#-v  #详细可以使用多次
#-c  #以逗号分隔格式显示输出
#-d N  #指定要使用的/dev/ipmiN设备（默认值= 0）
#-I intf  #使用接口
#-H hostname  #LAN接口的远程主机名称
#-p port   #远程RMCP端口[默认= 623]
#-U username  #远程会话用户名
#-f file  #从文件读取远程会话密码
#-z size  #更改通信渠道（OEM）的大小
#-S sdr   #使用本地文件进行远程SDR缓存
#-D tty:b[:s]  #指定要使用的串口设备，波特率，并可选择指定该接口是系统接口
#-4   #只使用IPv4
#-6   #只使用IPv6
#-a   #提示输入远程密码
#-Y   #提示用于IPMIv2身份验证的Kg密钥
#-e char  #设置SOL转义字符
#-C ciphersuite   #Lanplus接口使用的密码套件
#-k key   #使用Kg键进行IPMIv2验证
#-y hex_key  #使用十六进制编码的Kg密钥进行IPMIv2身份验证
#-L level    #远程会话权限级别[default = ADMINISTRATOR]在RAKP1中追加“+”以使用名称/特权查找
#-A authtype  #强制使用auth type NONE，PASSWORD，MD2，MD5或OEM
#-P password  #远程会话密码
#-E   #从IPMI_PASSWORD环境变量中读取密码
#-K   #从IPMI_KGKEY环境变量中读取kgkey
#-m address  #设置本地IPMB地址
#-b channel  #设置桥接请求的目标信道
#-t address  #桥接请求到远程目标地址
#-B channel  #设置桥接请求的传输通道（dual bridge）
#-T address  #设置桥接请求的传输地址（dual bridge）
#-l lun   #设置原始命令的目的地lun
#-o oemtype  #为OEM设置（使用“list”查看可用的OEM类型）
#-O seloem   #使用文件进行OEM SEL事件描述
#-N seconds  #指定lan [default = 2]/lanplus [default = 1]接口的超时时间
#-R retry    #设置lan/lanplus接口的重试次数[default = 4]
#
#Interfaces:
#   open  #Linux OpenIPMI接口[默认]
#   imb   #英特尔IMB接口
#   lan   #IPMI v1.5 LAN Interface 
#   lanplus  #IPMI v2.0 RMCP+ LAN Interface 
#   serial-terminal  #串行接口，终端模式
#   serial-basic   #串行接口，基本模式
#   usb   #IPMI USB接口（AMI设备的OEM接口）
#Commands:   
#   raw   #发送RAW IPMI请求并打印响应
#   i2c   #发送一个I2C主写读命令并打印响应
#   spd   #从远程I2C设备打印SPD信息
#   lan   #配置LAN信道
#   chassis  #获取机箱状态并设置电源状态
#   power    #机箱电源命令的快捷方式
#   event  #向MC发送预定义的事件
#   mc    #管理控制器状态和全局启用
#   sdr   #打印传感器数据库条目和读数
#   sensor  #打印详细的传感器信息
#   fru   #打印内置FRU并扫描FRU定位器的SDR
#   gendev   #与通用设备定位器sdr相关的读/写设备
#   sel    #打印系统事件日志（SEL）
#   pef   #配置平台事件过滤（PEF）
#   sol   #配置并连接IPMIv2.0串行LAN
#   tsol  #配置并连接Tyan IPMIv1.5 LAN上串行
#   isol  #配置IPMI v1.5 Serial-over-LAN
#   user  #配置管理控制器用户
#   channel  #配置管理控制器通道
#   session  #打印会话信息
#   dcmi   #数据中心管理接口
#   nm   #节点管理器接口
#   sunoem  #Sun服务器的OEM命令
#   kontronoem  #Kontron devices的OEM命令
#   picmg   #运行一个PICMG/ATCA扩展命令
#   fwum   #使用Kontron OEM固件更新管理器更新IPMC
#   firewall  #配置固件防火墙
#   delloem   #戴尔系统的OEM命令
#   shell   #Launch interactive IPMI shell
#   exec   #从文件运行命令列表
#   set   #为shell和exec设置运行时变量
#   hpm   #使用PICMG HPM.1文件更新HPM组件
#   ekanalyzer  #使用FRU文件运行FRU-Ekeying analyzer
#   ime   #更新英特尔管理引擎固件
#   vita  #运行VITA 46.11扩展命令
#   lan6  #配置IPv6 LAN信道

```

### 命令
```shell
# Interfaces 名称通过查看IPMI固件版本信息确定
dmidecode |grep -A  9 IPMI 
ipmitool -I lanplus -U username -P 'password' -H  6.6.10.100  lan print|grep IP

#打开电源
ipmitool -I lanplus chassis  power  on

#关闭电源
ipmitool -I lanplus chassis  power  off

#重启电源
ipmitool -I lanplus chassis  power  cycle

#重置电源
ipmitool -I lanplus chassis  power  reset

#其他配置
ipmitool -I lanplus chassis  power  diag
ipmitool -I lanplus chassis  power  soft

#查看传感器的数据
ipmitool -I lanplus sdr elist full

# pxe启动, 一般用于远程自动装机
ipmitool   chassis bootdev pxe 
# 设置硬盘启动
ipmitool   chassis bootdev disk 
# 设置光驱启动
ipmitool   chassis bootdev cdrom 
```